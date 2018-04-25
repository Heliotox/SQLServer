--Script for finding tables that have either no indexes, or no clustered index

SELECT DB_Name(), tables.NAME, 
       (SELECT rows 
        FROM   sys.partitions 
        WHERE  object_id = tables.object_id 
               AND index_id = 0 -- 0 is for heap 
       )AS numberofrows 
FROM   sys.tables tables 
WHERE  Objectproperty(tables.object_id, N'TableHasIndex') = 0			--No Index at all
--WHERE  Objectproperty(tables.object_id, N'TableHasClustIndex') = 0	--No clustered Index


