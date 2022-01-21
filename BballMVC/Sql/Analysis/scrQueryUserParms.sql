/****** Script for SelectTopNRows command from SSMS  ******/
Use [00TTI_LeagueScores]
SELECT TOP (1000) [UserLeagueParmsID] as ID
     -- ,[UserName]
      ,[LeagueName] as LG
      ,[StartDate]
		, dbo.udfGetSeason(u.StartDate, u.LeagueName) as Season
		   ,[BothHome_Away] as Both_HA
      ,[BoxscoresSpanSeasons] as Span
      ,[TempRow]
     ,Convert(varchar, [GB1]) + '  ' + Convert(varchar, [GB2]) + '  ' + Convert(varchar, [GB3]) as GB123
     ,Convert(varchar, [LgAvgGamesBack]) + '  ' + Convert(varchar, [TeamAvgGamesBack])  as 'LG/TM AvgGB'
      ,Convert(varchar(2), [GB1]) + '  ' + Convert(char(2), [GB2]) + '  ' + Convert(char(2), [GB3]) as GB123
      ,Convert(varchar(2), [WeightGB1]) + '  ' + Convert(char(2), [WeightGB2]) + '  ' + Convert(char(2), [WeightGB3]) as WeightGB123

     ,Convert(varchar, [TeamStrengthGamesBack]) + '  ' + Convert(varchar, [TeamPaceGamesBack]) + '  ' + Convert(varchar, [VolatilityGamesBack]) as 'TS/Pace/Vol GB'

      ,[Threshold]
      ,[BxScLinePct]
      ,[BxScTmStrPct]
      ,[TmStrAdjPct]
     ,Convert(varchar, [TMUPsWeightTeamStatGB1]) + '  ' + Convert(varchar, [TMUPsWeightTeamStatGB2]) + '  ' + Convert(varchar, [TMUPsWeightTeamStatGB3]) as 'TMUPsWghtTmStatGB123'

     ,Convert(varchar, [TMUPsWeightLgAvgGB1]) + '  ' + Convert(varchar, [TMUPsWeightLgAvgGB2]) + '  ' + Convert(varchar, [TMUPsWeightLgAvgGB3]) as 'TMUPsWghtLgAvGB123'
     ,Convert(varchar, [TodaysMUPsOppAdjPctPt1]) + '  ' + Convert(varchar, [TodaysMUPsOppAdjPctPt2]) + '  ' + Convert(varchar, [TodaysMUPsOppAdjPctPt3]) as 'TodaysMUPsOppAdjPctPt123'

      ,[RecentLgHistoryAdjPct]
      ,[TeamPaceAdjPct]
      ,[TeamAdjPct]
		 ,[LgAvgStartDate]
		       ,[TeamSeedGames]
      ,[LoadRotationDaysAhead]
  FROM [00TTI_LeagueScores].[dbo].[UserLeagueParms] u
   where LeagueName = 'NBA' and u.StartDate  between '10-1-2019' and '10-1-2020'
	order by StartDate
	return
	Select * From SeasonInfo s where Season = '1920'
