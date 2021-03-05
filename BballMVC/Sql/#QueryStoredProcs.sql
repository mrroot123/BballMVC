use [00TTI_LeagueScores]

Declare @serachArg varchar(50) = 

	-- 	
	--
	'%udfCalcAdjTeam%'	--
	-- 	'%##MOVE##%'	--
	 
	, @allObjects bit = 01 -- = 0 = just SPs

Select @serachArg as serachArg

SELECT OBJECT_NAME(m.object_id) as 'Object Name'
	, o.modify_date, o.create_date
	, m.object_id 
	, dbo.udfObjectPropertyType (m.object_id ) as ObjType
		-- , *,  m.definition
	FROM sys.sql_modules m
	Join sys.objects o  ON m.object_id = o.object_id

	WHERE (ObjectProperty(m.object_id,'IsProcedure') = 1 or @allObjects = 1)
	 -- 	 AND OBJECT_NAME(m.object_id)    like @serachArg	-- 
	 --
	  and definition    like @serachArg

 -- return

 -- Get OBJECTS beginning with 'x'
SELECT OBJECT_NAME(m.object_id) as 'Object Name'
	, o.modify_date, o.create_date
	, dbo.udfObjectPropertyType (m.object_id ) as ObjType
		-- , *,  m.definition
	FROM sys.sql_modules m
	Join sys.objects o  ON m.object_id = o.object_id

	WHERE Left( OBJECT_NAME(m.object_id)  ,1) = 'x'
	 -- 	 AND OBJECT_NAME(m.object_id)    like @serachArg	-- 
	 --
	 -- and definition    like @serachArg

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