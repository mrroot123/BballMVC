/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  distinct 'Team', [TeamNameInDatabase]
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where enddate is null and LeagueName = 'NBA'


union 

  SELECT distinct 'Rot',  Team
  FROM 
	Rotation
	-- boxscores
	--[00TTI_LeagueScores].[dbo].AdjustmentsDaily
  where LeagueName = 'NBA'

  order by 2
