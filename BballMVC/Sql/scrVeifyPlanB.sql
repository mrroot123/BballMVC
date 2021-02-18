use [00TTI_LeagueScores]

BEGIN -- Init
	Declare  @UserName	varchar(10), @LeagueName varchar(8), @GameDate Date

		,  @Display bit = 1

	Set @UserName = 'Test'
	Set @LeagueName = 'NBA'
	Set @GameDate = '2/16/2021'		-- Convert(Date, GetDate())

		-- 1.3) Parms
		Declare
				  @Team varchar(10)
				, @Venue varchar(4)
				, @Season varchar(4) 
				, @SubSeason VarChar(10) 
				, @SubSeasonPeriod int
				, @TeamAway varchar(8) 
				, @TeamHome varchar(8)
				, @RotNum int = 533
				, @ixVenue int
				, @GameTime varchar(5)
				, @AdjRecentLeagueHistory float
		Declare @LgAvgShotsMadeAwayPt1 float, @LgAvgShotsMadeAwayPt2 float, @LgAvgShotsMadeAwayPt3 float
				, @LgAvgShotsMadeHomePt1 float, @LgAvgShotsMadeHomePt2 float, @LgAvgShotsMadeHomePt3 float
				, @LgAvgScoreAway float, @LgAvgScoreHome float
				, @LgAvgTeamScored float, @LgAvgTeamAllowed float
		
				, @LgAvgLastMinPts float 
				, @LgAvgLastMinPt1 float = 0.95
				, @LgAvgLastMinPt2 float = 0.61
				, @LgAvgLastMinPt3 float = 0.21

				, @LgAvgPace float
				, @LgAvgVolatilityTeam float
				, @LgAvgVolatilityGame float

		Select Top 1
				 @LgAvgScoreAway         =	LgAvgScoreAway       
				,@LgAvgScoreHome         =	LgAvgScoreHome       
				,@LgAvgShotsMadeAwayPt1  =	LgAvgShotsMadeAwayPt1
				,@LgAvgShotsMadeAwayPt2  =	LgAvgShotsMadeAwayPt2
				,@LgAvgShotsMadeAwayPt3  =	LgAvgShotsMadeAwayPt3
				,@LgAvgShotsMadeHomePt1  =	LgAvgShotsMadeHomePt1
				,@LgAvgShotsMadeHomePt2  =	LgAvgShotsMadeHomePt2
				,@LgAvgShotsMadeHomePt3  =	LgAvgShotsMadeHomePt3

				,@LgAvgLastMinPt1        =	LgAvgLastMinPt1      
				,@LgAvgLastMinPt2        =	LgAvgLastMinPt2      
				,@LgAvgLastMinPt3        =	LgAvgLastMinPt3  

				,@Season						=	Season  
				,@SubSeason					=	SubSeason  
				,@SubSeasonPeriod			=	SubSeasonPeriod  

				, @LgAvgPace				= LgAvgPace
				, @LgAvgVolatilityTeam	= LgAvgVolatilityTeam 
				, @LgAvgVolatilityGame	= LgAvgVolatilityGame 

				,@AdjRecentLeagueHistory = isNull(AdjRecentLeagueHistory, 0.0)

		  From DailySummary Where LeagueName = @LeagueName AND GameDate = @GameDate

		Declare @LgGB int, @LgAvgStartDate Date 
				, @GB1 int, @GB2 int, @GB3 int, @GB int
				, @WeightGB1 float, @WeightGB2 float, @WeightGB3 float
				, @Threshold float
				, @BxScLinePct float, @BxScTmStrPct float, @TmStrAdjPct float
				, @BothHome_Away bit
				, @BoxscoresSpanSeasons bit
				, @AdjOTwithSide float
				, @VolatilityGamesBack int = 10
				, @TeamStrengthGamesBack int -- 02/10/2021
	-- Was from ParmTable
		Declare @varLgAvgGB int
		Declare @varTeamAvgGB int

		Select TOP 1
				 @LgAvgStartDate = LgAvgStartDate
				, @GB1 = GB1, @GB2 = GB2, @GB3 = GB3
				,@WeightGB1 = WeightGB1, @WeightGB2 = WeightGB2, @WeightGB3 = WeightGB3
				,@Threshold = Threshold
				,@BxScLinePct = BxScLinePct , @BxScTmStrPct = BxScTmStrPct, @TmStrAdjPct = TmStrAdjPct	-- kd 5/3/2020 - document these fields
				,@BoxscoresSpanSeasons = BoxscoresSpanSeasons
				,@BothHome_Away = BothHome_Away

				,@varLgAvgGB = LgAvgGamesBack
				,@varTeamAvgGB = TeamAvgGamesBack
				,@VolatilityGamesBack = VolatilityGamesBack	-- 02/10/2021
				,@TeamStrengthGamesBack = TeamStrengthGamesBack
			From UserLeagueParms u Where UserName = @UserName AND LeagueName = @LeagueName
				and u.StartDate <= @GameDate
				order by u.StartDate desc
END -- End Init

-- Set Team Names
Select @TeamAway = r.Team, @TeamHome = r.Opp From Rotation r Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate and r.RotNum = @RotNum

