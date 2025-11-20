
SELECT * FROM dbo.Album
SELECT * FROM dbo.Artist
SELECT * FROM dbo.ArtistTrack
SELECT * FROM dbo.Payment
SELECT * FROM dbo.Playlist
SELECT * FROM dbo.PlaylistTrack
SELECT * FROM dbo.Subscription
SELECT * FROM dbo.SubscriptionPlan
SELECT * FROM dbo.Track
SELECT * FROM dbo.[User]
SELECT * FROM dbo.UserArtistFollow
SELECT * FROM dbo.UserTrackPlay


CREATE DATABASE SpotifyDb;
GO

USE SpotifyDb;
GO

CREATE TABLE [User]
(
    UserId      INT IDENTITY(1,1) PRIMARY KEY,
    Email       NVARCHAR(256) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    BirthDate   DATE NULL
);
GO

CREATE TABLE Artist
(
    ArtistId INT IDENTITY(1,1) PRIMARY KEY,
    Name     NVARCHAR(150) NOT NULL,
    Country  NVARCHAR(100) NULL
);
GO

CREATE TABLE Album
(
    AlbumId     INT IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    ReleaseDate DATE NULL
);
GO

CREATE TABLE Track
(
    TrackId         INT IDENTITY(1,1) PRIMARY KEY,
    AlbumId         INT NOT NULL,
    Title           NVARCHAR(200) NOT NULL,
    DurationSeconds INT NOT NULL,
    IsExplicit      BIT NOT NULL DEFAULT(0),

    CONSTRAINT FK_Track_Album
        FOREIGN KEY (AlbumId)
        REFERENCES Album(AlbumId)
);
GO

-- 2.5 Playlist
CREATE TABLE Playlist
(
    PlaylistId INT IDENTITY(1,1) PRIMARY KEY,
    UserId     INT NOT NULL,
    Name       NVARCHAR(200) NOT NULL,
    IsPublic   BIT NOT NULL DEFAULT(1),
    CreatedAt  DATETIME2 NOT NULL DEFAULT(SYSDATETIME()),

    CONSTRAINT FK_Playlist_User
        FOREIGN KEY (UserId)
        REFERENCES [User](UserId)
);
GO

-- 2.6 PlaylistTrack (M:N Playlist–Track)
CREATE TABLE PlaylistTrack
(
    PlaylistId        INT NOT NULL,
    TrackId           INT NOT NULL,
    AddedAt           DATETIME2 NOT NULL DEFAULT(SYSDATETIME()),
    PositionInPlaylist INT NULL,

    CONSTRAINT PK_PlaylistTrack
        PRIMARY KEY (PlaylistId, TrackId),

    CONSTRAINT FK_PlaylistTrack_Playlist
        FOREIGN KEY (PlaylistId)
        REFERENCES Playlist(PlaylistId),

    CONSTRAINT FK_PlaylistTrack_Track
        FOREIGN KEY (TrackId)
        REFERENCES Track(TrackId)
);
GO

CREATE TABLE ArtistTrack
(
    ArtistId INT NOT NULL,
    TrackId  INT NOT NULL,

    CONSTRAINT PK_ArtistTrack
        PRIMARY KEY (ArtistId, TrackId),

    CONSTRAINT FK_ArtistTrack_Artist
        FOREIGN KEY (ArtistId)
        REFERENCES Artist(ArtistId),

    CONSTRAINT FK_ArtistTrack_Track
        FOREIGN KEY (TrackId)
        REFERENCES Track(TrackId)
);
GO

CREATE TABLE UserArtistFollow
(
    UserId   INT NOT NULL,
    ArtistId INT NOT NULL,

    CONSTRAINT PK_UserArtistFollow
        PRIMARY KEY (UserId, ArtistId),

    CONSTRAINT FK_UserArtistFollow_User
        FOREIGN KEY (UserId)
        REFERENCES [User](UserId),

    CONSTRAINT FK_UserArtistFollow_Artist
        FOREIGN KEY (ArtistId)
        REFERENCES Artist(ArtistId)
);
GO

CREATE TABLE UserTrackPlay
(
    UserId    INT NOT NULL,
    TrackId   INT NOT NULL,
    PlayedAt  DATETIME2 NOT NULL DEFAULT(SYSDATETIME()),
    DeviceType NVARCHAR(50) NULL,

    CONSTRAINT PK_UserTrackPlay
        PRIMARY KEY (UserId, TrackId),

    CONSTRAINT FK_UserTrackPlay_User
        FOREIGN KEY (UserId)
        REFERENCES [User](UserId),

    CONSTRAINT FK_UserTrackPlay_Track
        FOREIGN KEY (TrackId)
        REFERENCES Track(TrackId)
);
GO

CREATE TABLE SubscriptionPlan
(
    SubscriptionPlanId INT IDENTITY(1,1) PRIMARY KEY,
    Name               NVARCHAR(100) NOT NULL,
    MonthlyPrice       DECIMAL(10,2) NOT NULL,
    Currency           NVARCHAR(3) NOT NULL
);
GO

