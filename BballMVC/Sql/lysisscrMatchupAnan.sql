/****** Script for SelectTopNRows command from SSMS  ******/
Declare @LgAvgTeam float = 110.5
	, @TeamAway varchar(4) = 'POR'
	, @TeamHome varchar(4) = 'WAS'



SELECT[GameDate] ,[Team] ,[Venue] ,[GB] ,[ActualGB] ,[StartGameDate]      ,[EndGameDate]
 --     ,[AverageMadeUs]
  --    ,[AverageMadeOp]
 , Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp],1) as TS
      , Round([AverageAdjustedScoreRegUs],1) as Scored
      , Round([AverageAdjustedScoreRegOp],1) as Allowed
		, Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp] - (2.0*@LgAvgTeam),1) as TS_Rating
  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
   Where Team = @TeamAway and GB = 5 
		And GameDate = 
		( Select Max(GameDate) From TeamStatsAverages Where Team = @TeamAway )
union
SELECT[GameDate] ,[Team] ,[Venue] ,[GB] ,[ActualGB] ,[StartGameDate]      ,[EndGameDate]
 --     ,[AverageMadeUs]
  --    ,[AverageMadeOp]
 , Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp],1) as TS
      , Round([AverageAdjustedScoreRegUs],1) as Scored
      , Round([AverageAdjustedScoreRegOp],1) as Allowed
		, Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp] - (2.0*@LgAvgTeam),1) as TS_Rating
  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
   Where Team = @TeamHome and GB = 5 
		And GameDate = 
		( Select Max(GameDate) From TeamStatsAverages Where Team = @TeamHome )

