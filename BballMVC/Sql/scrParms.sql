/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]
SELECT *  FROM [00TTI_LeagueScores].[dbo].[UserLeagueParms]

SELECT *  FROM [00TTI_LeagueScores].[dbo].[LeagueInfo]

Select * From AnalysisResults
SELECT *  FROM [00TTI_LeagueScores].[dbo].[ParmTable] Where ParmName  like 'var%' 
	order by ParmName