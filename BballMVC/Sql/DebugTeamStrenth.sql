/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (50) [TeamStrengthID]
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Venue]
      ,[TeamStrength]
      ,[TeamStrengthScored]
      ,[TeamStrengthAllowed]
      ,[TeamStrengthBxScAdjPctScored]
      ,[TeamStrengthBxScAdjPctAllowed]
      ,[TeamStrengthTMsAdjPctScored]
      ,[TeamStrengthTMsAdjPctAllowed]
      ,[Volatility]
      ,[Pace]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[TeamStrength]
  	 where GameDate < '7/28/2020' -- and team = 'Con'
--	 and LeagueName = 'wnba'
	  order by GameDate desc