-- Display Vars
Select 'Vars' as 'Display Vars', @LeagueName, @GameDate, @RotNum as RotNum, @TeamAway as TeamAway, @TeamHome as TeamHome, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3
	, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3
	, @varTeamAvgGB as varTeamAvgGBakaGB10, @LgAvgScoreAway as LgAvgScoreAway, @LgAvgScoreHome as LgAvgScoreHome

Select tsa.AverageAdjustedScoreRegOp, tsa.Team as TeamAway
	From TeamStatsAverages tsa
	 Where tsa.LeagueName = @LeagueName and tsa.GameDate = @GameDate and tsa.GB = @varTeamAvgGB and tsa.Team = @TeamAway
Select tsa.AverageAdjustedScoreRegOp, tsa.Team as TeamHome
	From TeamStatsAverages tsa
	 Where tsa.LeagueName = @LeagueName and tsa.GameDate = @GameDate and tsa.GB = @varTeamAvgGB and tsa.Team = @TeamHome

Select 'q2'
	
	, (CalcAwayGB1 * @WeightGB1  +  CalcAwayGB2 * @WeightGB2 + CalcAwayGB3 * @WeightGB3)  / ( @WeightGB1 + @WeightGB2 + @WeightGB3) 
	+ (CalcHomeGB1 * @WeightGB1  +  CalcHomeGB2 * @WeightGB2 + CalcHomeGB3 * @WeightGB3)  / ( @WeightGB1 + @WeightGB2 + @WeightGB3) as CalcPlanB
	
	, (CalcAwayGB1 * @WeightGB1  +  CalcAwayGB2 * @WeightGB2 + CalcAwayGB3 * @WeightGB3)  / ( @WeightGB1 + @WeightGB2 + @WeightGB3) as CalcAway
	, (CalcHomeGB1 * @WeightGB1  +  CalcHomeGB2 * @WeightGB2 + CalcHomeGB3 * @WeightGB3)  / ( @WeightGB1 + @WeightGB2 + @WeightGB3) as CalcHome

	, CalcAwayGB1, CalcAwayGB2, CalcAwayGB3
	, CalcHomeGB1, CalcHomeGB2, CalcHomeGB3
	, AwayAverageAdjustedScoreRegOp, HomeAverageAdjustedScoreRegOp

	From 
	(
	Select 'DATA' as q1Data
		, tAwayGB10.AverageAdjustedScoreRegOp as AwayAverageAdjustedScoreRegOp, tHomeGB10.AverageAdjustedScoreRegOp as HomeAverageAdjustedScoreRegOp
		, tAwayGB1.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB1
		, tAwayGB2.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB2
		, tAwayGB3.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB3

		, tHomeGB1.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB1
		, tHomeGB2.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB2
		, tHomeGB3.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB3
		
						From TeamStatsAverages tAwayGB1	-- ie: Last 5 ... next 2 are Last 10 & L20 depending upon GB settings ... tAwayGB10 Games Back for Lg Avgs
						JOIN TeamStatsAverages tAwayGB2  ON tAwayGB2.UserName  = @UserName AND tAwayGB2.GameDate  = @GameDate AND tAwayGB2.RotNum  = @RotNum    AND tAwayGB2.GB  = @GB2
						JOIN TeamStatsAverages tAwayGB3  ON tAwayGB3.UserName  = @UserName AND tAwayGB3.GameDate  = @GameDate AND tAwayGB3.RotNum  = @RotNum    AND tAwayGB3.GB  = @GB3
						JOIN TeamStatsAverages tAwayGB10 ON tAwayGB10.UserName = @UserName AND tAwayGB10.GameDate = @GameDate AND tAwayGB10.RotNum = @RotNum    AND tAwayGB10.GB = @varTeamAvgGB

						JOIN TeamStatsAverages tHomeGB1  ON tHomeGB1.UserName  = @UserName AND tHomeGB1.GameDate  = @GameDate AND tHomeGB1.RotNum  = @RotNum +1 AND tHomeGB1.GB  = @GB1
						JOIN TeamStatsAverages tHomeGB2  ON tHomeGB2.UserName  = @UserName AND tHomeGB2.GameDate  = @GameDate AND tHomeGB2.RotNum  = @RotNum +1 AND tHomeGB2.GB  = @GB2
						JOIN TeamStatsAverages tHomeGB3  ON tHomeGB3.UserName  = @UserName AND tHomeGB3.GameDate  = @GameDate AND tHomeGB3.RotNum  = @RotNum +1 AND tHomeGB3.GB  = @GB3
						JOIN TeamStatsAverages tHomeGB10 ON tHomeGB10.UserName = @UserName AND tHomeGB10.GameDate = @GameDate AND tHomeGB10.RotNum = @RotNum +1 AND tHomeGB10.GB = @varTeamAvgGB

							Where tAwayGB1.UserName = @UserName 
							  AND tAwayGB1.GameDate = @GameDate   AND tAwayGB1.RotNum = @RotNum	-- GameDate + Rotnum (1 Specific Team in League)
							  AND tAwayGB1.GB = @GB1
	) q1