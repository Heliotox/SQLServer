DECLARE @db_name VARCHAR(100) 
SELECT @db_name = 'NGProd' 
 
SELECT  
BS.server_name AS [Server Name] 
,BS.database_name AS [Database Name] 
,BS.recovery_model AS [Recovery Model] 
,BMF.physical_device_name [Location] 
,(CAST(BS.backup_size / 1000000 AS INT)) AS [Size of Backup (MB)] 
,CASE BS.[type] WHEN 'D' THEN 'Full' 
WHEN 'I' THEN 'Differential' 
WHEN 'L' THEN 'Transaction Log' 
END AS [Type of Backup] 
,BS.backup_start_date AS [Backup Date] 
,BS.first_lsn AS [First LSN] 
,BS.last_lsn AS [Last LSN] 
FROM msdb.dbo.backupset BS 
INNER JOIN msdb.dbo.backupmediafamily BMF ON BS.media_set_id = BMF.media_set_id 
WHERE BS.database_name = @db_name 
ORDER BY backup_start_date DESC 
,backup_finish_date 