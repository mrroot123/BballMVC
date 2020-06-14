/*
	=== SS Versions ===
	           Ver   NN	NN0 - ex: 150 is NN + zero
	SQL Server 2019 (15.x)
	SQL Server 2017 (14.x)
	SQL Server 2016 (13.x)
	SQL Server 2014 (12.x)
	SQL Server 2012 (11.x)

	Path: C:\Program Files\Microsoft SQL Server\MSSQL{NN}.{InstanceName}\MSSQL\ [ Backup | Binn | DATA | Install | JOBS | Log | Template Data | repldata ]

	=== Table Of Contents ===
	1) Identity Copy
	2) GetDate ONLY
	3) While Loop example
*/

-- 1)
/*
	SET IDENTITY_INSERT [TABLE] off	-- Must be OFF to insert & Must specify Colnames 
	 Insert Into TABLE (Must specify ColNames)
	 Select ColNames From InputTable
 */

-- 2)
SELECT CONVERT(date, getdate())

-- 3)
/* 	While Loop -- 	Replace ~ with TableName

	DECLARE @~Table TABLE (~ varchar(10))	-- Add more Cols if necessary
	Set @~ = '';
	While 1 = 1		-- Loop for each ~ value
	BEGIN
		Select Top 1 @~ = ~
			From @~Table 
			Where ~ > @~
			Order by ~
		If @@ROWCOUNT = 0
			BREAK;
		-- CODE HERE --
	END	-- ~ Loop
*/	


Select 'Commented'
--/ *~1

	-- Uncomment - Note: + = *
	--  Replace "/+~1" with "--/ *~1"
	--    AND	"~1+/" with "--~1* /"
	Select 'Un-Commented'
	-- Comment - Note: + = *
	--  Replace "--/ *~1" with  "/+~1"
	--    AND	"--~1* /" with  "~1+/"

	--~1* /

