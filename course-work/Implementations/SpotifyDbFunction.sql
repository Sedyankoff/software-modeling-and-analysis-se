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