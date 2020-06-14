/****** Script for SelectTopNRows command from SSMS  ******/
USE [00TTI_LeagueScores]
GO
Declare @strDate as Varchar(10) =(select Convert(Date, getdate()))
--Declare @BuFile varchar(255) =  'C:\Program Files\Microsoft SQL Server\MSSQL11.BBALL\MSSQL\Backup\00TTI_LeagueScores_' +  @strDate + '.Bak' 
Declare @BuFile varchar(255) =  'D:\BU\00TTI_LeagueScores_' +  @strDate + '.Bak' 

-- Select @BuFile; return;

BACKUP DATABASE [00TTI_LeagueScores]
TO DISK = @BuFile
   WITH FORMAT,
      MEDIANAME = 'Z_SQLServerBackups',
      NAME = '00TTI_LeagueScores';
GO
