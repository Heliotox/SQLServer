SELECT 
   DB_NAME() AS [database_name], 
   DB_ID() AS database_id,
   OBJECT_SCHEMA_NAME(i.[object_id]) AS [schema_name], 
   OBJECT_NAME(i.[object_id]) AS [object_name], 
   iu.[object_id],
   i.[name], 
   i.index_id, 
   i.[type_desc],
   i.is_primary_key,
   i.is_unique,
   i.is_unique_constraint,
   iu.user_seeks, 
   iu.user_scans, 
   iu.user_lookups, 
   iu.user_updates,
   iu.user_seeks + iu.user_scans + iu.user_lookups AS total_uses,
   CASE WHEN (iu.user_seeks + iu.user_scans + iu.user_lookups) > 0
        THEN iu.user_updates/( iu.user_seeks + iu.user_scans + iu.user_lookups )
        ELSE iu.user_updates END AS update_to_use_ratio,
	ps.used_page_count * 8 AS 'Size in KB'
FROM sys.dm_db_index_usage_stats iu
JOIN sys.indexes i ON iu.index_id = i.index_id AND iu.[object_id] = i.[object_id]
JOIN sys.dm_db_partition_stats ps ON ps.[index_id] = iu.index_id AND ps.[object_id] = iu.[object_id]
WHERE 
   OBJECTPROPERTY(iu.[object_id], 'IsUserTable') = 1
   AND iu.database_id = DB_ID()
   AND (((iu.user_seeks + iu.user_scans + iu.user_lookups) > 0 
   AND (iu.user_seeks + iu.user_scans + iu.user_lookups) < 51 -- Exclude indexs with total use over 50
    AND iu.user_updates/( iu.user_seeks + iu.user_scans + iu.user_lookups ) > 20) -- Exclue indexes with update to use ratio below 20
    OR (iu.user_seeks + iu.user_scans + iu.user_lookups) = 0 ) -- Include indexes with 0 total use
	AND i.type = 2 AND i.is_primary_key = 0 -- type = 2 is nonclustered index, this excludes clusterd indexes and Primary Key Constraints
    AND i.is_unique = 0 AND i.is_unique_constraint = 0 -- exclude unique and unique constraints
	AND ps.used_page_count > 0-- Exclude empty Indexes
ORDER BY 
   CASE WHEN (iu.user_seeks + iu.user_scans + iu.user_lookups) > 0
        THEN iu.user_updates/( iu.user_seeks + iu.user_scans + iu.user_lookups )
        ELSE iu.user_updates END DESC