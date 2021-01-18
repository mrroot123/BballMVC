use [00TTI_LeagueScores]
Declare @servername varchar(25) = (SELECT @@servername as servername)
--Select @servername; return;

	Declare @LastInstallDate DateTime;
	set @LastInstallDate =  [dbo].[udfQueryParmValue]('LastInstallDate');

	
	SELECT @servername as servername, max(modify_date) as Max_modify_date, @LastInstallDate as LastInstallDate
	FROM sys.objects



	SELECT @servername as servername,
	 name as ObjName, create_date , modify_date, Type, type_desc
	FROM sys.objects
	WHERE modify_date > @LastInstallDate
	ORDER BY modify_date DESC

	SELECT @servername as servername,
	 name as ObjName, create_date , modify_date, Type, type_desc
	FROM sys.objects
	WHERE modify_date > @LastInstallDate
	ORDER BY Type,  name	-- DESC

return
	SELECT	-- Display Object Types
	 distinct type, type_desc
	FROM sys.objects
	ORDER BY type_desc