CREATE TABLE Subscription
(
    SubscriptionId    INT IDENTITY(1,1) PRIMARY KEY,
    UserId            INT NOT NULL,
    SubscriptionPlanId INT NOT NULL,
    StartDate         DATE NOT NULL,
    EndDate           DATE NULL,
    Status            NVARCHAR(20) NOT NULL,  -- пример: 'Active', 'Cancelled', 'Expired'

    CONSTRAINT FK_Subscription_User
        FOREIGN KEY (UserId)
        REFERENCES [User](UserId),

    CONSTRAINT FK_Subscription_SubscriptionPlan
        FOREIGN KEY (SubscriptionPlanId)
        REFERENCES SubscriptionPlan(SubscriptionPlanId)
);
GO

CREATE TABLE Payment
(
    PaymentId      INT IDENTITY(1,1) PRIMARY KEY,
    SubscriptionId INT NOT NULL,
    PaymentDate    DATETIME2 NOT NULL,
    Amount         DECIMAL(10,2) NOT NULL,
    Status         NVARCHAR(20) NOT NULL,  -- пример: 'Pending', 'Completed', 'Failed'

    CONSTRAINT FK_Payment_Subscription
        FOREIGN KEY (SubscriptionId)
        REFERENCES Subscription(SubscriptionId)
);
GO

-- Users
INSERT INTO [User] (Email, DisplayName, BirthDate)
VALUES
('alice@example.com', 'Alice', '2000-05-10'),
('bob@example.com',   'Bob',   '1998-11-03');
GO

-- Artists
INSERT INTO Artist (Name, Country)
VALUES
('The Example Band', 'UK'),
('DJ Test',          'US');
GO

-- Albums
INSERT INTO Album (Title, ReleaseDate)
VALUES
('First Demo Album', '2020-01-01'),
('Club Bangers',     '2021-06-15');
GO

-- Tracks
INSERT INTO Track (AlbumId, Title, DurationSeconds, IsExplicit)
VALUES
(1, 'Intro Song',       120, 0),
(1, 'Main Single',      210, 0),
(2, 'Night Track',      240, 1),
(2, 'Morning Vibes',    200, 0);
GO

-- ArtistTrack
INSERT INTO ArtistTrack (ArtistId, TrackId)
VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);
GO

-- UserArtistFollow
INSERT INTO UserArtistFollow (UserId, ArtistId)
VALUES
(1, 1),
(1, 2),
(2, 1);
GO

-- Playlists
INSERT INTO Playlist (UserId, Name, IsPublic)
VALUES
(1, 'Alice Favourites', 1),
(2, 'Bob Gym Mix',      1);
GO

-- PlaylistTrack
INSERT INTO PlaylistTrack (PlaylistId, TrackId, PositionInPlaylist)
VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(2, 3, 1),
(2, 4, 2);
GO

-- UserTrackPlay (последно слушане)
INSERT INTO UserTrackPlay (UserId, TrackId, PlayedAt, DeviceType)
VALUES
(1, 2, SYSDATETIME(), 'Mobile'),
(1, 3, DATEADD(MINUTE, -30, SYSDATETIME()), 'Desktop'),
(2, 3, SYSDATETIME(), 'Mobile');
GO

-- Subscription plans
INSERT INTO SubscriptionPlan (Name, MonthlyPrice, Currency)
VALUES
('Free',     0.00, 'EUR'),
('Premium',  9.99, 'EUR'),
('Family',  14.99, 'EUR');
GO

-- Subscriptions
INSERT INTO Subscription (UserId, SubscriptionPlanId, StartDate, EndDate, Status)
VALUES
(1, 2, '2025-01-01', NULL, 'Active'),
(2, 1, '2025-01-10', NULL, 'Active');  -- Bob е във Free план
GO

-- Payments
INSERT INTO Payment (SubscriptionId, PaymentDate, Amount, Status)
VALUES
(1, '2025-01-01T10:00:00', 9.99, 'Completed');
GO

CREATE FUNCTION fn_GetPlaylistDurationSeconds
(
    @PlaylistId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = ISNULL(SUM(t.DurationSeconds), 0)
    FROM PlaylistTrack pt
    JOIN Track t ON t.TrackId = pt.TrackId
    WHERE pt.PlaylistId = @PlaylistId;

    RETURN @Total;
END;
GO

CREATE PROCEDURE usp_AddTrackToPlaylist
(
    @PlaylistId INT,
    @TrackId    INT,
    @Position   INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Валидации - опростени за курсов проект
    IF NOT EXISTS (SELECT 1 FROM Playlist WHERE PlaylistId = @PlaylistId)
    BEGIN
        RAISERROR('Playlist does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Track WHERE TrackId = @TrackId)
    BEGIN
        RAISERROR('Track does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 
               FROM PlaylistTrack 
               WHERE PlaylistId = @PlaylistId AND TrackId = @TrackId)
    BEGIN
        RETURN;
    END;

    IF @Position IS NULL
    BEGIN
        SELECT @Position = ISNULL(MAX(PositionInPlaylist), 0) + 1
        FROM PlaylistTrack
        WHERE PlaylistId = @PlaylistId;
    END;

    INSERT INTO PlaylistTrack (PlaylistId, TrackId, AddedAt, PositionInPlaylist)
    VALUES (@PlaylistId, @TrackId, SYSDATETIME(), @Position);
END;
GO




CREATE TRIGGER trg_Payment_ActivateSubscription
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE s
    SET s.Status = 'Active'
    FROM Subscription s
    JOIN inserted i ON i.SubscriptionId = s.SubscriptionId
    WHERE i.Status = 'Completed';
END;
GO