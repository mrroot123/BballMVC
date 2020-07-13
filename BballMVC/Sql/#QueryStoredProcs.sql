use [00TTI_LeagueScores]

Declare @serachArg varchar(50) = '%uspAdju%'	--

SELECT OBJECT_NAME(object_id), *,  definition
FROM sys.sql_modules
WHERE objectproperty(object_id,'IsProcedure') = 1
  AND definition    like @serachArg

SELECT name , modify_date, type_desc, definition
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
--WHERE type_desc like '%usp%'
 --AND definition    like @serachArg
 Order by modify_date desc