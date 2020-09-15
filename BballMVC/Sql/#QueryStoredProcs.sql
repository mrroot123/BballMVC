use [00TTI_LeagueScores]

Declare @serachArg varchar(50) = '%period%'	--

SELECT OBJECT_NAME(object_id) as 'SP Name', *,  definition
FROM sys.sql_modules
WHERE objectproperty(object_id,'IsProcedure') = 1
  AND OBJECT_NAME(object_id)    like @serachArg	-- definition    like @serachArg

SELECT @serachArg as LikeFilter,  name , modify_date, type_desc, definition
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
WHERE  name like @serachArg		-- type_desc like '%usp%'
 --AND definition    like @serachArg
 Order by modify_date desc