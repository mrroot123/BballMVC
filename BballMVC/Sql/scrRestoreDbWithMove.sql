Declare @IPbak varchar(100) = 
	N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\Backup\00TTI_LeagueScores_FERRARI616_BBALLPROD__2021-01-26.Bak' 


RESTORE DATABASE [00TTI_LeagueScores] FILE = N'00TTI_LeagueScores' 
	FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\Backup\00TTI_LeagueScores_FERRARI616_BBALLPROD__2021-01-26.Bak' 
	WITH  FILE = 1, 
	 MOVE N'00TTI_LeagueScores' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\DATA\00TTI_LeagueScores_data.mdf',  
	 NOUNLOAD,  REPLACE,  STATS = 10
GO

-- 	      N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\Backup\00TTI_LeagueScores_FERRARI616_BBALLPROD__2021-01-26.Bak' 


--	 MOVE N'00TTI_LeagueScores' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\DATA\00TTI_LeagueScores_Log.ldf',  
