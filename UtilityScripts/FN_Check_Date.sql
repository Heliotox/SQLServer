CREATE FUNCTION dbo.fnCheckDate
(@InDate nvarchar(50))
RETURNS DATETIME
AS
    BEGIN
        declare @Return DATETIME

        select @return = CASE WHEN ISDATE(@InDate) = 1
                            THEN CASE WHEN CAST(@InDate as DATETIME) BETWEEN '1/1/1901 12:00:00 AM' AND '6/6/2079 12:00:00 AM'
                                    THEN @InDate
                                    ELSE null
                                    END
                            ELSE null
                            END
        return @return
    END
GO