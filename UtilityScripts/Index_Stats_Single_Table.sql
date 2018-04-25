select table_name,index_name,'"'+ltrim(rtrim(index_columns))+'"' index_columns
, group_name,
primary_ind,clustered_ind,unique_ind
,object_id,index_id,type_desc,dpages,reserved,used,rowcnt
,database_id
,user_seeks,
user_scans,user_lookups,user_updates,last_user_seek,last_user_scan,last_user_lookup,
last_user_update,system_seeks,system_scans,system_lookups,system_updates,last_system_seek,
last_system_scan,last_system_lookup,last_system_update from dba_analyze_indexes
where table_name='ngweb_communications'
order by table_name,index_name