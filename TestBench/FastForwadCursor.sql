/*
	Stub code for creating a fast forward cursor
	https://msdn.microsoft.com/en-us/library/ms180169.aspx
*/
 
/* declare and initialize variables */
DECLARE @variable INT
SET @variable = 0;
 
DECLARE cur_DoThings CURSOR FAST_FORWARD READ_ONLY FOR 
	--TODO: select statement for what you want to iterate through
OPEN cur_DoThings
FETCH NEXT FROM cur_DoThings INTO @variable
 
WHILE @@FETCH_STATUS = 0
BEGIN
    --TODO: main part - do something based on record in cursor. Logic goes here.
	FETCH NEXT FROM cur_DoThings INTO @variable
END
 
CLOSE cur_DoThings
DEALLOCATE cur_DoThings