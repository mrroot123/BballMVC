/****** Script for SelectTopNRows command from SSMS  ******/
USE [00TTI_LeagueScores]
GO

-- Folders
-- C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\ [ Data | Backup ]
--

Declare @strDate as Varchar(10) =(select Convert(Date, getdate()))
	,@env varchar(25) = replace(@@Servername,'\','_') + '_'
-- Select  replace(@@Servername,'\','_') + '_' -- select @@Servername	--select @env; return;

--Declare @BuFile varchar(255) =  'C:\Program Files\Microsoft SQL Server\MSSQL11.BBALL\MSSQL\Backup\00TTI_LeagueScores_' +  @strDate + '.Bak' 
Declare @BuFile varchar(255) =  'D:\Backup_00TTI_LeagueScores\00TTI_LeagueScores_' + @env + '_' +  @strDate + '.Bak' 
 -- select @BuFile; return;

-- NOTE: TODO - use Arvixe DB BU & Restore
-- Declare @BuFilePROD varchar(255) =  'E:\HostingSpaces\mrroot\bballmvc.com\Data\00TTI_LeagueScores_' +  @strDate + '.Bak' 

-- set @BuFile = @BuFilePROD;

Declare @Seq int = 1;
While 1=1
BEGIN
	Set @BuFile  =  'D:\Backup_00TTI_LeagueScores\00TTI_LeagueScores_' + @env + '_' +  @strDate +  + '_' +  Trim(Str(@Seq)) + '.Bak' 
	--print @BuFile; -- 
	if dbo.udfFileExists(@BuFile) = 0	-- Does not exist ... good to go
		BREAK;
	Set @Seq = @Seq + 1
END


-- Select @BuFile; --return;
 
BACKUP DATABASE [00TTI_LeagueScores]
TO DISK = @BuFile
   WITH FORMAT,
      MEDIANAME = 'Z_SQLServerBackups',
      NAME = '00TTI_LeagueScores';
GO
