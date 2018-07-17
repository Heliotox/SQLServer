/**************************************************************************************
	Set databases offline and then back online
	Start with setting all the user databases offline
	Then bring them back online
***************************************************************************************/
 
USE master;
GO
 
/*
	Take all user databases offline
*/
 
 
SELECT name, database_id, user_access, user_access_desc, [state], state_desc
FROM sys.databases;
 
DECLARE @name nvarchar(128), @database_id int, @user_access tinyint, @user_access_desc nvarchar(60), @state tinyint, @state_desc nvarchar(60), @sql NVARCHAR(MAX);
DECLARE curDBs CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT name, database_id, user_access, user_access_desc, [state], state_desc 
	FROM sys.databases
	WHERE database_id > 4
OPEN curDBs
FETCH NEXT FROM curDBs INTO @name, @database_id, @user_access, @user_access_desc, @state, @state_desc
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @name + ': ' + CAST(@database_id AS VARCHAR);
	
	PRINT 'Taking database offline';
	SELECT @sql = 'ALTER DATABASE ' + @name + ' SET OFFLINE';
	PRINT @sql;
	EXEC sys.sp_executesql @sql;
    FETCH NEXT FROM curDBs INTO @name, @database_id, @user_access, @user_access_desc, @state, @state_desc
END
CLOSE curDBs
DEALLOCATE curDBs
 
 
/*
	Bring user databases back online
*/
 
 
--Set DBs online and multi user
SELECT name, database_id, user_access, user_access_desc, [state], state_desc
FROM sys.databases;
 
DECLARE @name nvarchar(128), @database_id int, @user_access tinyint, @user_access_desc nvarchar(60), @state tinyint, @state_desc nvarchar(60), @sql NVARCHAR(MAX);
DECLARE curDBs CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT name, database_id, user_access, user_access_desc, [state], state_desc 
	FROM sys.databases
	WHERE database_id > 4
OPEN curDBs
FETCH NEXT FROM curDBs INTO @name, @database_id, @user_access, @user_access_desc, @state, @state_desc
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @name + ': ' + CAST(@database_id AS VARCHAR);
	
	PRINT 'Setting multi user mode';
	SELECT @sql = 'ALTER DATABASE ' + @name + ' SET MULTI_USER';
	PRINT @sql;
	EXEC sys.sp_executesql @sql;
	
	PRINT 'Setting online';
	SELECT @sql = 'ALTER DATABASE ' + @name + ' SET ONLINE';
	PRINT @sql;
	EXEC sys.sp_executesql @sql;
    FETCH NEXT FROM curDBs INTO @name, @database_id, @user_access, @user_access_desc, @state, @state_desc
END
CLOSE curDBs
DEALLOCATE curDBs