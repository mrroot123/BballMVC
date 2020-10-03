use [00TTI_LeagueScores]

Declare @serachArg varchar(50) = '%typadj%'	--
	, @all bit = 01



SELECT OBJECT_NAME(object_id) as 'SP Name'
	, *,  definition
FROM sys.sql_modules
WHERE (objectproperty(object_id,'IsProcedure') = 1 or @all = 1)
 -- AND OBJECT_NAME(object_id)    like @serachArg	-- 
  and definition    like @serachArg

   return

SELECT	-- @serachArg as LikeFilter,  
name , modify_date, type_desc, definition
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
--WHERE  name like @serachArg		-- type_desc like '%usp%'
 --AND definition    like @serachArg
 Order by modify_date desc

 select OBJECT_NAME(object_id)  , *    FROM sys.sql_modules

 use [00TTI_LeagueScores]
 select  * from sys.objects  Where schema_id > 1
  and type = 'TT'
  and name like '%updatecoll%'