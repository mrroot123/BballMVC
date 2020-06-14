/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

SELECT  a.[AdjustmentID]
      ,a.[LeagueName]
      ,a.[StartDate]
      ,a.[EndDate]
      ,a.[Team]
      ,ac.Description as AdjustmentType
      ,a.[AdjustmentAmount]
      ,a.[Player]
      ,a.[Description]
      ,a.[TS]
  FROM [00TTI_LeagueScores].[dbo].[Adjustments] a
  JOIN AdjustmentsCodes ac ON ac.Type = a.AdjustmentType
 where a.StartDate >= Convert(Date, GetDate()) or a.EndDate = Null
