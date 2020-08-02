USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspCalcTodaysMatchups]    Script Date: 6/13/2020 6:12:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            01/19/2020
-- Description:            See below
/*
#1	Set User vars - GB, GBWeights, Curves From UserLeagueParms
#2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength
#3A	Set (LgAvgs,  LastMinDefaults From DailySummary), Season,
#3B	For Each MU in GameDate Rotation
			*** Generate TeamStatsAverages
			Set TeamAway, TeamHome, RotNum from Rotation
			For Each GameBack
				INSERT INTO TeamStatsAverages Away & Home
			Next GB
			
		Next MU


TeamStatsAverages RowCount = #ofMUPs * 2 (Aw/Hm) * 3 (GB)
		
#4	For Each MU in GameDate Rotation
			*** Generate TodaysMatchups
			Set TeamAway, TeamHome, RotNum from Rotation

	Next MU

*/
-- ==================================================================
-- Change History
-- ==================================================================
-- Moved under BballMVC & GitHub
-- ==================================================================
-- EXEC uspCalcTodaysMatchups 'Test', 'NBA', '3/6/2020', 1
Alter PROCEDURE [dbo].[uspCalcTodaysMatchups] ( @UserName	varchar(10), @LeagueName varchar(8), @GameDate Date, @Display bit = 0 )
AS
	SET NOCOUNT ON;
              
	BEGIN  -- Entire SP
	IF @Display = 1
		Select 6.1 as Ver, @GameDate, @LeagueName


	If (Select count(*) From Rotation Where GameDate = @GameDate AND LeagueName = @LeagueName) = 0
	BEGIN
		Print 'No Rotation for GameDate: ' + CONVERT(varchar, @GameDate,1)
		Return;
	END	
	
-- select 38 as PassedParms, @UserName as UserName, @LeagueName, @GameDate ; return;
--  @Display bit = 0	-- Set to 1 to display TodaysMatchups
BEGIN	-- #1) Setup


	-- 1.2) Constants
	Declare @Line# as int;

	Declare @Pt1 as float = 1.00	-- Constants Point Values as float
			, @Pt2 as float = 2.00
			, @Pt3 as float = 3.00
			, @Over  as char(8) = 'Over'
			, @Under as char(8) = 'Under'
			, @Away as char(4) = 'Away'
			, @Home as char(4) = 'Home'
			, @REG_1 as char(5) = '1-Reg'


	-- 1.3) Parms
	Declare
			  @Team varchar(10)
			, @Venue varchar(4)
			, @Season varchar(4) 
			, @SubSeason VarChar(10) 
			, @SubSeasonPeriod int
			, @TeamAway varchar(8) 
			, @TeamHome varchar(8)
			, @RotNum int
			, @ixVenue int
			, @GameTime varchar(5)
			, @AdjRecentLeagueHistory float
	;

	-- 1.4) UserLeagueParms		
	Declare @LgGB int 
			, @GB1 int, @GB2 int, @GB3 int, @GB int
			, @WeightGB1 float, @WeightGB2 float, @WeightGB3 float
			, @Threshold float
			, @BxScLinePct float, @BxScTmStrPct float, @TmStrAdjPct float
			, @BothHome_Away bit, @AdjOTwithSide float

	Select @GB1 = GB1, @GB2 = GB2, @GB3 = GB3
			,@WeightGB1 = WeightGB1, @WeightGB2 = WeightGB2, @WeightGB3 = WeightGB3
			,@Threshold = Threshold
			,@BxScLinePct = BxScLinePct , @BxScTmStrPct = BxScTmStrPct, @TmStrAdjPct = TmStrAdjPct	-- kd 5/3/2020 - document these fields
			,@BothHome_Away = BothHome_Away
		From UserLeagueParms Where UserName = @UserName AND LeagueName = @LeagueName
	--	Select  @GB1, @GB2, @GB3; return;
	-- 1.41) LeagueInfo
	Select @AdjOTwithSide = DefaultOTamt 
		From LeagueInfo
		Where LeagueName = @LeagueName

	-- 1.5)
	-- Load ParmTable Values
	Declare @varLgAvgGB int   = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
	Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')
	-- 1.6) Calc League GamesBack
	Select TOP 1 
		@LgGB = li.NumberOfTeams * @varLgAvgGB
	  From LeagueInfo li 
	  Where li.LeagueName = @LeagueName    AND li.StartDate <= @GameDate
	  Order by li.StartDate Desc
	--  select @LgGB

	-- 1.7) @GBTable TABLE - Create & Populate
	DECLARE @GBTable TABLE (GB INT)
	Insert into @GBTable values(@GB1)
	Insert into @GBTable values(@GB2)
	Insert into @GBTable values(@GB3)

	If NOT exists(Select * From @GBTable Where GB = @varTeamAvgGB)
		Insert into @GBTable values(@varTeamAvgGB)		-- 10 GB CONSTANT for Opp Avgs
	--Select  * from @GBTable Order By GB; Select  * from @GBTable Order By GB; return 

	-- 1.8) Update SubSeasonPeriod in Yesterday's BoxScores
	Update BoxScores
		Set SubSeasonPeriod = dbo.udfCalcSubSeasonPeriod(GameDate, LeagueName)
		Where SubSeasonPeriod is Null
	Update Rotation
		Set SubSeasonPeriod = dbo.udfCalcSubSeasonPeriod(GameDate, LeagueName)
		Where SubSeasonPeriod is Null or SubSeasonPeriod = 0

   -- 1.9)  Get Todays Adjustments from Adjustments Table --
	DECLARE @TeamAdjSums TABLE (Team varChar(4), TeamAdjSum float)
	Insert into @TeamAdjSums  
	EXEC [dbo].[uspQueryAdjustmentsByTeamTotal] @GameDate, @LeagueName

	Declare @AdjLeague float = (IsNull( (Select TeamAdjSum From @TeamAdjSums Where Team = ''), 0))
	if @Display = 1	
	BEGIN
		Select @AdjLeague as AdjLeague		
		Select * from  @TeamAdjSums ; -- return
	END

	-- 1.10) Define Volatility constants
	Declare @DefaultVolatilityTeam float = 9.0
			, @DefaultVolatilityGame float = 14.0

	-- Select '155 1.10' as Line#, @LgAvgScoreAway, @LgAvgScoreHomey,  @LgAvgShotsMadeAwayPt1 , @LgAvgShotsMadeAwayPt2 , @LgAvgShotsMadeAwayPt3 	  , @LgAvgShotsMadeHomePt1 , @LgAvgShotsMadeHomePt2 , @LgAvgShotsMadeHomePt3 

	-- 1.11) Get League Averages from DailySummary 
	-- *************************************************
	-- ***   Get League Averages from DailySummary   ***
	-- *************************************************
	Declare @LgAvgShotsMadeAwayPt1 float, @LgAvgShotsMadeAwayPt2 float, @LgAvgShotsMadeAwayPt3 float
			, @LgAvgShotsMadeHomePt1 float, @LgAvgShotsMadeHomePt2 float, @LgAvgShotsMadeHomePt3 float
			, @LgAvgScoreAway float, @LgAvgScoreHome float
			, @LgAvgTeamScored float, @LgAvgTeamAllowed float
		
			, @LgAvgLastMinPt1 float = 0.95
			, @LgAvgLastMinPt2 float = 0.61
			, @LgAvgLastMinPt3 float = 0.21

			, @LgAvgPace float
			, @LgAvgVolatilityTeam float
			, @LgAvgVolatilityGame float
	-- Gen & Insert DailySummary row
	EXEC uspInsertDailySummary @UserName, @GameDate, @LeagueName
	-- Populate Lg Avg vars from DailySummary row
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

	  From DailySummary Where LeagueName = @LeagueName AND GameDate <= @GameDate
	  Order By GameDate Desc

