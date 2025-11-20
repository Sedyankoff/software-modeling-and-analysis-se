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