/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [TeamStrengthID]
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Venue]
      ,[GB]
      ,[ActualGB]
      ,[TeamStrength]
      ,[TeamStrengthScored]

      ,[TeamStrengthAllowed]
		, '==='
      ,abs(1 - [TeamStrengthBxScAdjPctScored])  as one
		, '==='
      ,[TeamStrengthBxScAdjPctScored]
      ,[TeamStrengthBxScAdjPctAllowed]
      ,[TeamStrengthTMsAdjPctScored]
      ,[TeamStrengthTMsAdjPctAllowed]
		,'==='
      ,[Volatility]
      ,[Pace]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[TeamStrength]
  
  
where   abs(1 - [TeamStrengthBxScAdjPctScored]) >= .1
 or  abs(1 - [TeamStrengthBxScAdjPctAllowed]) >= .1
 Order by GameDate desc, rotnum