END -- 1) End Setup
-----------------------------------------------------------

BEGIN -- #2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength
	-- **********************************************************************************
	-- *** #2.1 - Insert TodaysMatchupsResults from Yesterday's TodaysMatchups ***
	-- **********************************************************************************
		EXEC uspInsertTodaysMatchupsResults @UserName, @GameDate, @LeagueName


	-- *****************************************************************************************
	-- *** #2.2 - Rotation Loop for each Game of GameDate - Generate TeamStrength             ***
	-- ***	TeamStrength will have Team's Current TS stats as of that Date                  ***
	-- *****************************************************************************************
		Delete From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate

	-- Yesterday's BoxScores were loaded, so calc TeamStrength as of Yesterday

		Declare @Volatility float;
		Set @RotNum = 0;
		While @RotNum < 1000		-- Generate TeamStatsAverages
		BEGIN
		---- Get next Rotation row by RotNum - Away or Home
			Select Top 1  @GameDate = r.GameDate,	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
				From Rotation r
				Where r.LeagueName = @LeagueName AND  r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
				Order by r.RotNum

			If @@ROWCOUNT = 0
				BREAK;

			If @Venue = @Away
				BEGIN
					Set @LgAvgTeamScored  = @LgAvgScoreAway	-- Lg Avg a team scores Away
					Set @LgAvgTeamAllowed = @LgAvgScoreHome	-- Lg Avg a team Allows Away
					Select @Volatility = AVG(Volatility)
					  From (
							Select Top (@varLgAvgGB) VolatilityAway as Volatility
							  From TodaysMatchupsResults
							    Where UserName = @UserName AND LeagueName = @LeagueName AND TeamAway = @Team AND GameDate < @GameDate
					  ) q1
				END
			Else
				BEGIN
					Set @LgAvgTeamScored  = @LgAvgScoreHome	-- Lg Avg a team scores Home
					Set @LgAvgTeamAllowed = @LgAvgScoreAway	-- Lg Avg a team Allows Home
					Select @Volatility = AVG(Volatility)
					  From (
							Select Top (@varLgAvgGB) VolatilityHome as Volatility
							  From TodaysMatchupsResults
							    Where UserName = @UserName AND LeagueName = @LeagueName AND TeamHome = @Team AND GameDate < @GameDate
					  ) q1
				END

		-- Create & Populate Team Strenght VAR Table with AvgTmStrPtsScored / AvgTmStrPtsAllowed for TEAM being processed
			Declare  @TmStr TABLE (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float)
	 		Delete  @TmStr

			-- Populate @TmStr from uspQueryCalcTeamStrength query O/P
			Insert into @TmStr
			EXEC uspQueryCalcTeamStrength
				  @UserName	-- 0
				, @GameDate			-- 1 
				, @LeagueName -- 2 
				, @Team 		-- 3 
				, @Venue 	-- 4 
				, @Season
				, @TmStrAdjPct  		-- 6
				, @BxScLinePct		-- 7	30% of of the ActualScore will be curved back to line ex: Actual: 30 Line: 20 - 30% of 10 = 3. Actual goes from 30 to 27
				, @LgAvgScoreAway 	-- 8  	
				, @LgAvgScoreHome  -- 9
				, @varLgAvgGB 		-- 10 

			Insert into TeamStrength
			(
				LeagueName,  GameDate,     RotNum,  Team,  Venue
				, TeamStrength,  TeamStrengthScored,  TeamStrengthAllowed 
				, TeamStrengthBxScAdjPctScored, TeamStrengthBxScAdjPctAllowed
				, TeamStrengthTMsAdjPctScored, TeamStrengthTMsAdjPctAllowed  
				, Volatility,	TS 
			)
			Select 
			    @LeagueName, @GameDate, @RotNum, @Team, @Venue
				 , AvgTmStrPtsScored+AvgTmStrPtsAllowed, AvgTmStrPtsScored,   AvgTmStrPtsAllowed
				 , @LgAvgTeamScored / AvgTmStrPtsScored, @LgAvgTeamAllowed / AvgTmStrPtsAllowed
				 , AvgTmStrPtsScored / @LgAvgTeamScored, AvgTmStrPtsAllowed/ @LgAvgTeamAllowed
				 ,	@Volatility,	GETDATE()
				From @TmStr 
			
	--	Select '292 2.2' as Line#, * from @TmStr;  Print 245;	Return;
		END	-- Rotation Loop
	 	-- Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Select '294 2.2' as Line#; 	return;
