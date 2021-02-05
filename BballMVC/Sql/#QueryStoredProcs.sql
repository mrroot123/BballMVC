use [00TTI_LeagueScores]

Declare @serachArg varchar(50) = 

	-- '%uspCalcPtPct%'	--
	 '%##MOVE##%'	--
	 
	, @allObjects bit = 01 -- = 0 = just SPs



SELECT OBJECT_NAME(m.object_id) as 'SP Name'
	, o.modify_date, o.create_date
		-- , *,  m.definition
	FROM sys.sql_modules m
	Join sys.objects o  ON m.object_id = o.object_id

	WHERE (objectproperty(m.object_id,'IsProcedure') = 1 or @allObjects = 1)
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
 select  * from sys.objects so 
	 Where so.schema_id > 1
	  and so.type = 'TT'
	  and so.name like '%updatecoll%'