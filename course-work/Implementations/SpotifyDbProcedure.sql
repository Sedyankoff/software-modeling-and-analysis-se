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

    -- Ако вече съществува, не добавяме пак
    IF EXISTS (SELECT 1 
               FROM PlaylistTrack 
               WHERE PlaylistId = @PlaylistId AND TrackId = @TrackId)
    BEGIN
        RETURN;
    END;

    -- Ако не е подадена позиция, слагаме след последната
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