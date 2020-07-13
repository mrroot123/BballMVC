use [00TTI_LeagueScores]
/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT year(gamedate), Count(*) as Games
--      ,Round(Avg([VolatilityAway]),1) as VolatilityAway
--      ,Round(Avg([VolatilityHome]),1) as VolatilityHome
--      ,Round(Avg(VolatilityGame),1) as VolatilityGame
--  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
--  where [VolatilityAway] is not null
--  group by year(gamedate)
--  order  by year(gamedate)
Select q1.Team
	, (q1.VolAway + q1.VolHome) / 2 as Vol
	, q1.VolAway, q1.VolHome
 From (
  select Distinct tm.TeamNameInDatabase as Team
	,Round((
		Select top 1 
		 Volatility
	  from TeamStrength ts
	  Where Team = tm.TeamNameInDatabase and ts.Venue = 'Away'
	  order by GameDate desc
	), 1) as VolAway
	,Round((
		Select top 1 
		Volatility
	  from TeamStrength ts
	  Where Team = tm.TeamNameInDatabase and ts.Venue = 'Home'
	  order by GameDate desc
	), 1) as VolHome
	from Team tm
	--Join Team
	where LeagueName = 'NBA'
	 and EndDate is null
) q1
	 order by 2

	 return

Select top 1 
	Team, Venue, Volatility, *
  from TeamStrength ts
  Where Team = 'BOS' and ts.Venue = 'Away'
  order by GameDate desc

  SELECT TOP (1)
	*
  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
  Where LeagueName = 'NBA' AND Venue = 'Away' AND GB = 10
	AND Team = 'BOS'
  order by GameDate Desc

Declare @Teams TABLE (Team Varchar(4))
Insert INTO @Teams
Exec uspQueryTeams 'NBA'
Select * From @Teams