use [00TTI_LeagueScores]


SELECT @@servername

	SELECT max(modify_date) as Max_modify_date
	FROM sys.objects

	Declare @LastInstallDate DateTime;
	set @LastInstallDate =  [dbo].[udfQueryParmValue]('LastInstallDate');
	Select @LastInstallDate

	SELECT
	 name as ObjName, create_date , modify_date, Type, type_desc
	FROM sys.objects
	WHERE modify_date > @LastInstallDate
	ORDER BY modify_date DESC

	SELECT
	 name as ObjName, create_date , modify_date, Type, type_desc
	FROM sys.objects
	WHERE modify_date > @LastInstallDate
	ORDER BY Type,  name	-- DESC

return
	SELECT	-- Display Object Types
	 distinct type, type_desc
	FROM sys.objects
	ORDER BY type_desc