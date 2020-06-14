/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

SELECT TOP (1000) [AdjustmentID]
      ,[LeagueName]
      ,[StartDate]
      ,[EndDate]
      ,[Team]
      ,[AdjustmentType]
      ,[AdjustmentAmount]
      ,[Player]
      ,[Description]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[Adjustments]
  where startDate > '1/1/2020' and isnull(Enddate, convert(date, GetDate())) > dbo.udfyesterday()
   and Team in ('CHA', 'NY')

	Select *   FROM [00TTI_LeagueScores].[dbo].[AdjustmentsDaily]
	where GameDate > dbo.udfYesterday() 
	   and Team in ('CHA', 'NY')