END -- 2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength

BEGIN -- #3 - temp if to Bypass TeamStatsAverages
	Set @GB = 0;
	While 1 = 1		
	-- 3.1) Loop 4 times for 3 GB values & GB10
		-- Loop for each Team in Rotation for
	BEGIN	-- Delete any PREVIOUS TeamStatsAverages rows for LeagueName, GameDate and GB for this GB iteration
		Select Top 1 @GB = g.GB
			From @GBTable g
			Where g.GB > @GB
			Order by g.GB

		If @@ROWCOUNT = 0
			BREAK;
		Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate and GB = @GB
	END -- GB loop
	-- *************************************************************************************************
	-- *** #3.2 - Rotation Loop for each Game of GameDate & Venue - Generate TeamStatsAverages from BoxScores ***
	-- *************************************************************************************************
	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN -- 3.2.1) Loop Rotation 
	-- Get Away RotNum & TeamAway
		Select Top 1 	-- Get Rotation
			@TeamAway = r.Team,  @TeamHome = rh.Team,  @RotNum = r.RotNum
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;

	--		Select @GameDate, @RotNum, @TeamAway, @TeamHome; return;

		Set @GB = 0;
		While 1 = 1		-- Loop 3 times for each GB value & GB10
		BEGIN	-- 3.2.2) Loop 3 times for each GB value & GB10
			Select Top 1 @GB = g.GB
				From @GBTable g
				Where g.GB > @GB
				Order by g.GB
			If @@ROWCOUNT = 0
				BREAK;


			Set @Team  = @TeamAway
			Set @Venue = @Away

			Set @ixVenue = 0
			While @ixVenue < 2	-- loop 2 times 
			BEGIN	-- 3.2.3) Loop Venue

				INSERT INTO TeamStatsAverages		-- Each Venue - from BoxScores
				(
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					,[GB],[ActualGB],			[StartGameDate], [EndGameDate]
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]

					,[AverageAtmpUsPt1], [AverageAtmpUsPt2],	[AverageAtmpUsPt3]
					,[AverageAtmpOpPt1], [AverageAtmpOpPt2],	[AverageAtmpOpPt3]

					,[PtsScoredPctPt1]  
					,[PtsScoredPctPt2]   
					,[PtsScoredPctPt3]
					, TS
				)
				-- q1
				Select @UserName as UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team
						, Case 
						   When @BothHome_Away = 1 THEN 'Both'
							Else @Venue
						  END as Venue
						 
						,@GB as GB					,q2.ActualGB				,q2.StartGameDate		,q2.EndGameDate
						,q2.AverageMadeUsPt1 	,q2.AverageMadeUsPt2 	,q2.AverageMadeUsPt3 
						,q2.AverageMadeOpPt1  	,q2.AverageMadeOpPt2  	,q2.AverageMadeOpPt3

						,q2.AverageAtmpUsPt1 	,q2.AverageAtmpUsPt2 	,q2.AverageAtmpUsPt3 
						,q2.AverageAtmpOpPt1  	,q2.AverageAtmpOpPt2  	,q2.AverageAtmpOpPt3

						,(q2.AverageMadeUsPt1 * @Pt1) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt2 * @Pt2) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt3 * @Pt3) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						, GETDATE()
						  	
				From (	-- q2
				Select @UserName as UserName, @LeagueName as LeagueName, @GameDate as GameDate, @RotNum + @ixVenue as RotNum	--, @Team as Team, @Venue as Venue
						,@GB as GB , Count(*) as ActualGB			,Min(GameDate) AS StartGameDate, Max(GameDate) AS EndGameDate
						,Avg(AverageMadeUsPt1) as AverageMadeUsPt1, Avg(AverageMadeUsPt2) as AverageMadeUsPt2, Avg(AverageMadeUsPt3) as AverageMadeUsPt3 
						,Avg(AverageMadeOpPt1) as AverageMadeOpPt1, Avg(AverageMadeOpPt2) as AverageMadeOpPt2, Avg(AverageMadeOpPt3) as AverageMadeOpPt3  	

						,Avg(ShotsAttemptedUsRegPt1) as AverageAtmpUsPt1,Avg(ShotsAttemptedUsRegPt2) as AverageAtmpUsPt2,Avg(ShotsAttemptedUsRegPt3) as AverageAtmpUsPt3
						,Avg(ShotsAttemptedOpRegPt1) as AverageAtmpOpPt1,Avg(ShotsAttemptedOpRegPt2) as AverageAtmpOpPt2,Avg(ShotsAttemptedOpRegPt3) as AverageAtmpOpPt3
					From ( -- q1

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp

-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - S
-- Variables  Us - Team - Allowed
--            Op - Opp  - Scored	
-- Xls Cols   B      F                            F                 F                   F                            D                B                                                                    E                                            B   F  
-- Variables  vv     v                            v                 v                   v                           vvvv              vv                                                                vvvvvvv                                         vv  v 
--	 OT already Out		|	<<<		2) Take out Last Min	                            2 >>> | <<< 3) BxSc Curve2LiVenue = @Venuene Pct - @BxScLinePct                        3 >>> | <<< 4) Opp Tm Strength
--[	Shots Made	    Less  Last Min                                   + Default LastMin ] | [ 1   + (( (TmTL             / ScReg	     ) -  1 ) * @BxScLinePct)	]
--	 Seeded row calc		|	>>>		2) Last Min is NULL so non factor                2 >>> | <<< 3) r.TotalLineTeam seeded w b.ScoreRegUs                     3 >>> | <<< 4) Opp Tm Strength - ts.TeamStrengthBxScAdjPctAllowed  seeded w 1.0
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt3

