









RESTORE DATABASE [00TTI_LeagueScores] FILE = N'00TTI_LeagueScores' 
	FROM  DISK = 
	    N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\Backup\00TTI_LeagueScores_FERRARI616_BBALL__2021-01-04.Bak' 
	WITH  FILE = 1, 
	 MOVE N'00TTI_LeagueScores' 
	   TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\DATA\00TTI_LeagueScores_data.mdf',  
	 MOVE N'00TTI_LeagueScores' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALLPROD\MSSQL\DATA\00TTI_LeagueScores_Log.ldf',  
	 NOUNLOAD,  REPLACE,  STATS = 10
GO
