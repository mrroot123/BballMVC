/*
	File:	DB Name
	From:	Backup file Location
	Move: Data / Log
	To:	Destination ...\Data
*/

RESTORE DATABASE [00TTI_LeagueScores] 
		FILE = N'00TTI_LeagueScores' 
		FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\Backup\00TTI_LeagueScores_2020-09-04.Bak' 
		WITH  FILE = 1, 
			 MOVE N'00TTI_LeagueScores'         TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\00TTI_LeagueScores_0.mdf', 
			 MOVE N'00TTI_LeagueScores_log'     TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\00TTI_LeagueScores_0.ldf', 
		 NOUNLOAD,  STATS = 10
GO