, b.ShotsAttemptedUsRegPt1, b.ShotsAttemptedUsRegPt2, b.ShotsAttemptedUsRegPt3
, b.ShotsAttemptedOpRegPt1, b.ShotsAttemptedOpRegPt2, b.ShotsAttemptedOpRegPt3
						From BoxScores b
							Left JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							-- kd 05/17/2020 make TeamStrength LEFT JOIN for NF rows on SEEDed BxSx rows
							Left Join TeamStrength ts					ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5Min bL5	ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  (b.Venue = @Venue OR @BothHome_Away = 1)
							AND  b.Season = @Season
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC
					) 	q1
					-- q1
				) 	q2

				Set @ixVenue = @ixVenue + 1
				Set @Team  = @TeamHome
				Set @Venue = @Home

			END	-- 3.2.3) Venue Loop
 	
		END	-- 3.2.2) GB loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- 3.2.1) Generate TeamStatsAverages - Rotation Loop	

END -- temp bypass


BEGIN -- #4 Populate Todays Matchups from TeamStatsAverages - GB1, GB2, GB3, GB10

	--6 Tm Line Stats - Last3 by HA
	--		 L3	 L5	 L7
	--Away	107.4	103.7	105.5
	--Home  112.0	109.2	109.7

	--Each Tm Line stat
	--3 Pt value Lines - 1, 2, 3
	--3 Stats per Pt Value - 
	--1) Tm Avg Pts
	--2) Opp OpVenue Pts Allowed
	--3) Lg Avg

	--	M5155 - Curve: 2 <== Adjust Boxscores Curve
	--	Home Team: PHI - Last 3  Actual Games Back: 3  Start Date: 12/18/2019
	--	Total  = 1 PTers +  2 PTers +  3 PTers + Tm Str Adj
	--	110.18 =  14.41  +   57.17  +   38.60  +    0.00
	--	Lg Avg Sc = 219.89        (Opp Stat Games Back: 10)   varOppStatAdjFactor
	--	Calc        = Pt * Pts  * ((MILAw/LgAvgAw)+ AdjFac) / (AdjFac+1)
	--	1 Pts 14.41 = 1 * 14.85 * ((16.15 / 17.17)  +  1)   /   (1 + 1)
	--	2 Pts 57.17 = 2 * 29.55 * ((25.82 / 27.62)  +  1)   /   (1 + 1)
	--	3 Pts 38.60 = 3 * 11.96 * ((13.77 / 11.96)  +  1)   /   (1 + 1)
	--Need 3 Stats per line  1			2		  3


	if @Display = 1	-- 4.1) Display Variables
		Select '475 4.1' as Line#	-- Display Stats / Parms
			, @BxScLinePct as BxScLinePct, @BxScTmStrPct  as BxScTmStrPct, @TmStrAdjPct as TmStrAdjPct
			, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3, @WeightGB1 as WtGB1, @WeightGB2 as WtGB2, @WeightGB3 as WtGB3
			, @Threshold as Threshold, @BothHome_Away as BothHome_Away
			, @LgGB as LgGB, @varLgAvgGB as varLgAvgGB, @varTeamAvgGB as varTeamAvgGB
			, Round(@LgAvgScoreAway       , 1)  as LgAvgScoreAway       
			, Round(@LgAvgScoreHome       , 1)  as LgAvgScoreHome       
			, Round(@LgAvgShotsMadeAwayPt1, 1)  as LgAvgShotsMadeAwayPt1
			, Round(@LgAvgShotsMadeAwayPt2, 1)  as LgAvgShotsMadeAwayPt2
			, Round(@LgAvgShotsMadeAwayPt3, 1)  as LgAvgShotsMadeAwayPt3
			, Round(@LgAvgShotsMadeHomePt1, 1)  as LgAvgShotsMadeHomePt1
			, Round(@LgAvgShotsMadeHomePt2, 1)  as LgAvgShotsMadeHomePt2
			, Round(@LgAvgShotsMadeHomePt3, 1)  as LgAvgShotsMadeHomePt3
			-- Last Min Stats
			, Round(@LgAvgLastMinPt1      , 1)  as LgAvgLastMinPt1      
			, Round(@LgAvgLastMinPt2      , 1)  as LgAvgLastMinPt2      
			, Round(@LgAvgLastMinPt3      , 1)  as LgAvgLastMinPt3

	-- ********************************************************************************
	-- *** #4 -  Rotation Loop for each Game of GameDate - Generate TodaysMatchups ***
	-- ********************************************************************************
	Declare @TotalLine as float, @OpenTotalLine as float, @SideLine float
	-- 4.2) Delete TodaysMatchups
	Delete from TodaysMatchups Where UserName = @UserName AND LeagueName = @LeagueName AND GameDate = @GameDate
	-- 4.3) Insert TodaysMatchups
	Set @RotNum = 0;
	While @RotNum < 1000		-- #4 - Generate TodaysMatchups
	BEGIN
		-- [UserName]  ,[LeagueName]       ,[GameDate]      ,[RotNum]  ,[GB]
	-- 4.31
		Select Top 1 -- Get AWAY Rotation row		kdtodo ??? @sideLine is away - do we need to * by -1????
				@RotNum = r.RotNum, 	@TeamAway = r.Team,  @TeamHome = rh.Team, @TotalLine = r.TotalLine
				, @SideLine = r.SideLine  * -1		-- Away sideLine so reverse sign
				, @GameTime = r.GameTime
			-- '===>',	 r.RotNum, 	 r.Team, rh.Team
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
			
		If @@ROWCOUNT = 0
			BREAK;
	-- 4.32 Set TmStr & Volatility		
		If @TotalLine = 0
			Set @TotalLine = null
		--Select '520 4.32' as Line#, @TotalLine as tl

		Declare @TmStrAway float, @TmStrHome float, @VolatilityAway float, @VolatilityHome float, @VolatilityAdj float
		SELECT @TmStrAway = TeamStrength, @VolatilityAway = Volatility
		  FROM TeamStrength ts
		  WHERE  ts.GameDate = @GameDate AND ts.RotNum = @RotNum

		SELECT @TmStrHome = TeamStrength, @VolatilityHome = Volatility 
		  FROM TeamStrength ts
		  WHERE  ts.GameDate = @GameDate AND ts.RotNum = @RotNum + 1

		Set @VolatilityAdj = dbo.udfAdjustThresholdByVolatility(@VolatilityAway, @VolatilityHome, @LgAvgVolatilityTeam);

	--4.33		
		Declare @AdjDbAway float, @AdjDbHome float, @AdjTV float
		Set @AdjDbAway =  IsNull((Select t.TeamAdjSum From @TeamAdjSums t Where t.Team = @TeamAway), 0) + @AdjLeague
		Set @AdjDbHome =  IsNull((Select t.TeamAdjSum From @TeamAdjSums t Where t.Team = @TeamHome), 0) + @AdjLeague
		Set @AdjTV = 0.0;				-- Per Team - Get from Rotation if exist


		if @Display = 1	
			Select '541 4.33' as Line#
				, @RotNum as RotNum, 	@TeamAway as TeamAway,  @TeamHome as TeamHome, @TotalLine as TotalLine, @SideLine as SideLine, @GameTime as GameTime
				, @AdjDbAway as AdjDbAway, @AdjDbHome as AdjDbHome, @AdjOTwithSide as AdjOTwithSide, @AdjTV as AdjTV  

