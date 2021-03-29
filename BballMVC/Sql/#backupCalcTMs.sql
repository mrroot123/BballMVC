USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspCalcTodaysMatchups]    Script Date: 3/20/2021 7:07:36 AM ******/
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
-- Date			Developer		Prod Date	Description
-- 09/27/2020	Keith Doran						1.4  Modified UserLeagueParms query for TOP 1 by StartDate
--														1.4  Populated @LgAvgStartDate from UserLeagueParms Table
--														1.11 added @LgAvgStartDate to EXEC uspInsertDailySummary
-- 01/11/2021	Keith Doran						3.2.3 In Boxscores Select added RorNum to GameDate in Order By
-- 01/31/2021	Keith Doran						2.2	Added GB3 & ActualGB to TeamStrength insert
-- 02/01/2021	Keith Doran		02/05/2021	4.35	Added AwayAveragePtsScored, HomeAveragePtsScored - need 2 cols in TodaysMatchups
-- 02/10/2021	Keith Doran		02/11/2021	1.4 & 2.1 - Populated @VolatilityGamesBack & TeamStrengthGamesBack from UserLeagueParms Table
-- 02/15/2021	Keith Doran		02/19/2021	3.2.3	PlanB, 4.35 PlanB
--														4.35 Added TeamRecordAway, TeamRecordHome columns to TM Insert				
--														1.11.3 Changed DailySummary Select Where GameDate EQUALS @GameDate ... was LT Equals (<=)		
-- 02/22/2021	Keith Doran		02/22/2021	2.22 In TS calc, made @Venue = 'Both' if @BothHome_Away = 1
-- 02/25/2021	Keith Doran		03/06/2021	4.33 Get/calc ADJs -  Added udfCalcAdjTeamPace to get Team Pace Away & Home
--														4.33 Get/calc ADJs -  Added udfCalcAdjTeamTeam to get Team Team Away & Home
--														4.33 Started refactoring ADJ source - Make a common avenue to get ADJs
-- 03/13/2021	Keith Doran		##MOVE##		Changed @AdjOTwithSide to @AdjOTwithSidePerTeam - .6 for NBA
--														4.35 / 2c.6 - tm.AdjOTwithSide is now per Matchup - 1.2 for NBA
--														4.35 / 15/19 - 19 Additional Columns - t{venue}GB10.AverageMadeOpPt{PtValue} as [Away|Home]AverageAllowedPt[1,2,3]
--														4.35 / 16/18 - 18 Additional Columns - AverageMadeHomeGB1Pt1 as [Venue]GB[GB]Pt[Pt1,2,3]
-- ==================================================================
/*
 Declare @dt Date = Convert(Date, Getdate())
 EXEC uspCalcTodaysMatchups 'Test', 'NBA', @dt, 1
*/
ALTER PROCEDURE [dbo].[uspCalcTodaysMatchups] ( @UserName	varchar(10), @LeagueName varchar(8), @GameDate Date, @Display bit = 0 )
AS

BEGIN TRY  

	SET NOCOUNT ON;
              
	BEGIN  -- Entire SP
	IF @Display = 1
		Select '60' as Line#, 6.1 as Ver, @GameDate, @LeagueName

-- select 38 as PassedParms, @UserName as UserName, @LeagueName, @GameDate ; return;
--  @Display bit = 0	-- Set to 1 to display TodaysMatchups
BEGIN	-- #1) Setup
	-- *************************************************************************************
	-- *** #1.1 - Insert TodaysMatchupsResults from Yesterday's (or Last) TodaysMatchups ***
	-- *************************************************************************************
	-- 
		IF @Display = 1	Select '1.1' as Loc,  '#1' as Section, dbo.GetTime(11) as SectionTime
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
			, @BxScLinePct float, @BxScTmStrPct float, @TMoppAdjPct float
			, @BothHome_Away bit
			, @BoxscoresSpanSeasons bit
			, @AdjOTwithSidePerTeam float
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
			,@BxScLinePct = BxScLinePct , @BxScTmStrPct = BxScTmStrPct, @TMoppAdjPct = TmStrAdjPct	-- kd 5/3/2020 - document these fields
			,@BoxscoresSpanSeasons = BoxscoresSpanSeasons
			,@BothHome_Away = BothHome_Away

			,@varLgAvgGB = LgAvgGamesBack
			,@varTeamAvgGB = TeamAvgGamesBack
			,@VolatilityGamesBack = VolatilityGamesBack	-- 02/10/2021
			,@TeamStrengthGamesBack = TeamStrengthGamesBack
		From UserLeagueParms u Where UserName = @UserName AND LeagueName = @LeagueName
			and u.StartDate <= @GameDate
			order by u.StartDate desc



	--	Select '117' as Line#,  @GameDate as 'GameDate', @LgAvgStartDate as 'LgAvgStartDate', '==>' as 'GamesBack', @GB1, @GB2, @GB3; return;
	-- 1.41) LeagueInfo kdtodo combine w 1.6 12/14/2020
	Select @AdjOTwithSidePerTeam = DefaultOTamt 
		From LeagueInfo
		Where LeagueName = @LeagueName  
		-- kdtodo get last by GameDate LeagueInfo row


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
	Select 
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

	  From DailySummary Where LeagueName = @LeagueName AND GameDate = @GameDate	-- 02/15/2021

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
		IF @Display = 1	Select '#2' as Section, dbo.GetTime(11)	 as SectionTime

	-- *****************************************************************************************
	-- *** #2.2 - Rotation Loop for each Game of GameDate - Generate TeamStrength             ***
	-- ***	TeamStrength will have Team's Current TS stats as of that Date                  ***
	-- *****************************************************************************************
		Delete From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate

	-- Yesterday's BoxScores were loaded, so calc TeamStrength as of Yesterday

		Declare @Volatility float, @LgAvgTeamScored float, @LgAvgTeamAllowed float

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

			If  @BothHome_Away = 1		-- 02/22/2021
				 Set @Venue = 'Both';
						  
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
					, @TMoppAdjPct  		-- 6
					, @BxScLinePct		-- 7	30% of of the ActualScore will be curved back to line ex: Actual: 30 Line: 20 - 30% of 10 = 3. Actual goes from 30 to 27
					, @LgAvgScoreAway 	-- 8  	
					, @LgAvgScoreHome  -- 9
					, @TeamStrengthGamesBack	-- 10 -- 02/10/2021

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
				, GB, ActualGB	-- 6/2
			)
			Select 
			    @LeagueName, @GameDate, @RotNum, @Team, @Venue		-- 1/5
				 , ts.AvgTmStrPtsScored+ts.AvgTmStrPtsAllowed, ts.AvgTmStrPtsScored,  ts.AvgTmStrPtsAllowed	--> from @TmStr 2/3
				 , @LgAvgTeamScored / ts.AvgTmStrPtsScored, @LgAvgTeamAllowed / ts.AvgTmStrPtsAllowed	-- 3/2
				 , ts.AvgTmStrPtsScored / @LgAvgTeamScored, ts.AvgTmStrPtsAllowed/ @LgAvgTeamAllowed	-- 4/2 - Recipricals of Grp 3 above
				 ,	@Volatility,	GETDATE()																		-- 5/2
				 , @GB3, ts.ActualGamesBack	-- 6/2
				From @TmStr ts
			
	--	Select '292 2.2' as Line#, * from @TmStr;  Print 245;	Return;
		END	-- Rotation Loop
	 	-- Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Select '294 2.2' as Line#; 	return;
