/*

	Select Latest row from TSA (TeamStatsAverages) Hm & Aw
*/
Declare @LgAvgTeam float = 113.0
	, @GameDate date = Getdate()
	, @TeamAway varchar(4) = 'BR'
	, @TeamHome varchar(4) = 'WAS'
	, @GamesBack int = 5


Select GameDate,	Team	,Venue	,GB	,ActualGB	,StartGameDate	,EndGameDate	,TS	,Scored	,Allowed	, TS_Rating
	From
	(
		SELECT[GameDate] ,[Team] ,[Venue] ,[GB] ,[ActualGB] ,[StartGameDate]      ,[EndGameDate]
		 --     ,[AverageMadeUs]
		  --    ,[AverageMadeOp]
		 , Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp],1) as TS
				, Round([AverageAdjustedScoreRegUs],1) as Scored
				, Round([AverageAdjustedScoreRegOp],1) as Allowed
				, Round([AverageAdjustedScoreRegUs]+[AverageAdjustedScoreRegOp] - (2.0*@LgAvgTeam),1) as TS_Rating
		  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
			Where Team = @TeamAway and GB = @GamesBack 
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
			Where Team = @TeamHome and GB = @GamesBack
				And GameDate = 
				( Select Max(GameDate) From TeamStatsAverages Where Team = @TeamHome )

	) q1 

	Select TOP (@GamesBack)
		[GameDate] ,[Team], b.opp ,[Venue], b.ScoreReg
	From BoxScores b
	Where b.GameDate < @GameDate and b.Team = @TeamHome
	order by b.GameDate desc