/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (100) [UserName]
      --,[LeagueName]
      --,[GameDate]
      --,[RotNum]
      --,[Team]
      --,[Venue]
      --,[GB]
      --,[ActualGB]
      --,[StartGameDate]
      --,[EndGameDate]
      ,Round([AverageMadeUs],2) as [AverageMadeUs]
      ,Round([AverageAdjustedScoreRegUs],2) as [AverageAdjustedScoreRegUs]
      ,Round([CalcScoredDiffUs],2) as [CalcScoredDiffUs]

      ,Round([AverageMadeOp],2) as [AverageMadeOp]
      ,Round([AverageAdjustedScoreRegOp],2) as [AverageAdjustedScoreRegOp]
      ,Round([CalcScoredDiffOp],2) as [CalcScoredDiffOp]

      ,[AverageMadeUsPt1]
      ,[AverageMadeUsPt2]
      ,[AverageMadeUsPt3]
      ,[AverageMadeOpPt1]
      ,[AverageMadeOpPt2]
      ,[AverageMadeOpPt3]
      ,[AverageAtmpUsPt1]
      ,[AverageAtmpUsPt2]
      ,[AverageAtmpUsPt3]
      ,[AverageAtmpOpPt1]
      ,[AverageAtmpOpPt2]
      ,[AverageAtmpOpPt3]
      ,[PtsScoredPctPt1]
      ,[PtsScoredPctPt2]
      ,[PtsScoredPctPt3]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
  where [AverageAdjustedScoreRegUs] is not null
  order by gamedate desc


  Select top 100 abs([CalcScoredDiffUs]) as UsAbs, CalcScoredDiffUs as Us, *
    FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
  where [AverageAdjustedScoreRegUs] is not null
		order by abs([CalcScoredDiffUs]) desc

  Select top 100 abs([CalcScoredDiffOp]) as UsAbs, CalcScoredDiffOp as Us, *
    FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
  where [AverageAdjustedScoreRegOp] is not null
		order by abs([CalcScoredDiffOp]) desc
