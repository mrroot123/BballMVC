USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspCalcTodaysMatchups]    Script Date: 1/25/2021 6:10:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            01/19/2020
-- Description:            See below
/*
Bball Sql.xlsx will document this Procedure

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
-- 09/27/2020	Keith Doran		1.4  Modified UserLeagueParms query for TOP 1 by StartDate
--										1.4  Populated @LgAvgStartDate from UserLeagueParms Table
--										1.11 added @LgAvgStartDate to EXEC uspInsertDailySummary
-- 01/11/2021	Keith Doran		3.2.3 In Boxscores Select added RorNum to GameDate in Order By
-- ==================================================================
-- EXEC uspCalcTodaysMatchups 'Test', 'NBA', '01/02/2021', 1
Declare @UserName	varchar(10), @LeagueName varchar(8), @GameDate Date, @Display bit = 0 

 set @UserName	= 'test'
 set @LeagueName = 'NBA'
 set @GameDate = '1/25/2021'
 set  @Display = 1 


	
              
	BEGIN  -- Entire SP
	IF @Display = 1
		Select '51' as Line#, 6.1 as Ver, @GameDate, @LeagueName

-- select 38 as PassedParms, @UserName as UserName, @LeagueName, @GameDate ; return;
--  @Display bit = 0	-- Set to 1 to display TodaysMatchups
BEGIN	-- #1) Setup
	-- *************************************************************************************
	-- *** #1.1 - Insert TodaysMatchupsResults from Yesterday's (or Last) TodaysMatchups ***
	-- *************************************************************************************
		IF @Display = 1	Select '59' as Line#,  '#1' as Section, dbo.GetTime(11)
		EXEC uspInsertTodaysMatchupsResults @UserName, @GameDate, @LeagueName

	-- 1.1.1) Check Rotation for Games - Return If None
	If (Select count(*) From Rotation Where GameDate = @GameDate AND LeagueName = @LeagueName) = 0
	BEGIN
		Print 'No Rotation for GameDate: ' + CONVERT(varchar, @GameDate,1)
		Return;
	END	

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
	Declare @LgGB int, @LgAvgStartDate Date 
			, @GB1 int, @GB2 int, @GB3 int, @GB int
			, @WeightGB1 float, @WeightGB2 float, @WeightGB3 float
			, @Threshold float
			, @BxScLinePct float, @BxScTmStrPct float, @TmStrAdjPct float
			, @BothHome_Away bit
			, @BoxscoresSpanSeasons bit
			, @AdjOTwithSide float
			, @VolatilityGamesBack int = 10
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
		From UserLeagueParms u Where UserName = @UserName AND LeagueName = @LeagueName
			and u.StartDate <= @GameDate
			order by u.StartDate desc



	--	Select '117' as Line#,  @GameDate as 'GameDate', @LgAvgStartDate as 'LgAvgStartDate', '==>' as 'GamesBack', @GB1, @GB2, @GB3; return;
	-- 1.41) LeagueInfo kdtodo combine w 1.6 12/14/2020
	Select @AdjOTwithSide = DefaultOTamt 
		From LeagueInfo
		Where LeagueName = @LeagueName

	-- 1.5) 12/22/2020 decomission - now populated in 1.4
	-- Load ParmTable Values
	-- Declare @varLgAvgGB int   = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
	-- Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')
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

------------- WRONG - Update EVERY row where SubSeason is NULL ----------------
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
	-- 1.11.1 - Declare League Averages Vars
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
	-- 1.11.2 Insert DailySummary row
	EXEC uspInsertDailySummary @UserName, @GameDate, @LeagueName, @LgAvgStartDate
	-- 1.11.3 Populate Lg Avg vars from DailySummary row
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

	  From DailySummary Where LeagueName = @LeagueName AND GameDate <= @GameDate	-- kdtodo - why is it "LT or Equal" - Should be Today's row ???
	  Order By GameDate Desc
	Set @LgAvgLastMinPts = @LgAvgLastMinPt1 + @LgAvgLastMinPt2 * 2 + @LgAvgLastMinPt3 * 3
	-- 1.11.4 Documentation
	-- BxScLinePct - referenced in 3.2.3 - Calc #3  Insert Into TeamStatsAverages & TmStr uspQueryCalcTeamStrength
	--		 0% = no curve to TL - use actual score || 100% = nullify Score use TL instead - MAKE 75%	Ex: Result: 225, TL:220, Score: 240
	-- BxScTmStrPct - referenced in 3.2.3 - Calc #4 Insert Into TeamStatsAverages 
	--		 The smaller the BxScTmStrPct the less the adjustment
	-- TmStrAdjPct - referenced in 4.35 - Ins TMS - tm / query 1  & TmStr uspQueryCalcTeamStrength
	--		 The TmStrAdjPct the BxScTmStrPct the less the Op tm 1,2,3Pt adjustment
END -- 1) End Setup
-----------------------------------------------------------

BEGIN -- #2 - 2.1-NA  2.2-Generate TeamStrength
		IF @Display = 1	Select '#2', dbo.GetTime(11)	

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
				END
			Else
				BEGIN
					Set @LgAvgTeamScored  = @LgAvgScoreHome	-- Lg Avg a team scores Home
					Set @LgAvgTeamAllowed = @LgAvgScoreAway	-- Lg Avg a team Allows Home
				END

			Select @Volatility = dbo.udfCalcVolatility (@UserName, @GameDate, @LeagueName, @Season, @Team, @VolatilityGamesBack)

		-- Create & Populate Team Strenght VAR Table with AvgTmStrPtsScored / AvgTmStrPtsAllowed for TEAM being processed
			Declare  @TmStr TABLE (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float, ActualGamesBack int)
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

			-- TeamStrengthBxScAdjPctScored  -- < 1 - Hi Scoring < 1  ||| > 1 Lo Scoring
			-- TeamStrengthBxScAdjPctAllowed -- < 1 - Bad Defence < 1 ||| > 1 Lo Good Defence
			--		Ref in 3.2.3 Calc#4 - Insert TeamStatsAverages
			Insert into TeamStrength
			(
				LeagueName,  GameDate,     RotNum,  Team,  Venue					-- 1/5
				, TeamStrength,  TeamStrengthScored,  TeamStrengthAllowed		-- 2/3
				, TeamStrengthBxScAdjPctScored, TeamStrengthBxScAdjPctAllowed	-- 3/2 - Ref in 3.2.3 Calc#4 - Insert TeamStatsAverages
				, TeamStrengthTMsAdjPctScored, TeamStrengthTMsAdjPctAllowed		-- 4/2 - NOT Referenced in any calculations
				, Volatility,	TS																-- 5/2
			)
			Select 
			    @LeagueName, @GameDate, @RotNum, @Team, @Venue		-- 1/5
				 , ts.AvgTmStrPtsScored+ts.AvgTmStrPtsAllowed, ts.AvgTmStrPtsScored,  ts.AvgTmStrPtsAllowed	--> from @TmStr 2/3
				 , @LgAvgTeamScored / ts.AvgTmStrPtsScored, @LgAvgTeamAllowed / ts.AvgTmStrPtsAllowed	-- 3/2
				 , ts.AvgTmStrPtsScored / @LgAvgTeamScored, ts.AvgTmStrPtsAllowed/ @LgAvgTeamAllowed	-- 4/2 - Recipricals of Grp 3 above
				 ,	@Volatility,	GETDATE()																		-- 5/2
				From @TmStr ts
			
	--	Select '292 2.2' as Line#, * from @TmStr;  Print 245;	Return;
		END	-- Rotation Loop
	 	-- Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Select '294 2.2' as Line#; 	return;
END -- 2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength

BEGIN -- #3 - temp if to Bypass TeamStatsAverages
	IF @Display = 1	Select '#3', dbo.GetTime(11)
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
				Declare @OppRotNum int
				If @Venue = @Away
					Set @OppRotNum = @RotNum + 1
				else
					Set @OppRotNum = @RotNum - 1

				--INSERT INTO TeamStatsAverages		-- Each Venue - from BoxScores
				--(
				--	-- 1/6
				--	 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
				--	-- 2/4
				--	,[GB],[ActualGB],			[StartGameDate], [EndGameDate]
				--	-- 3/6
				--	,[AverageMadeUs],	[AverageMadeOp]
				--	, AverageAdjustedScoreRegUs	,AverageAdjustedScoreRegOp	-- 9/17/2017 added 4 cols
				--	, CalcScoredDiffUs	, CalcScoredDiffOp
				--	-- 4/8
				--	,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
				--	,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
					
				--	-- 5/6
				--	,[AverageAtmpUsPt1], [AverageAtmpUsPt2],	[AverageAtmpUsPt3]
				--	,[AverageAtmpOpPt1], [AverageAtmpOpPt2],	[AverageAtmpOpPt3]
				--	-- 6/4
				--	,[PtsScoredPctPt1]  
				--	,[PtsScoredPctPt2]   
				--	,[PtsScoredPctPt3]
				--	, TS
				--)
				-- Final Query into Insert
						-- 1/6
				--Select @UserName as UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team
				--		, Case 
				--		   When @BothHome_Away = 1 THEN 'Both'
				--			Else @Venue
				--		  END as Venue
				--		-- 2/4 
				--		,@GB as GB					,q2.ActualGB				,q2.StartGameDate		,q2.EndGameDate
				--		-- 3/6
				--		,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) as AverageMadeUs
				--		,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) as AverageMadeOp
				--		,q2.AverageAdjustedScoreRegUs	,q2.AverageAdjustedScoreRegOp		-- 9/17/2017 added 4 cols
				--		,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) - q2.AverageAdjustedScoreRegUs as CalcScoredDiffUs
				--		,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) - q2.AverageAdjustedScoreRegOp as CalcScoredDiffOp

				--		-- 4/6
				--		,q2.AverageMadeUsPt1 	,q2.AverageMadeUsPt2 	,q2.AverageMadeUsPt3 
				--		,q2.AverageMadeOpPt1  	,q2.AverageMadeOpPt2  	,q2.AverageMadeOpPt3
						
				--		-- 5/6
				--		,q2.AverageAtmpUsPt1 	,q2.AverageAtmpUsPt2 	,q2.AverageAtmpUsPt3 
				--		,q2.AverageAtmpOpPt1  	,q2.AverageAtmpOpPt2  	,q2.AverageAtmpOpPt3
				--		-- 6/4
				--		,(q2.AverageMadeUsPt1 * @Pt1) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
				--		,(q2.AverageMadeUsPt2 * @Pt2) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
				--		,(q2.AverageMadeUsPt3 * @Pt3) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
				--		, GETDATE()
						  	
				--From (	-- q2
				--Select @UserName as UserName, @LeagueName as LeagueName, @GameDate as GameDate, @RotNum + @ixVenue as RotNum	--, @Team as Team, @Venue as Venue
				--		,@GB as GB , Count(*) as ActualGB			,Min(GameDate) AS StartGameDate, Max(GameDate) AS EndGameDate
				--		,Avg(AdjustedMadeUsPt1)	as AverageMadeUsPt1,  Avg(AdjustedMadeUsPt2) as AverageMadeUsPt2,  Avg(AdjustedMadeUsPt3)	as AverageMadeUsPt3 
				--		,Avg(AdjustedMadeOpPt1)	as AverageMadeOpPt1,  Avg(AdjustedMadeOpPt2) as AverageMadeOpPt2,  Avg(AdjustedMadeOpPt3)	as AverageMadeOpPt3  	

				--		,Avg(AdjustedScoreRegUs) as AverageAdjustedScoreRegUs,	Avg(AdjustedScoreRegOp) as AverageAdjustedScoreRegOp	-- 9/17/2017 added

				--		,Avg(ShotsAttemptedUsRegPt1) as AverageAtmpUsPt1, Avg(ShotsAttemptedUsRegPt2) as AverageAtmpUsPt2, Avg(ShotsAttemptedUsRegPt3) as AverageAtmpUsPt3
				--		,Avg(ShotsAttemptedOpRegPt1) as AverageAtmpOpPt1, Avg(ShotsAttemptedOpRegPt2) as AverageAtmpOpPt2, Avg(ShotsAttemptedOpRegPt3) as AverageAtmpOpPt3
				--	From ( -- q1
				-- Make this into SP
				-- pass vars to SP - @GB, @LgAvgLastMinPts 1,2,3, @BxScLinePct
				--		 @LeagueName, @GameDate, @Team, @Venue OR @BothHome_Away, @Season, @BoxscoresSpanSeasons, @SubSeason, @REG_1

						Select TOP (@GB) @@servername as server,	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
						,bL5.Q4Last1MinUsPts as Q4Last1MinUsPts, @LgAvgLastMinPts as LgAvgLastMinPts, @BxScLinePct as BxScLinePct, ts.TeamStrengthBxScAdjPctAllowed as TSBxScAdjPctAllowed
, (b.ScoreRegUs - IsNull(bL5.Q4Last1MinUsPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedScoreRegUs	-- 9/17/2020
, (b.ScoreRegOp - IsNull(bL5.Q4Last1MinOpPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0) - 1.0)  * @BxScTmStrPct)	AS AdjustedScoreRegOp	-- Add 2 cols

-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)
-- Variables  Us - Team - Allowed
--            Op - Opp  - Scored	
-- Xls Cols   B      F                            F                 F                   F                            D                B                                                                    E                                            B   F  
-- Variables  vv     v                            v                 v                   v                           vvvv              vv                                                                vvvvvvv                                         vv  v 
--	 OT already Out		|	<<<		2) Take out Last Min	                            2 >>> | <<< 3) BxSc Curve2LiVenue = @Venuene Pct - @BxScLinePct                        3 >>> | <<< 4) Opp Tm Strength
--[	Shots Made	    Less  Last Min                                   + Default LastMin ] | [ 1   + (( (TmTL             / ScReg	     ) -  1 ) * @BxScLinePct)	]                                       3 >>> | <<< 4
--	 Seeded row calc		|	>>>		2) Last Min is NULL so non factor                2 >>> | <<< 3) r.TotalLineTeam seeded w b.ScoreRegUs																						 3 >>> | <<< 4) Opp Tm Strength - ts.TeamStrengthBxScAdjPctAllowed  seeded w 1.0
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt3


, b.ShotsAttemptedUsRegPt1, b.ShotsAttemptedUsRegPt2, b.ShotsAttemptedUsRegPt3
, b.ShotsAttemptedOpRegPt1, b.ShotsAttemptedOpRegPt2, b.ShotsAttemptedOpRegPt3
						From BoxScores b
							Left JOIN Rotation r		ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Left JOIN Rotation rOPP ON r.GameDate = b.GameDate AND r.RotNum =  r.RotNum + (r.RotNum % 2) * 2 - 1  		-- Opposite RotNum
							-- kd 05/17/2020 make TeamStrength LEFT JOIN for NF rows on SEEDed BxSx rows
							Left Join TeamStrength ts					ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5Min bL5	ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  (b.Venue = @Venue OR @BothHome_Away = 1)
							AND  (b.Season = @Season OR @BoxscoresSpanSeasons = 1)
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC, RotNum
				--	) 	q1
					-- q1
			--	) 	q2

				Set @ixVenue = @ixVenue + 1
				Set @Team  = @TeamHome
				Set @Venue = @Home
				return
			END	-- 3.2.3) Venue Loop
 	
		END	-- 3.2.2) GB loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- 3.2.1) Generate TeamStatsAverages - Rotation Loop	

end
end