END -- 2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength

BEGIN -- #3 - temp if to Bypass TeamStatsAverages
	IF @Display = 1	Select '#3' as Section, dbo.GetTime(11) as SectionTime
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
		Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate and GB = @GB -- TSA
	END -- GB loop
	-- *************************************************************************************************
	-- *** #3.2 - Rotation Loop for each Game of GameDate & Venue - Generate TeamStatsAverages from BoxScores ***
	-- *************************************************************************************************
	Set @RotNum = 0;
	BEGIN TRANSACTION
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
if @Display = 1 Select 'INSERT INTO TeamStatsAverages', GetDate()
				INSERT INTO TeamStatsAverages		-- Each Venue - from BoxScores TSA
				(
					
					-- 1/6
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					-- 2/4
					,[GB],[ActualGB],			[StartGameDate], [EndGameDate]
					-- 3/6
					,[AverageMadeUs],	[AverageMadeOp]
					, AverageAdjustedScoreRegUs	,AverageAdjustedScoreRegOp	-- 9/17/2017 added 2 cols - PlanB
					, CalcScoredDiffUs	, CalcScoredDiffOp
					-- 4/6
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
					
					-- 5/6
					,[AverageAtmpUsPt1], [AverageAtmpUsPt2],	[AverageAtmpUsPt3]
					,[AverageAtmpOpPt1], [AverageAtmpOpPt2],	[AverageAtmpOpPt3]
					-- 6/4
					,[PtsScoredPctPt1]  
					,[PtsScoredPctPt2]   
					,[PtsScoredPctPt3]
					, TS
				)
				-- Final Query into Insert into TeamStatsAverages
						
					Select 
						-- 1/6
						  @UserName as UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team
						, Case 
						   When @BothHome_Away = 1 THEN 'Both'
							Else @Venue
						  END as Venue
						-- 2/4 
						,@GB as GB					,q2.ActualGB				,q2.StartGameDate		,q2.EndGameDate
						-- 3/6
						,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) as AverageMadeUs
						,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) as AverageMadeOp
						,q2.AverageAdjustedScoreRegUs	,q2.AverageAdjustedScoreRegOp		-- 9/17/2017 added 2 cols - PlanB
						,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) - q2.AverageAdjustedScoreRegUs as CalcScoredDiffUs
						,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) - q2.AverageAdjustedScoreRegOp as CalcScoredDiffOp

						-- 4/6
						,q2.AverageMadeUsPt1 	,q2.AverageMadeUsPt2 	,q2.AverageMadeUsPt3 
						,q2.AverageMadeOpPt1  	,q2.AverageMadeOpPt2  	,q2.AverageMadeOpPt3
						
						-- 5/6
						,q2.AverageAtmpUsPt1 	,q2.AverageAtmpUsPt2 	,q2.AverageAtmpUsPt3 
						,q2.AverageAtmpOpPt1  	,q2.AverageAtmpOpPt2  	,q2.AverageAtmpOpPt3
						-- 6/4
						,(q2.AverageMadeUsPt1 * @Pt1) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt2 * @Pt2) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt3 * @Pt3) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						, GETDATE()
						  	
				From (	-- q2
					Select  @UserName as UserName, @LeagueName as LeagueName, @GameDate as GameDate, @RotNum + @ixVenue as RotNum	--, @Team as Team, @Venue as Venue
						,@GB as GB , Count(*) as ActualGB			,Min(GameDate) AS StartGameDate, Max(GameDate) AS EndGameDate
						,Avg(AdjustedMadeUsPt1)	as AverageMadeUsPt1,  Avg(AdjustedMadeUsPt2) as AverageMadeUsPt2,  Avg(AdjustedMadeUsPt3)	as AverageMadeUsPt3 
						,Avg(AdjustedMadeOpPt1)	as AverageMadeOpPt1,  Avg(AdjustedMadeOpPt2) as AverageMadeOpPt2,  Avg(AdjustedMadeOpPt3)	as AverageMadeOpPt3  	

						,Avg(AdjustedScoreRegUs) as AverageAdjustedScoreRegUs,	Avg(AdjustedScoreRegOp) as AverageAdjustedScoreRegOp	-- 9/17/2017 added - PlanB

						,Avg(ShotsAttemptedUsRegPt1) as AverageAtmpUsPt1, Avg(ShotsAttemptedUsRegPt2) as AverageAtmpUsPt2, Avg(ShotsAttemptedUsRegPt3) as AverageAtmpUsPt3
						,Avg(ShotsAttemptedOpRegPt1) as AverageAtmpOpPt1, Avg(ShotsAttemptedOpRegPt2) as AverageAtmpOpPt2, Avg(ShotsAttemptedOpRegPt3) as AverageAtmpOpPt3
					From ( -- q1

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp

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

, (b.ScoreRegUs - IsNull(bL5.Q4Last1MinUsPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedScoreRegUs	-- 9/17/2020 PlanB
, (b.ScoreRegOp - IsNull(bL5.Q4Last1MinOpPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0) - 1.0)  * @BxScTmStrPct)	AS AdjustedScoreRegOp	-- Add 2 cols Planb

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
	COMMIT
END -- temp bypass


BEGIN -- #4 Populate Todays Matchups from TeamStatsAverages - GB1, GB2, GB3, GB10
	IF @Display = 1	Select '#4' as Section, dbo.GetTime(11) as SectionTime
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
			, @BxScLinePct as BxScLinePct, @BxScTmStrPct  as BxScTmStrPct, @TMoppAdjPct as TmStrAdjPct
			, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3, @WeightGB1 as WtGB1, @WeightGB2 as WtGB2, @WeightGB3 as WtGB3
			, @VolatilityGamesBack as VolatilityGamesBack, @TeamStrengthGamesBack as TeamStrengthGamesBack
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
		Declare @Canceled bit;
		-- [UserName]  ,[LeagueName]       ,[GameDate]      ,[RotNum]  ,[GB]
	-- 4.31
		Select Top 1 -- Get AWAY Rotation row		kdtodo ??? @sideLine is away - do we need to * by -1????
				@RotNum = r.RotNum, 	@TeamAway = r.Team,  @TeamHome = rh.Team, @TotalLine = r.TotalLine, @OpenTotalLine = r.OpenTotalLine
				, @SideLine = r.SideLine  * -1		-- Away sideLine so reverse sign
				, @GameTime = r.GameTime
				, @Canceled = r.Canceled
			-- '===>',	 r.RotNum, 	 r.Team, rh.Team
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
			
		If @@ROWCOUNT = 0
			BREAK;
	-- 4.32 Set TmStr & Volatility		
		If @TotalLine = 0
		begin
			Set @TotalLine = null
		end
		
		--Select '520 4.32' as Line#, @TotalLine as tl

		Declare @TmStrAway float, @TmStrHome float, @VolatilityAway float, @VolatilityHome float, @VolatilityAdj float
		SELECT @TmStrAway = TeamStrength, @VolatilityAway = Volatility
		  FROM TeamStrength ts
		  WHERE  ts.GameDate = @GameDate AND ts.RotNum = @RotNum

		SELECT @TmStrHome = TeamStrength, @VolatilityHome = Volatility 
		  FROM TeamStrength ts
		  WHERE  ts.GameDate = @GameDate AND ts.RotNum = @RotNum + 1

		Set @VolatilityAdj = dbo.udfAdjustThresholdByVolatility(@VolatilityAway, @VolatilityHome, @LgAvgVolatilityTeam);

	--4.33 - Set Adjustments		
		Declare @AdjAmtAway float = 0, @AdjAmtHome float = 0

		Declare @AdjDbAway float, @AdjDbHome float, @AdjTV float
		Set @AdjDbAway =  IsNull((Select t.TeamAdjSum From @TeamAdjSums t Where t.Team = @TeamAway), 0) + @AdjLeague
		Set @AdjDbHome =  IsNull((Select t.TeamAdjSum From @TeamAdjSums t Where t.Team = @TeamHome), 0) + @AdjLeague
		Set @AdjAmtAway = @AdjAmtAway + @AdjDbAway
		Set @AdjAmtHome = @AdjAmtHome + @AdjDbHome

		Set @AdjTV = 0.0;				-- Per Team - Get from Rotation if exist
		-- @AdjRecentLeagueHistory is from DailySummary
		Set @AdjOTwithSidePerTeam = dbo.udfCalcAdjOTwithSide(@LeagueName, @SideLine)
		Set @AdjAmtAway = @AdjAmtAway + @AdjOTwithSidePerTeam
		Set @AdjAmtHome = @AdjAmtHome + @AdjOTwithSidePerTeam

		Declare @AdjPaceAway float, @AdjPaceHome float	-- 02/25/2021
		Set @AdjPaceAway = dbo.udfCalcAdjTeamPace(@LeagueName, @GameDate, @TeamAway, @GB3)
		Set @AdjPaceHome = dbo.udfCalcAdjTeamPace(@LeagueName, @GameDate, @TeamHome, @GB3)
		Set @AdjAmtAway = @AdjAmtAway + @AdjPaceAway
		Set @AdjAmtHome = @AdjAmtHome + @AdjPaceHome

		Declare @AdjTeamAway float, @AdjTeamHome float	-- 02/25/2021
		Set @AdjTeamAway = dbo.udfCalcAdjTeam(@UserName, @LeagueName, @GameDate, @TeamAway, @GB3)
		Set @AdjTeamHome = dbo.udfCalcAdjTeam(@UserName, @LeagueName, @GameDate, @TeamHome, @GB3)
		Set @AdjAmtAway = @AdjAmtAway + @AdjTeamAway
		Set @AdjAmtHome = @AdjAmtHome + @AdjTeamHome

		if @Display = 1	
			Select '541 4.33' as Line#
				, @RotNum as RotNum, 	@TeamAway as TeamAway,  @TeamHome as TeamHome, @TotalLine as TotalLine, @SideLine as SideLine, @GameTime as GameTime
				, @AdjDbAway as AdjDbAway, @AdjDbHome as AdjDbHome, @AdjOTwithSidePerTeam as AdjOTwithSide, @AdjTV as AdjTV  

--			select @GameDate, @RotNum, @AdjDbAway, @AdjDbHome , @AdjOTwithSidePerTeam , @AdjTV , @AdjRecentLeagueHistory

		if (@AdjDbAway + @AdjDbHome + @AdjOTwithSidePerTeam + @AdjTV + @AdjRecentLeagueHistory) is null
		Begin
			select @GameDate, @RotNum, @AdjDbAway, @AdjDbHome , @AdjOTwithSidePerTeam , @AdjTV , @AdjRecentLeagueHistory
			select 5/0
		END
		--	 / *	
	-- 4.35
		-- Group# / Field count for group
		BEGIN TRY
			-- 4.35 Insert
			Insert Into TodaysMatchups (
		--1/6
			  UserName, GameDate, LeagueName, Season, SubSeason, RotNum
		--1.1/2
			  , TeamAway, TeamHome		
		--2/26 q4
			, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal	-- 2a / 3

			-- ins.PlanB - 2b / 9
			, UnAdjTotalAwayPlanB, UnAdjTotalHomePlanB, UnAdjTotalPlanB	--(3)
			, CalcAwayGB1PlanB, CalcAwayGB2PlanB, CalcAwayGB3PlanB		--(3)
			, CalcHomeGB1PlanB, CalcHomeGB2PlanB, CalcHomeGB3PlanB		--(3)

			-- Adjs - 2c/ 12
			, AdjAmt
			, AdjAmtAway, AdjAmtHome
			, AdjDbAway, AdjDbHome
			, AdjOTwithSide	-- 03/13/2021 2c.6 now adj for Matchup 1.2 for NBA
			, AdjTV												--(12)
			, AdjRecentLeagueHistory
			, AdjPaceAway, AdjPaceHome	-- 02/25/2021			
			, AdjTeamAway, AdjTeamHome	-- 02/25/2021
			-- Lines 2d / 4
			, OurTotalLineAway, OurTotalLineHome, OurTotalLine, OpenTotalLine					--(4)

		--3/6
			, TotalLine, SideLine
			, PlayDiff,  Play	
			,BxScLinePct, TmStrAdjPct --
		--4/6
			, AwayGB1, AwayGB2, AwayGB3
			, HomeGB1, HomeGB2, HomeGB3
		--5/9
			, AwayGB1Pt1,  AwayGB1Pt2,  AwayGB1Pt3
			, AwayGB2Pt1,  AwayGB2Pt2,  AwayGB2Pt3
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
		--12/5
			, VolatilityAway
			, VolatilityHome
			, Volatility
			, Threshold
			, Canceled
		--13/4 - Offence - Defence - 02/01/2021
			, AwayAveragePtsScored, HomeAveragePtsScored
			, AwayAveragePtsAllowed, HomeAveragePtsAllowed
		--14/2
			, TeamRecordAway, TeamRecordHome
		-- 15/19 - 03/13/2021
			, AwayAverageMadePt1, AwayAverageMadePt2,  AwayAverageMadePt3, HomeAverageMadePt1, HomeAverageMadePt2, HomeAverageMadePt3
			, AwayAverageAllowedPt1, AwayAverageAllowedPt2,  AwayAverageAllowedPt3, HomeAverageAllowedPt1, HomeAverageAllowedPt2, HomeAverageAllowedPt3
			
			, LgAvgShotsMadeAwayPt1,LgAvgShotsMadeAwayPt2, LgAvgShotsMadeAwayPt3, LgAvgShotsMadeHomePt1,LgAvgShotsMadeHomePt2, LgAvgShotsMadeHomePt3
			, TMoppAdjPct
		-- 16/18 - 03/18/2021
			, AverageMadeAwayGB1Pt1, AverageMadeAwayGB1Pt2, AverageMadeAwayGB1Pt3
			, AverageMadeAwayGB2Pt1, AverageMadeAwayGB2Pt2, AverageMadeAwayGB2Pt3
			, AverageMadeAwayGB3Pt1, AverageMadeAwayGB3Pt2, AverageMadeAwayGB3Pt3
			, AverageMadeHomeGB1Pt1, AverageMadeHomeGB1Pt2, AverageMadeHomeGB1Pt3
			, AverageMadeHomeGB2Pt1, AverageMadeHomeGB2Pt2, AverageMadeHomeGB2Pt3
			, AverageMadeHomeGB3Pt1, AverageMadeHomeGB3Pt2, AverageMadeHomeGB3Pt3								
		)	-- Insert Into TodaysMatchups
		Select -- q4 - FINAL select
				--1/6
					  @UserName as UserName, @GameDate as GameDate, @LeagueName as LeagueName, @Season as Season, @SubSeason as SubSeason, @RotNum as RotNum
				--1.1/2
					  , q3.TeamAway, q3.TeamHome -- 1/8
				--2/26 q4
					, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal	--2.1(3)

					-- q4.PlanB
					, UnAdjTotalAwayPlanB, UnAdjTotalHomePlanB, UnAdjTotalPlanB	-- 2.1B(3)
					, CalcAwayGB1PlanB, CalcAwayGB2PlanB, CalcAwayGB3PlanB		--(3)
					, CalcHomeGB1PlanB, CalcHomeGB2PlanB, CalcHomeGB3PlanB		--(3)

					--2c/12
					, AdjAmt
					, AdjAmtAway, AdjAmtHome
					, @AdjDbAway, @AdjDbHome
					, @AdjOTwithSidePerTeam * 2	-- 03/13/2021 2c.6 Multiply by 2 for Matchup OT adj
					, @AdjTV												--2.2(12)
					, @AdjRecentLeagueHistory
					, @AdjPaceAway, @AdjPaceHome	-- 02/25/2021
					, @AdjTeamAway, @AdjTeamHome	-- 02/25/2021

					, OurTotalLineAway, OurTotalLineHome, OurTotalLine, @OpenTotalLine				--2.3(4)
				--3/6
					, @TotalLine as TotalLine, @SideLine as SideLine					
					, PlayDiff, Play																	
					, @BxScLinePct as BxScLinePct, @TMoppAdjPct as TmStrAdjPct
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
					, (AwayPtsScoredPctPt1 * OurTotalLineAway) / @Pt1	-- from tAwayGB10.PtsScoredPctPt1 in first Query
					, (AwayPtsScoredPctPt2 * OurTotalLineAway) / @Pt2
					, (AwayPtsScoredPctPt3 * OurTotalLineAway) / @Pt3
					, (HomePtsScoredPctPt1 * OurTotalLineHome) / @Pt1
					, (HomePtsScoredPctPt2 * OurTotalLineHome) / @Pt2
					, (HomePtsScoredPctPt3 * OurTotalLineHome) / @Pt3


				--12/5
					, @VolatilityAway
					, @VolatilityHome
					, Volatility
					, @Threshold
					, @Canceled
				--13/4 - Offence - Defence - 02/01/2021
					, AwayAveragePtsScored, HomeAveragePtsScored  - 02/01/2021
					, AwayAveragePtsAllowed, HomeAveragePtsAllowed
				--14/2
					, dbo.udfQueryTeamRecord(@GameDate, @LeagueName, q3.TeamAway) as TeamRecordAway
					, dbo.udfQueryTeamRecord(@GameDate, @LeagueName, q3.TeamHome) as TeamRecordHome
				-- 15/19 - 03/13/2021
					, AwayAverageMadePt1, AwayAverageMadePt2,  AwayAverageMadePt3, HomeAverageMadePt1, HomeAverageMadePt2, HomeAverageMadePt3
					, AwayAverageAllowedPt1, AwayAverageAllowedPt2,  AwayAverageAllowedPt3, HomeAverageAllowedPt1, HomeAverageAllowedPt2, HomeAverageAllowedPt3
					, @LgAvgShotsMadeAwayPt1,@LgAvgShotsMadeAwayPt2, @LgAvgShotsMadeAwayPt3, @LgAvgShotsMadeHomePt1,@LgAvgShotsMadeHomePt2, @LgAvgShotsMadeHomePt3
					, @TMoppAdjPct
				-- 16/18 - 03/18/2021
					, AverageMadeAwayGB1Pt1, AverageMadeAwayGB1Pt2, AverageMadeAwayGB1Pt3
					, AverageMadeAwayGB2Pt1, AverageMadeAwayGB2Pt2, AverageMadeAwayGB2Pt3
					, AverageMadeAwayGB3Pt1, AverageMadeAwayGB3Pt2, AverageMadeAwayGB3Pt3
					, AverageMadeHomeGB1Pt1, AverageMadeHomeGB1Pt2, AverageMadeHomeGB1Pt3
					, AverageMadeHomeGB2Pt1, AverageMadeHomeGB2Pt2, AverageMadeHomeGB2Pt3
					, AverageMadeHomeGB3Pt1, AverageMadeHomeGB3Pt2, AverageMadeHomeGB3Pt3
					
		 From (	-- q3
			Select  
				--1/2
					  
					  q2.TeamAway, q2.TeamHome -- 1/8
				--2/12
					, UnAdjTotalAway , UnAdjTotalHome
					, UnAdjTotalAway + UnAdjTotalHome as UnAdjTotal	--(3)
					-- q3.PlanB
					, UnAdjTotalAwayPlanB , UnAdjTotalHomePlanB
					, UnAdjTotalAwayPlanB + UnAdjTotalHomePlanB as UnAdjTotalPlanB	--(3)
					, CalcAwayGB1PlanB, CalcAwayGB2PlanB, CalcAwayGB3PlanB		--(3)
					, CalcHomeGB1PlanB, CalcHomeGB2PlanB, CalcHomeGB3PlanB		--(3)


					, AdjAmtAway, AdjAmtHome
					, AdjAmtAway + AdjAmtHome as AdjAmt												--(3)
					--(2)
					, UnAdjTotalAway + AdjAmtAway as OurTotalLineAway
					, UnAdjTotalHome + AdjAmtHome as OurTotalLineHome

					, UnAdjTotalAway + UnAdjTotalHome+ AdjAmtAway + AdjAmtHome as OurTotalLine											--(3)

				--3/6
					, @TotalLine as TotalLine, @SideLine as SideLine					
					, CASE -- PlayDiff - Diff between OurLine & TotalLine
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
					, @BxScLinePct as BxScLinePct, @TMoppAdjPct as TmStrAdjPct
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
				--13/4 - Offence - Defence
					, AwayAveragePtsScored, HomeAveragePtsScored
					, AwayAveragePtsAllowed, HomeAveragePtsAllowed
				-- 15/12 - 03/13/2021
					, AwayAverageMadePt1, AwayAverageMadePt2,  AwayAverageMadePt3, HomeAverageMadePt1, HomeAverageMadePt2, HomeAverageMadePt3
					, AwayAverageAllowedPt1, AwayAverageAllowedPt2,  AwayAverageAllowedPt3, HomeAverageAllowedPt1, HomeAverageAllowedPt2, HomeAverageAllowedPt3

					, AverageMadeAwayGB1Pt1, AverageMadeAwayGB1Pt2, AverageMadeAwayGB1Pt3
					, AverageMadeAwayGB2Pt1, AverageMadeAwayGB2Pt2, AverageMadeAwayGB2Pt3
					, AverageMadeAwayGB3Pt1, AverageMadeAwayGB3Pt2, AverageMadeAwayGB3Pt3
					, AverageMadeHomeGB1Pt1, AverageMadeHomeGB1Pt2, AverageMadeHomeGB1Pt3
					, AverageMadeHomeGB2Pt1, AverageMadeHomeGB2Pt2, AverageMadeHomeGB2Pt3
					, AverageMadeHomeGB3Pt1, AverageMadeHomeGB3Pt2, AverageMadeHomeGB3Pt3
			  From ( -- as q2
				Select 'L694 4.35-q2' as Line#, q1.TeamAway, q1.TeamHome

					, (
						((q1.CalcAwayGB1Pt1 + q1.CalcAwayGB1Pt2 + q1.CalcAwayGB1Pt3 ) * @WeightGB1) 
					 + ((q1.CalcAwayGB2Pt1 + q1.CalcAwayGB2Pt2 + q1.CalcAwayGB2Pt3 ) * @WeightGB2)
					 + ((q1.CalcAwayGB3Pt1 + q1.CalcAwayGB3Pt2 + q1.CalcAwayGB3Pt3 ) * @WeightGB3)
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalAway -- UnAdjTotalAway

					, (
						((q1.CalcHomeGB1Pt1 + q1.CalcHomeGB1Pt2 + q1.CalcHomeGB1Pt3 ) * @WeightGB1) 
					 + ((q1.CalcHomeGB2Pt1 + q1.CalcHomeGB2Pt2 + q1.CalcHomeGB2Pt3 ) * @WeightGB2)
					 + ((q1.CalcHomeGB3Pt1 + q1.CalcHomeGB3Pt2 + q1.CalcHomeGB3Pt3 ) * @WeightGB3)
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalHome -- UnAdjTotalHome

							-- q2.PlanB - DO Home also
					, (
						( q1.CalcAwayGB1PlanB * @WeightGB1) 
					 + ( q1.CalcAwayGB2PlanB * @WeightGB2) 
					 + ( q1.CalcAwayGB3PlanB * @WeightGB3) 
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalAwayPlanB -- UnAdjTotalAwayPlanB
							
					, (
						( q1.CalcHomeGB1PlanB * @WeightGB1) 
					 + ( q1.CalcHomeGB2PlanB * @WeightGB2) 
					 + ( q1.CalcHomeGB3PlanB * @WeightGB3) 
			 				) / (@WeightGB1 + @WeightGB2 + @WeightGB3)					as UnAdjTotalHomePlanB -- UnAdjTotalHomePlanB
					, CalcAwayGB1PlanB, CalcAwayGB2PlanB, CalcAwayGB3PlanB		--(3)
					, CalcHomeGB1PlanB, CalcHomeGB2PlanB, CalcHomeGB3PlanB		--(3)


					, (q1.CalcAwayGB1Pt1 + q1.CalcAwayGB1Pt2 + q1.CalcAwayGB1Pt3 )  as CalcAwayGB1
					, (q1.CalcAwayGB2Pt1 + q1.CalcAwayGB2Pt2 + q1.CalcAwayGB2Pt3 )  as CalcAwayGB2
					, (q1.CalcAwayGB3Pt1 + q1.CalcAwayGB3Pt2 + q1.CalcAwayGB3Pt3 )  as CalcAwayGB3

					, (q1.CalcHomeGB1Pt1 + q1.CalcHomeGB1Pt2 + q1.CalcHomeGB1Pt3 )  as CalcHomeGB1
					, (q1.CalcHomeGB2Pt1 + q1.CalcHomeGB2Pt2 + q1.CalcHomeGB2Pt3 )  as CalcHomeGB2
					, (q1.CalcHomeGB3Pt1 + q1.CalcHomeGB3Pt2 + q1.CalcHomeGB3Pt3 )  as CalcHomeGB3

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

					, @AdjAmtAway as AdjAmtAway	--02/25/2021
					, @AdjAmtHome as AdjAmtHome
				--13/4 - Offence - Defence
					, AwayAveragePtsScored, HomeAveragePtsScored
					, AwayAveragePtsAllowed, HomeAveragePtsAllowed

				-- 03/13/2021
					, AwayAverageMadePt1, AwayAverageMadePt2,  AwayAverageMadePt3, HomeAverageMadePt1, HomeAverageMadePt2, HomeAverageMadePt3
					, AwayAverageAllowedPt1, AwayAverageAllowedPt2,  AwayAverageAllowedPt3, HomeAverageAllowedPt1, HomeAverageAllowedPt2, HomeAverageAllowedPt3

					, AverageMadeAwayGB1Pt1, AverageMadeAwayGB1Pt2, AverageMadeAwayGB1Pt3
					, AverageMadeAwayGB2Pt1, AverageMadeAwayGB2Pt2, AverageMadeAwayGB2Pt3
					, AverageMadeAwayGB3Pt1, AverageMadeAwayGB3Pt2, AverageMadeAwayGB3Pt3
					, AverageMadeHomeGB1Pt1, AverageMadeHomeGB1Pt2, AverageMadeHomeGB1Pt3
					, AverageMadeHomeGB2Pt1, AverageMadeHomeGB2Pt2, AverageMadeHomeGB2Pt3
					, AverageMadeHomeGB3Pt1, AverageMadeHomeGB3Pt2, AverageMadeHomeGB3Pt3


				  From ( --  tm q1
		--* /
 					--    ,[LeagueName]      ,[GameDate]      ,[Season]      ,[SubSeason]      ,[TeamAway]      ,[TeamHome]      ,[RotNum]      ,[Time]
					Select '844 4.35-tm' as Line#, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tAwayGB1.Team as TeamAway, tHomeGB1.Team as TeamHome
																																-- kdtodo use @TmAdjFac
					-- = Pt   * Pts                       * ( 1   + (( ( OpVenueTm Avg MadeOP(=Allowed) / OpVenueLg Avg Made) -1   ) * @TMoppAdjPct) )
						-- Away
						, dbo.udfCalcTM4GBpts(  @Pt1, tAwayGB1.AverageMadeUsPt1, tHomeGB10.AverageMadeOpPt1, @LgAvgShotsMadeHomePt1, @TMoppAdjPct )  as CalcAwayGB1Pt1
						, dbo.udfCalcTM4GBpts(  @Pt2, tAwayGB1.AverageMadeUsPt2, tHomeGB10.AverageMadeOpPt2, @LgAvgShotsMadeHomePt2, @TMoppAdjPct )  as CalcAwayGB1Pt2
						, dbo.udfCalcTM4GBpts(  @Pt3, tAwayGB1.AverageMadeUsPt3, tHomeGB10.AverageMadeOpPt3, @LgAvgShotsMadeHomePt3, @TMoppAdjPct )  as CalcAwayGB1Pt3

						, dbo.udfCalcTM4GBpts(  @Pt1, tAwayGB2.AverageMadeUsPt1, tHomeGB10.AverageMadeOpPt1, @LgAvgShotsMadeHomePt1, @TMoppAdjPct )  as CalcAwayGB2Pt1
						, dbo.udfCalcTM4GBpts(  @Pt2, tAwayGB2.AverageMadeUsPt2, tHomeGB10.AverageMadeOpPt2, @LgAvgShotsMadeHomePt2, @TMoppAdjPct )  as CalcAwayGB2Pt2
						, dbo.udfCalcTM4GBpts(  @Pt3, tAwayGB2.AverageMadeUsPt3, tHomeGB10.AverageMadeOpPt3, @LgAvgShotsMadeHomePt3, @TMoppAdjPct )  as CalcAwayGB2Pt3

						, dbo.udfCalcTM4GBpts(  @Pt1, tAwayGB3.AverageMadeUsPt1, tHomeGB10.AverageMadeOpPt1, @LgAvgShotsMadeHomePt1, @TMoppAdjPct )  as CalcAwayGB3Pt1
						, dbo.udfCalcTM4GBpts(  @Pt2, tAwayGB3.AverageMadeUsPt2, tHomeGB10.AverageMadeOpPt2, @LgAvgShotsMadeHomePt2, @TMoppAdjPct )  as CalcAwayGB3Pt2
						, dbo.udfCalcTM4GBpts(  @Pt3, tAwayGB3.AverageMadeUsPt3, tHomeGB10.AverageMadeOpPt3, @LgAvgShotsMadeHomePt3, @TMoppAdjPct )  as CalcAwayGB3Pt3

						-- 18 Parms
						, tAwayGB1.AverageMadeUsPt1 as AverageMadeAwayGB1Pt1, tAwayGB1.AverageMadeUsPt2 as AverageMadeAwayGB1Pt2, tAwayGB1.AverageMadeUsPt3 as AverageMadeAwayGB1Pt3
						, tAwayGB2.AverageMadeUsPt1 as AverageMadeAwayGB2Pt1, tAwayGB2.AverageMadeUsPt2 as AverageMadeAwayGB2Pt2, tAwayGB2.AverageMadeUsPt3 as AverageMadeAwayGB2Pt3
						, tAwayGB3.AverageMadeUsPt1 as AverageMadeAwayGB3Pt1, tAwayGB3.AverageMadeUsPt2 as AverageMadeAwayGB3Pt2, tAwayGB3.AverageMadeUsPt3 as AverageMadeAwayGB3Pt3
						, tHomeGB1.AverageMadeUsPt1 as AverageMadeHomeGB1Pt1, tHomeGB1.AverageMadeUsPt2 as AverageMadeHomeGB1Pt2, tHomeGB1.AverageMadeUsPt3 as AverageMadeHomeGB1Pt3
						, tHomeGB2.AverageMadeUsPt1 as AverageMadeHomeGB2Pt1, tHomeGB2.AverageMadeUsPt2 as AverageMadeHomeGB2Pt2, tHomeGB2.AverageMadeUsPt3 as AverageMadeHomeGB2Pt3
						, tHomeGB3.AverageMadeUsPt1 as AverageMadeHomeGB3Pt1, tHomeGB3.AverageMadeUsPt2 as AverageMadeHomeGB3Pt2, tHomeGB3.AverageMadeUsPt3 as AverageMadeHomeGB3Pt3

						-- q1.PlanB for GB1,2,3
						, tAwayGB1.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TMoppAdjPct) )   as CalcAwayGB1PlanB
						, tAwayGB2.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TMoppAdjPct) )   as CalcAwayGB2PlanB
						, tAwayGB3.AverageAdjustedScoreRegUs * ( 1.0 + (( (tHomeGB10.AverageAdjustedScoreRegOp / @LgAvgScoreHome) - 1.0 ) * @TMoppAdjPct) )   as CalcAwayGB3PlanB

						, tHomeGB1.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB1PlanB
						, tHomeGB2.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB2PlanB
						, tHomeGB3.AverageAdjustedScoreRegUs * ( 1.0 + (( (tAwayGB10.AverageAdjustedScoreRegOp / @LgAvgScoreAway) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB3PlanB


						-- Home	
						, @Pt1 * tHomeGB1.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB1Pt1
						, @Pt2 * tHomeGB1.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB1Pt2
						, @Pt3 * tHomeGB1.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB1Pt3

						, @Pt1 * tHomeGB2.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB2Pt1
						, @Pt2 * tHomeGB2.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB2Pt2
						, @Pt3 * tHomeGB2.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB2Pt3

						, @Pt1 * tHomeGB3.AverageMadeUsPt1 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB3Pt1
						, @Pt2 * tHomeGB3.AverageMadeUsPt2 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB3Pt2
						, @Pt3 * tHomeGB3.AverageMadeUsPt3 * ( 1.0 + (( (tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) - 1.0 ) * @TMoppAdjPct) )   as CalcHomeGB3Pt3
						-- Offfence
						, @Pt1 * tAwayGB10.AverageMadeUsPt1  +  @Pt2 * tAwayGB10.AverageMadeUsPt2  +  @Pt3 * tAwayGB10.AverageMadeUsPt3 as AwayAveragePtsScored
						, @Pt1 * tHomeGB10.AverageMadeUsPt1  +  @Pt2 * tHomeGB10.AverageMadeUsPt2  +  @Pt3 * tHomeGB10.AverageMadeUsPt3 as HomeAveragePtsScored
						-- Defence
						, @Pt1 * tAwayGB10.AverageMadeOpPt1  +  @Pt2 * tAwayGB10.AverageMadeOpPt2  +  @Pt3 * tAwayGB10.AverageMadeOpPt3 as AwayAveragePtsAllowed
						, @Pt1 * tHomeGB10.AverageMadeOpPt1  +  @Pt2 * tHomeGB10.AverageMadeOpPt2  +  @Pt3 * tHomeGB10.AverageMadeOpPt3 as HomeAveragePtsAllowed
						-- 03/13/2021
						, tAwayGB10.AverageMadeUsPt1 as AwayAverageMadePt1, tAwayGB10.AverageMadeUsPt2 as AwayAverageMadePt2, tAwayGB10.AverageMadeUsPt3 as AwayAverageMadePt3
						, tHomeGB10.AverageMadeUsPt1 as HomeAverageMadePt1, tHomeGB10.AverageMadeUsPt2 as HomeAverageMadePt2, tHomeGB10.AverageMadeUsPt3 as HomeAverageMadePt3
						, tAwayGB10.AverageMadeOpPt1 as AwayAverageAllowedPt1, tAwayGB10.AverageMadeOpPt2 as AwayAverageAllowedPt2, tAwayGB10.AverageMadeOpPt3 as AwayAverageAllowedPt3
						, tHomeGB10.AverageMadeOpPt1 as HomeAverageAllowedPt1, tHomeGB10.AverageMadeOpPt2 as HomeAverageAllowedPt2, tHomeGB10.AverageMadeOpPt3 as HomeAverageAllowedPt3

						, tAwayGB10.AverageAtmpUsPt1 as AwayAverageAtmpUsPt1, tAwayGB10.AverageAtmpUsPt2 as AwayAverageAtmpUsPt2, tAwayGB10.AverageAtmpUsPt3 as AwayAverageAtmpUsPt3
						, tAwayGB10.AverageAtmpOpPt1 as AwayAverageAtmpOpPt1, tAwayGB10.AverageAtmpOpPt2 as AwayAverageAtmpOpPt2, tAwayGB10.AverageAtmpOpPt3 as AwayAverageAtmpOpPt3

						, tHomeGB10.AverageAtmpUsPt1 as HomeAverageAtmpUsPt1, tHomeGB10.AverageAtmpUsPt2 as HomeAverageAtmpUsPt2, tHomeGB10.AverageAtmpUsPt3 as HomeAverageAtmpUsPt3
						, tHomeGB10.AverageAtmpOpPt1 as HomeAverageAtmpOpPt1, tHomeGB10.AverageAtmpOpPt2 as HomeAverageAtmpOpPt2, tHomeGB10.AverageAtmpOpPt3 as HomeAverageAtmpOpPt3
						
						, tAwayGB10.PtsScoredPctPt1 as AwayPtsScoredPctPt1, tAwayGB10.PtsScoredPctPt2 as AwayPtsScoredPctPt2, tAwayGB10.PtsScoredPctPt3 as AwayPtsScoredPctPt3
						, tHomeGB10.PtsScoredPctPt1 as HomePtsScoredPctPt1, tHomeGB10.PtsScoredPctPt2 as HomePtsScoredPctPt2, tHomeGB10.PtsScoredPctPt3 as HomePtsScoredPctPt3
						--	, @LgAvgShotsMadeHomePt1 as LgAvgShotsMadeHomePt1
						-- TSA
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

			) q2

		) q3
		END TRY
		BEGIN CATCH
			PRINT convert (Varchar, @GameDate) + ': ' + convert (Varchar, @RotNum)
			 PRINT 'Insert TodaysMatchupsError ' + CONVERT(VARCHAR, ERROR_NUMBER(), 1) + ': '+ ERROR_MESSAGE();
			 throw 51000, 'TodaysMatchups Insert error', 1;
		END CATCH
		Set @RotNum = @RotNum + 1	-- ex: RotNum = 702, bump to 702, Get next Rotation row > 702 which is 703
	--	
	--return
	END	--  #4 - Generate TodaysMatchups
END	--  #4 -  TodaysMatchups

IF @Display = 1	Select 'DONE' as Section, dbo.GetTime(11)  as SectionTime

if @Display = 1
	Select '894 END' as Line#, * from TodaysMatchups Where UserName = @UserName  AND  LeagueName = @LeagueName  AND  GameDate = @GameDate


-- select *   FROM [Rotation]   where gamedate >= '1/17/2020'
	return

END	-- St Proc end

END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
         declare @error int, @message varchar(4000), @xstate int
					, @Error_Line int = Error_Line();
        select @error = ERROR_NUMBER(),
                 @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        --if @xstate = -1
        --    rollback;
        --if @xstate = 1 and @trancount = 0
        --    rollback
        --if @xstate = 1 and @trancount > 0
        --    rollback transaction usp_my_procedure_name;

        raiserror ('uspCalcTodaysMatchups: %d: %s - Error Line: %d', 16, 1, @error, @message, @Error_Line) ;
        return;  
END CATCH;  
