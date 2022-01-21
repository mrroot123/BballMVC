/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserLeagueParmsID]
      ,[UserName]
      ,[LeagueName]
      ,[StartDate]
		, dbo.udfGetSeason(u.StartDate, u.LeagueName) as Season
		      ,[BothHome_Away]
      ,[BoxscoresSpanSeasons]
      ,[TempRow]
      ,[LgAvgStartDate]
      ,[LgAvgGamesBack]
      ,[TeamAvgGamesBack]
      ,[TeamPaceGamesBack]
      ,[TeamStrengthGamesBack]
      ,[VolatilityGamesBack]
      ,[TeamSeedGames]
      ,[LoadRotationDaysAhead]
      ,Convert(varchar(2), [GB1]) + '  ' + Convert(char(2), [GB2]) + '  ' + Convert(char(2), [GB3]) as GB123
      ,Convert(varchar(2), [WeightGB1]) + '  ' + Convert(char(2), [WeightGB2]) + '  ' + Convert(char(2), [WeightGB3]) as WeightGB123


      ,[Threshold]
      ,[BxScLinePct]
      ,[BxScTmStrPct]
      ,[TmStrAdjPct]
      ,[TMUPsWeightTeamStatGB1]
      ,[TMUPsWeightTeamStatGB2]
      ,[TMUPsWeightTeamStatGB3]
      ,[TMUPsWeightLgAvgGB1]
      ,[TMUPsWeightLgAvgGB2]
      ,[TMUPsWeightLgAvgGB3]
      ,[TodaysMUPsOppAdjPctPt1]
      ,[TodaysMUPsOppAdjPctPt2]
      ,[TodaysMUPsOppAdjPctPt3]
      ,[RecentLgHistoryAdjPct]
      ,[TeamPaceAdjPct]
      ,[TeamAdjPct]

  FROM [00TTI_LeagueScores].[dbo].[UserLeagueParms] u
   where LeagueName = 'NBA' and u.StartDate  between '10-1-2019' and '10-1-2020'
	order by StartDate
	return
	Select * From SeasonInfo s where Season = '1920'
