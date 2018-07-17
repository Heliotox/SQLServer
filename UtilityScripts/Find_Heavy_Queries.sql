--Busy CPU users 
SELECT TOP(50) DB_NAME(t.[dbid]) AS [Database Name], t.[text] AS [Query Text],
qs.total_worker_time AS [Total Worker Time], qs.min_worker_time AS [Min Worker Time],
qs.total_worker_time/qs.execution_count AS [Avg Worker Time],
qs.max_worker_time AS [Max Worker Time], qs.execution_count AS [Execution Count],
qs.total_elapsed_time/qs.execution_count AS [Avg Elapsed Time],
qs.total_logical_reads/qs.execution_count AS [Avg Logical Reads],
qs.total_physical_reads/qs.execution_count AS [Avg Physical Reads], qs.creation_time AS [Creation Time]
, qp.query_plan AS [Query Plan] -- comment out this column if copying results to Excel
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);



--Busy resource users
SELECT TOP 25
st.text,
qp.query_plan,
(qs.total_logical_reads/qs.execution_count) as avg_logical_reads,
(qs.total_logical_writes/qs.execution_count) as avg_logical_writes,
(qs.total_physical_reads/qs.execution_count) as avg_phys_reads,
qs.*
FROM sys.dm_exec_query_stats as qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) as qp
--WHERE st.text like 'CREATE PROCEDURE sp_MSadd_replcmds%'
ORDER BY qs.total_worker_time DESC