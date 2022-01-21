/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [AnalysisResultsID] as ID
      ,[RunID]
      ,[TS]
		 ,[Description] as 'Desc'
      ,[RunDurationMinutes] as Mins
      ,[LeagueName] as Lg
      ,[StartDate]
      ,[EndDate]
      ,[Games]
      ,[Plays]
      ,[Wins]
      ,[Losses]
      ,Round([WLPct],1) as 'WL%'
      ,[Unders]
      ,[Overs]
      ,[UnderWins] As 'Un W'
      ,[UnderLosses]  As 'Un L'
		,Round([UnderPct],1) as 'Un%'
      ,[OverWins] as 'Ov W'
      ,[OverLosses] as 'Ov L'
		,Round([OverPct],1) as 'Ov%'
		,Round([AvgScoreReg],1) as 'Av Sc Reg'
		,Round([AvgScoreRegwOT],1) as 'Av Sc OT'

		,Round([AvgTotalLine],1) as 'Av TL'
		,Round([AvgOurTotalLine],1) as 'Our Av TL'
		,Round([AvgLineDiffResultReg],1) as 'Result LineDif'

      ,[DefaultOTamt] as OtAmt
      ,Convert(varchar(2), [GB1]) + '  ' + Convert(char(2), [GB2]) + '  ' + Convert(char(2), [GB3]) as GB123
      ,Convert(varchar(2), [WeightGB1]) + '  ' + Convert(char(2), [WeightGB2]) + '  ' + Convert(char(2), [WeightGB3]) as WeightGB123

     ,Convert(varchar, [TMUPsWeightTeamStatGB1]) + '  ' + Convert(varchar, [TMUPsWeightTeamStatGB2]) + '  ' + Convert(varchar, [TMUPsWeightTeamStatGB3]) as 'TMUPsWghtTmStatGB123'

     ,Convert(varchar, [TMUPsWeightLgAvgGB1]) + '  ' + Convert(varchar, [TMUPsWeightLgAvgGB2]) + '  ' + Convert(varchar, [TMUPsWeightLgAvgGB3]) as 'TMUPsWghtLgAvGB123'
     ,Convert(varchar, [TodaysMUPsOppAdjPctPt1]) + '  ' + Convert(varchar, [TodaysMUPsOppAdjPctPt2]) + '  ' + Convert(varchar, [TodaysMUPsOppAdjPctPt3]) as 'TodaysMUPsOppAdjPctPt123'

      ,[Threshold]
      ,[BxScLinePct]
      ,[BxScTmStrPct]
      ,[TmStrAdjPct]
      ,[BothHome_Away]

  FROM [00TTI_LeagueScores].[dbo].[AnalysisResults]
	Order by TS Desc