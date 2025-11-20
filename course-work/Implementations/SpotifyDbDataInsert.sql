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