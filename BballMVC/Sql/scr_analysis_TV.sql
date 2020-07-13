/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [RotationID]
      ,r.[LeagueName]
      ,r.[Season]
      ,r.[SubSeason]
      ,r.[SubSeasonPeriod]
      ,r.[GameDate]
      ,r.[RotNum]
      ,r.[Venue]
      ,r.[Team]
      ,r.[Opp]
      ,r.[TV]
		, a.AdjustmentAmount
  FROM [00TTI_LeagueScores].[dbo].[Rotation] r
   join Adjustments a ON a.StartDate = r.GameDate  and a.Team = r.Team and a.AdjustmentType = 'V'
  where TV is not null and TV <> '' and a.AdjustmentAmount <> 0
  order by GameDate, RotNum