USE [00TTI_LeagueScores]
GO

Declare @LeagueName varchar(4) = 'NBA', @GameDate Date =   '11/27/2021'
	, @GB1 int = 3, @GB2 int = 5, @GB3 int = 7 
	, @WeightGB1 int = 1, @WeightGB2 int = 1, @WeightGB3 int = 1
	, @Threshold int = 5, @BxScLinePct float = .5, @BxScTmStrPct float = .2, @TmStrAdjPct float = 2
	, @TMUPsWeightTeamStatGB1 int = 1, @TMUPsWeightTeamStatGB2 int = 1, @TMUPsWeightTeamStatGB3 int = 1
	, @TMUPsWeightLgAvgGB1 int = 1, @TMUPsWeightLgAvgGB2 int = 1, @TMUPsWeightLgAvgGB3 int = 1
	, @TodaysMUPsOppAdjPctPt1 float = .6, @TodaysMUPsOppAdjPctPt2 float = .4, @TodaysMUPsOppAdjPctPt3 float = .2
	, @RecentLgHistoryAdjPct float = 0, @TeamPaceAdjPct float = 1, @TeamAdjPct float = 0, @BothHome_Away bit = 1


Delete from [UserLeagueParms]
	 Where TempRow = 1 and LeagueName = @LeagueName

SET IDENTITY_INSERT [dbo].[UserLeagueParms] ON 

INSERT [dbo].[UserLeagueParms] ([UserLeagueParmsID], [UserName], [LeagueName], [StartDate], [TempRow], [LgAvgStartDate], [LgAvgGamesBack], [TeamAvgGamesBack], [TeamPaceGamesBack], [TeamStrengthGamesBack], [VolatilityGamesBack], [TeamSeedGames], [LoadRotationDaysAhead], [GB1], [GB2], [GB3], [WeightGB1], [WeightGB2], [WeightGB3], [Threshold], [BxScLinePct], [BxScTmStrPct], [TmStrAdjPct], [TMUPsWeightTeamStatGB1], [TMUPsWeightTeamStatGB2], [TMUPsWeightTeamStatGB3], [TMUPsWeightLgAvgGB1], [TMUPsWeightLgAvgGB2], [TMUPsWeightLgAvgGB3], [TodaysMUPsOppAdjPctPt1], [TodaysMUPsOppAdjPctPt2], [TodaysMUPsOppAdjPctPt3], [RecentLgHistoryAdjPct], [TeamPaceAdjPct], [TeamAdjPct], [BothHome_Away], [BoxscoresSpanSeasons]) 
VALUES (4006, N'Test      ', N'NBA       ', CAST(N'2021-10-21' AS Date)							,     1,			 CAST(N'2020-01-01' AS Date), 15, 15, 5, 10, 10, 20, 1, 3, 5, 7, 1, 1, 2, 5, 0.5, 0.2, 0.19, 1, 2, 3, 0, 0, 0, 0.61, 0.42, 0.23, 0, 1, 0, 1, 0)

SET IDENTITY_INSERT [dbo].[UserLeagueParms] OFF


	IF		  @GameDate >= convert(Date,GetDate())	 SELECT @GB1 = 7, @GB2 = 12
	Else IF @GameDate >= '11/01/2021'	 SELECT @GB1 = 5, @GB2 = 7
	Else IF @GameDate >= '10/01/2021'	 SELECT @GB1 = 3, @GB2 = 4


Update [UserLeagueParms]
	Set StartDate = @GameDate, GB1 =  @GB1, GB2 = @GB2
	 Where TempRow = 1 and LeagueName = @LeagueName

	 
Select GB1, GB2,  * from [UserLeagueParms]
	 Where TempRow = 1 and LeagueName = @LeagueName