--			select @GameDate, @RotNum, @AdjDbAway, @AdjDbHome , @AdjOTwithSide , @AdjTV , @AdjRecentLeagueHistory

		if (@AdjDbAway + @AdjDbHome + @AdjOTwithSide + @AdjTV + @AdjRecentLeagueHistory) is null
		Begin
			select @GameDate, @RotNum, @AdjDbAway, @AdjDbHome , @AdjOTwithSide , @AdjTV , @AdjRecentLeagueHistory
			select 5/0
		END
		--	 / *	
	-- 4.35
		-- Group# / Field count for group
		BEGIN TRY
			Insert Into TodaysMatchups (
		--1/6
			  UserName, GameDate, LeagueName, Season, SubSeason, RotNum
		--1.1/2
			  , TeamAway, TeamHome		
		--2/14 tm4
			, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal	--(3)

			, AdjAmt
			, AdjAmtAway, AdjAmtHome
			, AdjDbAway, AdjDbHome
			, AdjOTwithSide, AdjTV												--(8)
			, AdjRecentLeagueHistory
			, OurTotalLineAway, OurTotalLineHome, OurTotalLine											--(3)

		--3/6
			, TotalLine, SideLine
			, PlayDiff,  Play	
			,BxScLinePct, TmStrAdjPct --
		--4/6
			, AwayGB1, AwayGB2, AwayGB3
			, HomeGB1, HomeGB2, HomeGB3
		--5/9
			, AwayGB1Pt1,  AwayGB1Pt2,  AwayGB1Pt3
			, AwayGB2Pt1, AwayGB2Pt2,  AwayGB2Pt3
			, AwayGB3Pt1,  AwayGB3Pt2,  AwayGB3Pt3
		--6/9
			, HomeGB1Pt1,  HomeGB1Pt2,   HomeGB1Pt3
			, HomeGB2Pt1,  HomeGB2Pt2,   HomeGB2Pt3
			, HomeGB3Pt1,  HomeGB3Pt2,   HomeGB3Pt3
		--7/6
			, GB1, GB2, GB3
			, WeightGB1, WeightGB2, WeightGB3
		--8/3
			, TmStrAway, TmStrHome, GameTime
		--9/12
			, AwayAverageAtmpUsPt1, AwayAverageAtmpUsPt2, AwayAverageAtmpUsPt3, HomeAverageAtmpUsPt1, HomeAverageAtmpUsPt2, HomeAverageAtmpUsPt3	
			, AwayProjectedAtmpPt1, AwayProjectedAtmpPt2, AwayProjectedAtmpPt3
			, HomeProjectedAtmpPt1, HomeProjectedAtmpPt2, HomeProjectedAtmpPt3
			, TS	-- 10/1
		--11/6
			, AwayProjectedPt1, AwayProjectedPt2, AwayProjectedPt3
			, HomeProjectedPt1, HomeProjectedPt2, HomeProjectedPt3
		--12/4
			, VolatilityAway
			, VolatilityHome
			, Volatility
			, Threshold
			
		)	-- Insert
		Select -- tm4 - FINAL select
				--1/6
					  @UserName as UserName, @GameDate as GameDate, @LeagueName as LeagueName, @Season as Season, @SubSeason as SubSeason, @RotNum as RotNum
				--1.1/2
					  , tm3.TeamAway, tm3.TeamHome -- 1/8
				--2/14 tm4
					, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal	--2.1(3)

					, AdjAmt
					, AdjAmtAway, AdjAmtHome
					, @AdjDbAway, @AdjDbHome
					, @AdjOTwithSide, @AdjTV												--2.2(8)
					, @AdjRecentLeagueHistory
					, OurTotalLineAway, OurTotalLineHome, OurTotalLine				--2.3(3)
				--3/6
					, @TotalLine as TotalLine, @SideLine as SideLine					
					, PlayDiff, Play																	
					, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct
				--4/6
					, AwayGB1, AwayGB2, AwayGB3
					, HomeGB1, HomeGB2, HomeGB3
				--5/9
					, AwayGB1Pt1, AwayGB1Pt2, AwayGB1Pt3
					, AwayGB2Pt1, AwayGB2Pt2, AwayGB2Pt3
					, AwayGB3Pt1, AwayGB3Pt2, AwayGB3Pt3
				--6/9
					, HomeGB1Pt1, HomeGB1Pt2, HomeGB1Pt3
					, HomeGB2Pt1, HomeGB2Pt2, HomeGB2Pt3
					, HomeGB3Pt1, HomeGB3Pt2, HomeGB3Pt3
				--7/6
					, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3
					, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3
				--8/3
					, @TmStrAway, @TmStrHome, @GameTime
				--9/12
					, AwayAverageAtmpUsPt1, AwayAverageAtmpUsPt2, AwayAverageAtmpUsPt3
					, HomeAverageAtmpUsPt1, HomeAverageAtmpUsPt2, HomeAverageAtmpUsPt3	

					, AwayAverageAtmpUsPt1 * (OurTotalLineAway / AwayTotAtmps) as AwayProjectedAtmpPt1
					, AwayAverageAtmpUsPt2 * (OurTotalLineAway / AwayTotAtmps) as AwayProjectedAtmpPt2
					, AwayAverageAtmpUsPt3 * (OurTotalLineAway / AwayTotAtmps) as AwayProjectedAtmpPt3
					, HomeAverageAtmpUsPt1 * (OurTotalLineHome / HomeTotAtmps) as HomeProjectedAtmpPt1
					, HomeAverageAtmpUsPt2 * (OurTotalLineHome / HomeTotAtmps) as HomeProjectedAtmpPt2
					, HomeAverageAtmpUsPt3 * (OurTotalLineHome / HomeTotAtmps) as HomeProjectedAtmpPt3

					, GETDATE()	-- 10/1
				--11/6 - Calc Projected Points
					, (AwayPtsScoredPctPt1 * OurTotalLineAway) / @Pt1
					, (AwayPtsScoredPctPt2 * OurTotalLineAway) / @Pt2
					, (AwayPtsScoredPctPt3 * OurTotalLineAway) / @Pt3
					, (HomePtsScoredPctPt1 * OurTotalLineHome) / @Pt1
					, (HomePtsScoredPctPt2 * OurTotalLineHome) / @Pt2
					, (HomePtsScoredPctPt3 * OurTotalLineHome) / @Pt3


				--12/4
					, @VolatilityAway
					, @VolatilityHome
					, Volatility
					, @Threshold
					
		 From (	-- tm3
			Select  
				--1/6
					  @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @Season as Season, @SubSeason as SubSeason, @RotNum as RotNum
					  , tm2.TeamAway, tm2.TeamHome -- 1/6
				--2/9
					, UnAdjTotalAway , UnAdjTotalHome
					, UnAdjTotalAway + UnAdjTotalHome as UnAdjTotal	--(3)
					, AdjAmtAway, AdjAmtHome, AdjAmtAway + AdjAmtHome as AdjAmt												--(3)
					, UnAdjTotalAway + AdjAmtAway as OurTotalLineAway
					, UnAdjTotalHome + AdjAmtHome as OurTotalLineHome
					, UnAdjTotalAway + UnAdjTotalHome+ AdjAmtAway + AdjAmtHome as OurTotalLine											--(3)
				--3/6
					, @TotalLine as TotalLine, @SideLine as SideLine					
					, CASE -- PlayDiff
							WHEN @TotalLine IS Null THEN Null
							WHEN @TotalLine < 1	  THEN Null
							ELSE UnAdjTotalAway + UnAdjTotalHome + AdjAmtAway + AdjAmtHome - @TotalLine
						END AS PlayDiff															

					, CASE -- Play
							WHEN @TotalLine IS Null THEN Null
							WHEN @TotalLine = 0.0	  THEN Null
							WHEN ( (UnAdjTotalAway + UnAdjTotalHome+ AdjAmtAway + AdjAmtHome) - @TotalLine ) >= @Threshold THEN @Over
							WHEN ( @TotalLine - (UnAdjTotalAway + UnAdjTotalHome+ AdjAmtAway + AdjAmtHome) ) >= @Threshold THEN @Under
							ELSE ''
						END AS Play																	
					, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct
				--4/6
					, CalcAwayGB1Pt1 + CalcAwayGB1Pt2 + CalcAwayGB1Pt3 as AwayGB1
					, CalcAwayGB2Pt1 + CalcAwayGB2Pt2 + CalcAwayGB2Pt3 as AwayGB2
					, CalcAwayGB3Pt1 + CalcAwayGB3Pt2 + CalcAwayGB3Pt3 as AwayGB3
					, CalcHomeGB1Pt1 + CalcHomeGB1Pt2 + CalcHomeGB1Pt3 as HomeGB1
					, CalcHomeGB2Pt1 + CalcHomeGB2Pt2 + CalcHomeGB2Pt3 as HomeGB2
					, CalcHomeGB3Pt1 + CalcHomeGB3Pt2 + CalcHomeGB3Pt3 as HomeGB3
				--5/9
					, CalcAwayGB1Pt1 as AwayGB1Pt1, CalcAwayGB1Pt2 as AwayGB1Pt2, CalcAwayGB1Pt3 as AwayGB1Pt3
					, CalcAwayGB2Pt1 as AwayGB2Pt1, CalcAwayGB2Pt2 as AwayGB2Pt2, CalcAwayGB2Pt3 as AwayGB2Pt3
					, CalcAwayGB3Pt1 as AwayGB3Pt1, CalcAwayGB3Pt2 as AwayGB3Pt2, CalcAwayGB3Pt3 as AwayGB3Pt3
				--6/9
					, CalcHomeGB1Pt1 as HomeGB1Pt1, CalcHomeGB1Pt2 as HomeGB1Pt2, CalcHomeGB1Pt3 as HomeGB1Pt3
					, CalcHomeGB2Pt1 as HomeGB2Pt1, CalcHomeGB2Pt2 as HomeGB2Pt2, CalcHomeGB2Pt3 as HomeGB2Pt3
					, CalcHomeGB3Pt1 as HomeGB3Pt1, CalcHomeGB3Pt2 as HomeGB3Pt2, CalcHomeGB3Pt3 as HomeGB3Pt3

				--9/8
					, AwayAverageAtmpUsPt1, AwayAverageAtmpUsPt2, AwayAverageAtmpUsPt3
					, HomeAverageAtmpUsPt1, HomeAverageAtmpUsPt2, HomeAverageAtmpUsPt3
					, AwayAverageAtmpUsPt1 * @Pt1 + AwayAverageAtmpUsPt2 * @Pt2 + AwayAverageAtmpUsPt3 * @Pt3 as AwayTotAtmps
					, HomeAverageAtmpUsPt1 * @Pt1 + HomeAverageAtmpUsPt2 * @Pt2 + HomeAverageAtmpUsPt3 * @Pt3 as HomeTotAtmps
				--11/6
					, AwayPtsScoredPctPt1, AwayPtsScoredPctPt2, AwayPtsScoredPctPt3
					, HomePtsScoredPctPt1, HomePtsScoredPctPt2, HomePtsScoredPctPt3
				--12/2
					, (@VolatilityAway + @VolatilityHome) / 2 as Volatility
			  From ( -- as tm2
				Select 'L694 4.35-tm2' as Line#, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tm.TeamAway, tm.TeamHome

					, (
						((tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 ) * @WeightGB1) 
					 + ((tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 ) * @WeightGB2)
					 + ((tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 ) * @WeightGB3)
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalAway -- UnAdjTotalAway

					, (
						((tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 ) * @WeightGB1) 
					 + ((tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 ) * @WeightGB2)
					 + ((tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 ) * @WeightGB3)
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalHome -- UnAdjTotalHome
					, (tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 )  as CalcAwayGB1
					, (tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 )  as CalcAwayGB2
					, (tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 )  as CalcAwayGB3

					, (tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 )  as CalcHomeGB1
					, (tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 )  as CalcHomeGB2
					, (tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 )  as CalcHomeGB3

					, CalcAwayGB1Pt1, CalcAwayGB1Pt2, CalcAwayGB1Pt3
					, CalcAwayGB2Pt1, CalcAwayGB2Pt2, CalcAwayGB2Pt3
					, CalcAwayGB3Pt1, CalcAwayGB3Pt2, CalcAwayGB3Pt3

					, CalcHomeGB1Pt1, CalcHomeGB1Pt2, CalcHomeGB1Pt3
					, CalcHomeGB2Pt1, CalcHomeGB2Pt2, CalcHomeGB2Pt3
					, CalcHomeGB3Pt1, CalcHomeGB3Pt2, CalcHomeGB3Pt3
				-- 9/6
					, AwayAverageAtmpUsPt1, AwayAverageAtmpUsPt2, AwayAverageAtmpUsPt3
					, AwayAverageAtmpOpPt1, AwayAverageAtmpOpPt2, AwayAverageAtmpOpPt3

					, HomeAverageAtmpUsPt1, HomeAverageAtmpUsPt2, HomeAverageAtmpUsPt3
					, HomeAverageAtmpOpPt1, HomeAverageAtmpOpPt2, HomeAverageAtmpOpPt3

					, AwayPtsScoredPctPt1, AwayPtsScoredPctPt2, AwayPtsScoredPctPt3
					, HomePtsScoredPctPt1, HomePtsScoredPctPt2, HomePtsScoredPctPt3

					, (@AdjDbAway + @AdjOTwithSide + @AdjTV + @AdjRecentLeagueHistory) as AdjAmtAway
					, (@AdjDbHome + @AdjOTwithSide + @AdjTV + @AdjRecentLeagueHistory) as AdjAmtHome
				--12/2

				  From ( --  tm
		--* /
 					--    ,[LeagueName]      ,[GameDate]      ,[Season]      ,[SubSeason]      ,[TeamAway]      ,[TeamHome]      ,[RotNum]      ,[Time]
					Select '739 4.35-tm' as Line#, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tAwayGB1.Team as TeamAway, tHomeGB1.Team as TeamHome
																																-- kdtodo use @TmAdjFac
					-- = Pt   * Pts                       * ( 1   + ((  ( OpVenueTm Avg Made / OpVenueLg Avg Made )          -1    ) * 
						, @Pt1 * tAwayGB1.AverageMadeUsPt1 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB1Pt1
						, @Pt2 * tAwayGB1.AverageMadeUsPt2 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB1Pt2
						, @Pt3 * tAwayGB1.AverageMadeUsPt3 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB1Pt3

						, @Pt1 * tAwayGB2.AverageMadeUsPt1 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB2Pt1
						, @Pt2 * tAwayGB2.AverageMadeUsPt2 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB2Pt2
						, @Pt3 * tAwayGB2.AverageMadeUsPt3 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB2Pt3

						, @Pt1 * tAwayGB3.AverageMadeUsPt1 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB3Pt1
						, @Pt2 * tAwayGB3.AverageMadeUsPt2 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB3Pt2
						, @Pt3 * tAwayGB3.AverageMadeUsPt3 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) - 1.0 ) * @TmStrAdjPct) )   as CalcAwayGB3Pt3

						, @Pt1 * tHomeGB1.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB1Pt1
						, @Pt2 * tHomeGB1.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB1Pt2
						, @Pt3 * tHomeGB1.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB1Pt3

						, @Pt1 * tHomeGB2.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB2Pt1
						, @Pt2 * tHomeGB2.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB2Pt2
						, @Pt3 * tHomeGB2.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB2Pt3

						, @Pt1 * tHomeGB3.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB3Pt1
						, @Pt2 * tHomeGB3.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB3Pt2
						, @Pt3 * tHomeGB3.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TmStrAdjPct) )   as CalcHomeGB3Pt3

						, tAwayGB10.AverageAtmpUsPt1 as AwayAverageAtmpUsPt1, tAwayGB10.AverageAtmpUsPt2 as AwayAverageAtmpUsPt2, tAwayGB10.AverageAtmpUsPt3 as AwayAverageAtmpUsPt3
						, tAwayGB10.AverageAtmpOpPt1 as AwayAverageAtmpOpPt1, tAwayGB10.AverageAtmpOpPt2 as AwayAverageAtmpOpPt2, tAwayGB10.AverageAtmpOpPt3 as AwayAverageAtmpOpPt3

						, tHomeGB10.AverageAtmpUsPt1 as HomeAverageAtmpUsPt1, tHomeGB10.AverageAtmpUsPt2 as HomeAverageAtmpUsPt2, tHomeGB10.AverageAtmpUsPt3 as HomeAverageAtmpUsPt3
						, tHomeGB10.AverageAtmpOpPt1 as HomeAverageAtmpOpPt1, tHomeGB10.AverageAtmpOpPt2 as HomeAverageAtmpOpPt2, tHomeGB10.AverageAtmpOpPt3 as HomeAverageAtmpOpPt3
						
						, tAwayGB10.PtsScoredPctPt1 as AwayPtsScoredPctPt1, tAwayGB10.PtsScoredPctPt2 as AwayPtsScoredPctPt2, tAwayGB10.PtsScoredPctPt3 as AwayPtsScoredPctPt3
						, tHomeGB10.PtsScoredPctPt1 as HomePtsScoredPctPt1, tHomeGB10.PtsScoredPctPt2 as HomePtsScoredPctPt2, tHomeGB10.PtsScoredPctPt3 as HomePtsScoredPctPt3
						--	, @LgAvgShotsMadeHomePt1 as LgAvgShotsMadeHomePt1
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

				) tm

			) tm2

		) tm3
		END TRY
		BEGIN CATCH
			PRINT convert (Varchar, @GameDate) + ': ' + convert (Varchar, @RotNum)
			 PRINT 'Insert TodaysMatchupsError ' + CONVERT(VARCHAR, ERROR_NUMBER(), 1) + ': '+ ERROR_MESSAGE()
		END CATCH
		Set @RotNum = @RotNum + 1	-- ex: RotNum = 702, bump to 702, Get next Rotation row > 702 which is 703
	--	
	--return
	END	--  #4 - Generate TodaysMatchups
END	--  #4 -  TodaysMatchups


if @Display = 1
	Select '802 END' as Line#, * from TodaysMatchups Where UserName = @UserName  AND  LeagueName = @LeagueName  AND  GameDate = @GameDate


-- select *   FROM [Rotation]   where gamedate >= '1/17/2020'
	return

END	-- St Proc end
