Find ALL TILDAs ~
use [00TTI_LeagueScores]
GO
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspCalcTodaysMatchups]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspCalcTodaysMatchups]
GO
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

#3A	Set (LgAvgs,  LastMinDefaults From DailySummary), Season,
#3B	For Each MU in GameDate Rotation
			*** Generate TeamStatsAverages
			Set TeamAway, TeamHome, RotNum from Rotation
			For Each GameBack
				INSERT INTO TeamStatsAverages Away & Home
			Next GB
			
		Next MU


TeamStatsAverages RowCount = #ofMUPs * 2 (Aw/Hm) * 3 (GB)
		
#3C	For Each MU in GameDate Rotation
			*** Generate TodaysMatchups
			Set TeamAway, TeamHome, RotNum from Rotation

		Next MU
#3D	Set GameDate = DateAdd(day, 1, GameDate);
*/
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
CREATE PROCEDURE [dbo].[uspCalcTodaysMatchups] ( @UserName	varchar(10), @LeagueName varchar(8), @GameDate Date )
AS
	SET NOCOUNT ON;
              
	BEGIN  


-- select 38 as PassedParms, @UserName as UserName, @LeagueName, @GameDate ; return;
BEGIN	-- 1) Setup
--SET NOCOUNT  ON;
-- 2) Constants
Declare @Pt1 as float = 1.00	-- Constants Point Values as float
		, @Pt2 as float = 2.00
		, @Pt3 as float = 3.00
		, @Over  as char(4) = 'Over'
		, @Under as char(4) = 'Under'
		, @Away as char(4) = 'Away'
		, @Home as char(4) = 'Home'


-- 3) Parms
Declare
		  @Team varchar(10)
		, @Venue varchar(4)
		, @Season varchar(4) 
		, @SubSeason VarChar(10) 
		, @TeamAway varchar(8) 
		, @TeamHome varchar(8)
		, @RotNum int
		, @ixVenue as int
;


If (Select count(*) From Rotation Where GameDate = @GameDate AND LeagueName = @LeagueName) = 0
BEGIN
	Print 'No Rotation for GameDate'
	Return;
END	
	
-- UserLeagueParms		
Declare @LgGB int 
		, @GB1 int, @GB2 int, @GB3 int, @GB int
		, @WeightGB1 float, @WeightGB2 float, @WeightGB3 float
		, @ThresholdOver float, @ThresholdUnder float
		, @BxScLinePct float, @BxScTmStrPct float, @TmStrAdjPct float

Select @GB1 = GB1, @GB2 = GB2, @GB3 = GB3
      ,@WeightGB1 = WeightGB1, @WeightGB2 = WeightGB2, @WeightGB3 = WeightGB3
      ,@ThresholdOver = ThresholdOver, @ThresholdUnder = ThresholdUnder
      ,@BxScLinePct = BxScLinePct , @BxScTmStrPct = BxScTmStrPct, @TmStrAdjPct = TmStrAdjPct
	From UserLeagueParms Where UserName = @UserName AND LeagueName = @LeagueName
--	Select  @GB1, @GB2, @GB3; return;

-- Load ParmTable Values
Declare @varLgAvgGB int   = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')

Select TOP 1 
	@LgGB = li.NumberOfTeams * @varLgAvgGB
  From LeagueInfo li 
  Where li.LeagueName = @LeagueName    AND li.StartDate <= @GameDate
  Order by li.StartDate Desc
--  select @LgGB


DECLARE @GBTable TABLE (GB INT)
Insert into @GBTable values(@GB1)
Insert into @GBTable values(@GB2)
Insert into @GBTable values(@GB3)

If NOT exists(Select * From @GBTable Where GB = @varTeamAvgGB)
	Insert into @GBTable values(@varTeamAvgGB)		-- 10 GB CONSTANT for Opp Avgs
--Select  * from @GBTable Order By GB; Select  * from @GBTable Order By GB; return 

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

Declare @DailySummaryGameDate date =  (Select max(GameDate) From DailySummary Where LeagueName = @LeagueName );
If @GameDate < @DailySummaryGameDate 
	Set @DailySummaryGameDate = @GameDate;

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
  From DailySummary Where LeagueName = @LeagueName AND GameDate = @DailySummaryGameDate

If @@ROWCOUNT = 0
	SET @ixVenue = 1 / 0;
--BEGIN
--	THROW 51000, 'DailySummary row not found for GameDate & LeagueName', 1; 
--END

-- Select '161', @LgAvgScoreAway, @LgAvgScoreHomey,  @LgAvgShotsMadeAwayPt1 , @LgAvgShotsMadeAwayPt2 , @LgAvgShotsMadeAwayPt3 	  , @LgAvgShotsMadeHomePt1 , @LgAvgShotsMadeHomePt2 , @LgAvgShotsMadeHomePt3 

END -- 1) End Setup



-- **********************************************************************************
-- *** #3mr - Insert MatchupResults from Yesterday's TodaysMatchups ***
-- **********************************************************************************
	EXEC uspInsertMatchupResults @UserName, @LeagueName

-- **********************************************************************************
-- *** #3ts - Rotation Loop for each Game of GameDate - Generate TeamStrength ***
-- **********************************************************************************
	Delete From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate

Declare @TSstartDate date = IsNull(DateAdd(d,1, (Select max(GameDate) From TeamStrength Where LeagueName = @LeagueName)), (Select min(GameDate) From Rotation Where LeagueName = @LeagueName))
Declare @TSendDate date = (Select max(GameDate) From BoxScores Where LeagueName = @LeagueName)

-- 
--Select '169', @TSstartDate as TSstartDate, @TSendDate as TSendDate;  Print 169;	return;
  
Declare @RotationID int = 
	(	Select Top 1   r.RotationID - 1	 --	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
			From Rotation r
			Where r.LeagueName = @LeagueName AND r.GameDate  >= @TSstartDate  -- AND @TSendDate -- AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.GameDate, r.RotNum)
--	 Select '183',  @RotationID as RotationID, @TSstartDate as TSstartDate, @TSendDate as TSendDate;  return;

	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
	-- Get Away RotNum or TeamAway
		Select Top 1  @RotationID = r.RotationID, @TSstartDate = r.GameDate,	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
			From Rotation r
	--			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.RotationID > @RotationID	AND  r.GameDate <= @TSendDate		-- AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotationID
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

		Declare  @TmStr TABLE (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float)
	 	Delete  @TmStr
		Insert into @TmStr
		EXEC uspQueryCalcTeamStrength
				@GameDate			-- 1 
			, @LeagueName -- 2 
			, @Team 		-- 3 
			, @Venue 	-- 4 
			, @Season
			, @TmStrAdjPct  		-- 6
			, @BxScLinePct		-- 7	30% of of the ActualScore will be curved back to line ex: Actual: 30 Line: 20 - 30% of 10 = 3. Actual goes from 30 to 27
			, @LgAvgScoreAway 	-- 8  	
			, @LgAvgScoreHome  -- 9
			, @varLgAvgGB 		-- 10 

		Insert into TeamStrength (LeagueName,  GameDate,  RotNum,  Team,  Venue, TeamStrength,                         TeamStrengthScored,  TeamStrengthAllowed , TeamStrengthBxScAdjPctScored, TeamStrengthBxScAdjPctAllowed, TeamStrengthTMsAdjPctScored, TeamStrengthTMsAdjPctAllowed   )
		Select  			          @LeagueName, @TSstartDate, @RotNum, @Team, @Venue, AvgTmStrPtsScored+AvgTmStrPtsAllowed, AvgTmStrPtsScored,   AvgTmStrPtsAllowed, @LgAvgTeamScored / AvgTmStrPtsScored, @LgAvgTeamAllowed / AvgTmStrPtsAllowed, AvgTmStrPtsScored / @LgAvgTeamScored, AvgTmStrPtsAllowed/ @LgAvgTeamAllowed
			From @TmStr 
			
--	Select '199', * from @TmStr;  Print 222;	Return;
	END	-- Rotation Loop
	-- 	Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Print 223; 	return;


if 1 = 1 BEGIN -- temp if to Bypass TeamStatsAverages
		Set @GB = 0;
	While 1 = 1		-- Loop 3 times for each GB value
	BEGIN
		Select Top 1 @GB = g.GB
			From @GBTable g
			Where g.GB > @GB
			Order by g.GB
		If @@ROWCOUNT = 0
			BREAK;
		Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate and GB = @GB
	END -- GB loop
	-- **********************************************************************************
	-- *** #3B - Rotation Loop for each Game of GameDate - Generate TeamStatsAverages ***
	-- **********************************************************************************
	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
	-- Get Away RotNum & TeamAway
		Select Top 1 	@TeamAway = r.Team,  @TeamHome = rh.Team,  @RotNum = r.RotNum
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;

	--		Select @GameDate, @RotNum, @TeamAway, @TeamHome; return;

		Set @GB = 0;
		While 1 = 1		-- Loop 3 times for each GB value
		BEGIN
			Select Top 1 @GB = g.GB
				From @GBTable g
				Where g.GB > @GB
				Order by g.GB
			If @@ROWCOUNT = 0
				BREAK;

			Set @ixVenue = 0

			Set @Team  = @TeamAway
			Set @Venue = @Away

			While @ixVenue < 2
			BEGIN	-- Venue Loop

				INSERT INTO TeamStatsAverages		-- Each Venue
				(
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					,[GB],			[StartGameDate]
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
				)
				Select @UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team, @Venue as Venue
						,@GB as GB			,Min(GameDate) AS StartGameDate
						,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)
						,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)
					From ( -- aw

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
						-- Adjustments
-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - S

							--	 OT already Out		|				2) Take out Last Min												 | ' 1   + (( (TmTL             / ScReg		   ) - 1 ) * @BxScLinePct)	
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt3
							--, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt1
							--, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt2
							--, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt3

							--, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt1
							--, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt2
							--, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt3

						From BoxScores b
							JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Join TeamStrength ts ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  b.Venue = @Venue
							AND  b.Season = @Season
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = '1-Reg')
							AND  b.Exclude = 0
							Order BY b.GameDate DESC
					) x

				Set @ixVenue = @ixVenue + 1
				Set @Team  = @TeamHome
				Set @Venue = @Home

			END	-- Venue Loop

 	
		END	-- GB loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- Generate TeamStatsAverages - Rotation Loop	

END -- temp bypass

BEGIN -- #3C Todays Matchups

/*
6 Tm Line Stats - Last3 by HA
		 L3	 L5	 L7
Away	107.4	103.7	105.5
Home  112.0	109.2	109.7

Each Tm Line stat
3 Pt value Lines - 1, 2, 3
3 Stats per Pt Value - 
1) Tm Avg Pts
2) Opp OpVenue Pts Allowed
3) Lg Avg

	M5155 - Curve: 2 <== Adjust Boxscores Curve
	Home Team: PHI - Last 3  Actual Games Back: 3  Start Date: 12/18/2019
	Total  = 1 PTers +  2 PTers +  3 PTers + Tm Str Adj
	110.18 =  14.41  +   57.17  +   38.60  +    0.00
	Lg Avg Sc = 219.89        (Opp Stat Games Back: 10)   varOppStatAdjFactor
	Calc        = Pt * Pts  * ((MILAw/LgAvgAw)+ AdjFac) / (AdjFac+1)
	1 Pts 14.41 = 1 * 14.85 * ((16.15 / 17.17)  +  1)   /   (1 + 1)
	2 Pts 57.17 = 2 * 29.55 * ((25.82 / 27.62)  +  1)   /   (1 + 1)
	3 Pts 38.60 = 3 * 11.96 * ((13.77 / 11.96)  +  1)   /   (1 + 1)
Need 3 Stats per line  1			2		  3
*/


	Select '369' as Line#, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3
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
	-- *** #3C -  Rotation Loop for each Game of GameDate - Generate TodaysMatchups ***
	-- ********************************************************************************
	Declare @TotalLine as float, @OpenTotalLine as float, @SideLine float

	Delete from TodaysMatchups Where UserName = @UserName AND LeagueName = @LeagueName AND GameDate = @GameDate
	Set @RotNum = 0;
	
	While @RotNum < 1000		-- #3C - Generate TodaysMatchups
	BEGIN
		-- [UserName]  ,[LeagueName]       ,[GameDate]      ,[RotNum]  ,[GB]

		Select Top 1 
				@RotNum = r.RotNum, 	@TeamAway = r.Team,  @TeamHome = rh.Team, @TotalLine = r.TotalLine, @SideLine = r.SideLine
			-- '===>',	 r.RotNum, 	 r.Team, rh.Team
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeageName since Rotnum using Greater Than to make unique
			Order by r.RotNum
			
		If @@ROWCOUNT = 0
			BREAK;
		
		If @TotalLine = 0
			Set @TotalLine = null
		--Select '424', @TotalLine as tl

--	 / *	
		Insert Into TodaysMatchups (
			  UserName, GameDate, LeagueName, Season, SubSeason, RotNum, TeamAway, TeamHome		--6

			, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal
			, AdjAmtAway,  AdjAmtHome,  AdjAmt	--3
			, OurTotalLineAway, OurTotalLineHome, OurTotalLine	--3
			
			, TotalLine, SideLine, LineDiff,  Play	--3

			,BxScLinePct, TmStrAdjPct
			--6
			, AwayGB1, AwayGB2, AwayGB3
			, HomeGB1, HomeGB2, HomeGB3
			--9
			, AwayGB1Pt1,  AwayGB1Pt2,  AwayGB1Pt3
			, AwayGB2Pt1, AwayGB2Pt2,  AwayGB2Pt3
			, AwayGB3Pt1,  AwayGB3Pt2,  AwayGB3Pt3
			--9
			, HomeGB1Pt1,  HomeGB1Pt2,   HomeGB1Pt3
			, HomeGB2Pt1,  HomeGB2Pt2,   HomeGB2Pt3
			, HomeGB3Pt1,  HomeGB3Pt2,   HomeGB3Pt3

			, GB1, GB2, GB3
			, WeightGB1, WeightGB2, WeightGB3
		)
		
		Select  @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @Season as Season, @SubSeason as SubSeason, @RotNum as RotNum, tm2.TeamAway, tm2.TeamHome -- 6
				, CalcAway as UnAdjTotalAway, CalcHome as UnAdjTotalHome, CalcAway + CalcHome as UnAdjTotal

				, AdjAmtAway, AdjAmtHome, AdjAmtHome + AdjAmtHome as AdjAmt
				--4
				, CalcAway + AdjAmtAway as OurTotalLineAway
				, CalcHome + AdjAmtHome as OurTotalLineHome
				, CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome as OurTotalLine

				, @TotalLine as TotalLine, @SideLine as SideLine

				, CASE 
						WHEN @TotalLine IS Null THEN Null
						WHEN @TotalLine < 1	  THEN Null
						ELSE CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine
					END AS LineDiff

				, CASE 
						WHEN @TotalLine IS Null THEN Null
						WHEN @TotalLine = 0.0	  THEN Null
						WHEN (CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine) >= @ThresholdOver THEN @Over
						WHEN (CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine) <= @ThresholdUnder THEN @Under
						ELSE ''
					END AS Play
				--3
				, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct

				, CalcAwayGB1Pt1 + CalcAwayGB1Pt2 + CalcAwayGB1Pt3 as AwayGB1
				, CalcAwayGB2Pt1 + CalcAwayGB2Pt2 + CalcAwayGB2Pt3 as AwayGB2
				, CalcAwayGB3Pt1 + CalcAwayGB3Pt2 + CalcAwayGB3Pt3 as AwayGB3
				, CalcHomeGB1Pt1 + CalcHomeGB1Pt2 + CalcHomeGB1Pt3 as HomeGB1
				, CalcHomeGB2Pt1 + CalcHomeGB2Pt2 + CalcHomeGB2Pt3 as HomeGB2
				, CalcHomeGB3Pt1 + CalcHomeGB3Pt2 + CalcHomeGB3Pt3 as HomeGB3
				--9
				, CalcAwayGB1Pt1 as AwayGB1Pt1, CalcAwayGB1Pt2 as AwayGB1Pt2, CalcAwayGB1Pt3 as AwayGB1Pt3
				, CalcAwayGB2Pt1 as AwayGB2Pt1, CalcAwayGB2Pt2 as AwayGB2Pt2, CalcAwayGB2Pt3 as AwayGB2Pt3
				, CalcAwayGB3Pt1 as AwayGB3Pt1, CalcAwayGB3Pt2 as AwayGB3Pt2, CalcAwayGB3Pt3 as AwayGB3Pt3
				--9
				, CalcHomeGB1Pt1 as HomeGB1Pt1, CalcHomeGB1Pt2 as HomeGB1Pt2, CalcHomeGB1Pt3 as HomeGB1Pt3
				, CalcHomeGB2Pt1 as HomeGB2Pt1, CalcHomeGB2Pt2 as HomeGB2Pt2, CalcHomeGB2Pt3 as HomeGB2Pt3
				, CalcHomeGB3Pt1 as HomeGB3Pt1, CalcHomeGB3Pt2 as HomeGB3Pt2, CalcHomeGB3Pt3 as HomeGB3Pt3

				, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3
				, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3

		  From (
			Select 'L435' as L435, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tm.TeamAway, tm.TeamHome
				, (Select AdjustmentAmount From AdjustmentsDaily Where LeagueName = @LeagueName AND GameDate = @GameDate AND Team = @TeamAway) as AdjAmtAway
				, (Select AdjustmentAmount From AdjustmentsDaily Where LeagueName = @LeagueName AND GameDate = @GameDate AND Team = @TeamHome) as AdjAmtHome

				, (
					((tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 ) * @WeightGB1) 
				 + ((tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 ) * @WeightGB2)
				 + ((tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 ) * @WeightGB3)
			 		) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcAway 

				, (
					((tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 ) * @WeightGB1) 
				 + ((tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 ) * @WeightGB2)
				 + ((tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 ) * @WeightGB3)
			 		) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcHome 
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

			  From (
	--* /
			  --    ,[LeagueName]      ,[GameDate]      ,[Season]      ,[SubSeason]      ,[TeamAway]      ,[TeamHome]      ,[RotNum]      ,[Time]
				Select '496' as Line#, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tAwayGB1.Team as TeamAway, tHomeGB1.Team as TeamHome
																															-- kdtodo use @TmAdjFac
				-- = Pt * Pts  * ((CHAHm/LgAvgHm)+ AdjFac) / (AdjFac+1)
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

						--, @Pt1 * tAwayGB1.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt1
						--, @Pt2 * tAwayGB1.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt2
						--, @Pt3 * tAwayGB1.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt3

						--, @Pt1 * tAwayGB2.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt1
						--, @Pt2 * tAwayGB2.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt2
						--, @Pt3 * tAwayGB2.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt3

						--, @Pt1 * tAwayGB3.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt1
						--, @Pt2 * tAwayGB3.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt2
						--, @Pt3 * tAwayGB3.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt3

						--, @Pt1 * tHomeGB1.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt1
						--, @Pt2 * tHomeGB1.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt2
						--, @Pt3 * tHomeGB1.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt3

						--, @Pt1 * tHomeGB2.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt1
						--, @Pt2 * tHomeGB2.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt2
						--, @Pt3 * tHomeGB2.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt3

						--, @Pt1 * tHomeGB3.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt1
						--, @Pt2 * tHomeGB3.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt2
						--, @Pt3 * tHomeGB3.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt3

						, tAwayGB1.AverageMadeUsPt1 as AverageMadeUsPt1
						, tHomeGB1.AverageMadeUsPt1 as AverageMadeOpPt1 
						, @LgAvgShotsMadeHomePt1 as LgAvgShotsMadeHomePt1
				From TeamStatsAverages tAwayGB1
				JOIN TeamStatsAverages tAwayGB2 ON tAwayGB2.UserName = @UserName AND tAwayGB2.GameDate = @GameDate AND tAwayGB2.RotNum = @RotNum    AND tAwayGB2.GB = @GB2
				JOIN TeamStatsAverages tAwayGB3 ON tAwayGB3.UserName = @UserName AND tAwayGB3.GameDate = @GameDate AND tAwayGB3.RotNum = @RotNum    AND tAwayGB3.GB = @GB3
				JOIN TeamStatsAverages tAwayGB10 ON tAwayGB10.UserName = @UserName AND tAwayGB10.GameDate = @GameDate AND tAwayGB10.RotNum = @RotNum    AND tAwayGB10.GB = @varTeamAvgGB

				JOIN TeamStatsAverages tHomeGB1 ON tHomeGB1.UserName = @UserName AND tHomeGB1.GameDate = @GameDate AND tHomeGB1.RotNum = @RotNum +1 AND tHomeGB1.GB = @GB1
				JOIN TeamStatsAverages tHomeGB2 ON tHomeGB2.UserName = @UserName AND tHomeGB2.GameDate = @GameDate AND tHomeGB2.RotNum = @RotNum +1 AND tHomeGB2.GB = @GB2
				JOIN TeamStatsAverages tHomeGB3 ON tHomeGB3.UserName = @UserName AND tHomeGB3.GameDate = @GameDate AND tHomeGB3.RotNum = @RotNum +1 AND tHomeGB3.GB = @GB3
				JOIN TeamStatsAverages tHomeGB10 ON tHomeGB10.UserName = @UserName AND tHomeGB10.GameDate = @GameDate AND tHomeGB10.RotNum = @RotNum +1 AND tHomeGB10.GB = @varTeamAvgGB

					Where tAwayGB1.UserName = @UserName AND tAwayGB1.GameDate = @GameDate AND tAwayGB1.RotNum = @RotNum	
						AND tAwayGB1.GB = @GB1

			) tm

		) tm2
		Set @RotNum = @RotNum + 1
	--	
	--return
	END	--  #3C - Generate TodaysMatchups
END	--  #3C -  TodaysMatchups

Select * from TodaysMatchups Where UserName = @UserName AND LeagueName = @LeagueName AND GameDate = @GameDate

-- select *   FROM [Rotation]   where gamedate >= '1/17/2020'
	return



	END
GO

-- __________________________________________________________________________________________________________


use [00TTI_LeagueScores]
GO
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

/*
#1	Set User vars - GB, GBWeights, Curves From UserLeagueParms

#3A	Set (LgAvgs,  LastMinDefaults From DailySummary), Season,
#3B	For Each MU in GameDate Rotation
			*** Generate TeamStatsAverages
			Set TeamAway, TeamHome, RotNum from Rotation
			For Each GameBack
				INSERT INTO TeamStatsAverages Away & Home
			Next GB
			
		Next MU


TeamStatsAverages RowCount = #ofMUPs * 2 (Aw/Hm) * 3 (GB)
		
#3C	For Each MU in GameDate Rotation
			*** Generate TodaysMatchups
			Set TeamAway, TeamHome, RotNum from Rotation

		Next MU
#3D	Set GameDate = DateAdd(day, 1, GameDate);
*/

-- Inputed Vars --

-- 1) Passed Parms
Declare @UserName	varchar(10)	= 'Test'
		, @LeagueName varchar(8) = 'NBA'
		, @GameDate Date		= '1/19/2020' --  CONVERT(date, getdate())		-- '01/13/2020'

-- select 38 as PassedParms, @UserName as UserName, @LeagueName, @GameDate ; return;
BEGIN	-- 1) Setup
--SET NOCOUNT  ON;
-- 2) Constants
Declare @Pt1 as float = 1.00	-- Constants Point Values as float
		, @Pt2 as float = 2.00
		, @Pt3 as float = 3.00
		, @Over  as char(4) = 'Over'
		, @Under as char(4) = 'Under'
		, @Away as char(4) = 'Away'
		, @Home as char(4) = 'Home'


-- 3) Parms
Declare
		  @Team varchar(10)
		, @Venue varchar(4)
		, @Season varchar(4) 
		, @SubSeason VarChar(10) 
		, @TeamAway varchar(8) 
		, @TeamHome varchar(8)
		, @RotNum int
		, @ixVenue as int
;


If (Select count(*) From Rotation Where GameDate = @GameDate AND LeagueName = @LeagueName) = 0
BEGIN
	Print 'No Rotation for GameDate'
	Return;
END	
	
-- UserLeagueParms		
Declare @LgGB int 
		, @GB1 int, @GB2 int, @GB3 int, @GB int
		, @WeightGB1 float, @WeightGB2 float, @WeightGB3 float
		, @ThresholdOver float, @ThresholdUnder float
		, @BxScLinePct float, @BxScTmStrPct float, @TmStrAdjPct float

Select @GB1 = GB1, @GB2 = GB2, @GB3 = GB3
      ,@WeightGB1 = WeightGB1, @WeightGB2 = WeightGB2, @WeightGB3 = WeightGB3
      ,@ThresholdOver = ThresholdOver, @ThresholdUnder = ThresholdUnder
      ,@BxScLinePct = BxScLinePct , @BxScTmStrPct = BxScTmStrPct, @TmStrAdjPct = TmStrAdjPct
	From UserLeagueParms Where UserName = @UserName AND LeagueName = @LeagueName
--	Select  @GB1, @GB2, @GB3; return;

-- Load ParmTable Values
Declare @varLgAvgGB int   = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')

Select TOP 1 
	@LgGB = li.NumberOfTeams * @varLgAvgGB
  From LeagueInfo li 
  Where li.LeagueName = @LeagueName    AND li.StartDate <= @GameDate
  Order by li.StartDate Desc
--  select @LgGB


DECLARE @GBTable TABLE (GB INT)
Insert into @GBTable values(@GB1)
Insert into @GBTable values(@GB2)
Insert into @GBTable values(@GB3)

If NOT exists(Select * From @GBTable Where GB = @varTeamAvgGB)
	Insert into @GBTable values(@varTeamAvgGB)		-- 10 GB CONSTANT for Opp Avgs
--Select  * from @GBTable Order By GB; Select  * from @GBTable Order By GB; return 

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

Declare @DailySummaryGameDate date =  (Select max(GameDate) From DailySummary Where LeagueName = @LeagueName );
If @GameDate < @DailySummaryGameDate 
	Set @DailySummaryGameDate = @GameDate;

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
  From DailySummary Where LeagueName = @LeagueName AND GameDate = @DailySummaryGameDate

If @@ROWCOUNT = 0
	SET @ixVenue = 1 / 0;
--BEGIN
--	THROW 51000, 'DailySummary row not found for GameDate & LeagueName', 1; 
--END

-- Select '161', @LgAvgScoreAway, @LgAvgScoreHomey,  @LgAvgShotsMadeAwayPt1 , @LgAvgShotsMadeAwayPt2 , @LgAvgShotsMadeAwayPt3 	  , @LgAvgShotsMadeHomePt1 , @LgAvgShotsMadeHomePt2 , @LgAvgShotsMadeHomePt3 

END -- 1) End Setup



-- **********************************************************************************
-- *** #3mr - Insert MatchupResults from Yesterday's TodaysMatchups ***
-- **********************************************************************************
	EXEC uspInsertMatchupResults @UserName, @LeagueName

-- **********************************************************************************
-- *** #3ts - Rotation Loop for each Game of GameDate - Generate TeamStrength ***
-- **********************************************************************************
	Delete From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate

Declare @TSstartDate date = IsNull(DateAdd(d,1, (Select max(GameDate) From TeamStrength Where LeagueName = @LeagueName)), (Select min(GameDate) From Rotation Where LeagueName = @LeagueName))
Declare @TSendDate date = (Select max(GameDate) From BoxScores Where LeagueName = @LeagueName)

-- 
--Select '169', @TSstartDate as TSstartDate, @TSendDate as TSendDate;  Print 169;	return;
  
Declare @RotationID int = 
	(	Select Top 1   r.RotationID - 1	 --	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
			From Rotation r
			Where r.LeagueName = @LeagueName AND r.GameDate  >= @TSstartDate  -- AND @TSendDate -- AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.GameDate, r.RotNum)
--	 Select '183',  @RotationID as RotationID, @TSstartDate as TSstartDate, @TSendDate as TSendDate;  return;

	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
	-- Get Away RotNum or TeamAway
		Select Top 1  @RotationID = r.RotationID, @TSstartDate = r.GameDate,	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
			From Rotation r
	--			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.RotationID > @RotationID	AND  r.GameDate <= @TSendDate		-- AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotationID
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

		Declare  @TmStr TABLE (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float)
	 	Delete  @TmStr
		Insert into @TmStr
		EXEC uspQueryCalcTeamStrength
				@GameDate			-- 1 
			, @LeagueName -- 2 
			, @Team 		-- 3 
			, @Venue 	-- 4 
			, @Season
			, @TmStrAdjPct  		-- 6
			, @BxScLinePct		-- 7	30% of of the ActualScore will be curved back to line ex: Actual: 30 Line: 20 - 30% of 10 = 3. Actual goes from 30 to 27
			, @LgAvgScoreAway 	-- 8  	
			, @LgAvgScoreHome  -- 9
			, @varLgAvgGB 		-- 10 

		Insert into TeamStrength (LeagueName,  GameDate,  RotNum,  Team,  Venue, TeamStrength,                         TeamStrengthScored,  TeamStrengthAllowed , TeamStrengthBxScAdjPctScored, TeamStrengthBxScAdjPctAllowed, TeamStrengthTMsAdjPctScored, TeamStrengthTMsAdjPctAllowed   )
		Select  			          @LeagueName, @TSstartDate, @RotNum, @Team, @Venue, AvgTmStrPtsScored+AvgTmStrPtsAllowed, AvgTmStrPtsScored,   AvgTmStrPtsAllowed, @LgAvgTeamScored / AvgTmStrPtsScored, @LgAvgTeamAllowed / AvgTmStrPtsAllowed, AvgTmStrPtsScored / @LgAvgTeamScored, AvgTmStrPtsAllowed/ @LgAvgTeamAllowed
			From @TmStr 
			
--	Select '199', * from @TmStr;  Print 222;	Return;
	END	-- Rotation Loop
	-- 	Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Print 223; 	return;


if 1 = 1 BEGIN -- temp if to Bypass TeamStatsAverages
		Set @GB = 0;
	While 1 = 1		-- Loop 3 times for each GB value
	BEGIN
		Select Top 1 @GB = g.GB
			From @GBTable g
			Where g.GB > @GB
			Order by g.GB
		If @@ROWCOUNT = 0
			BREAK;
		Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate and GB = @GB
	END -- GB loop
	-- **********************************************************************************
	-- *** #3B - Rotation Loop for each Game of GameDate - Generate TeamStatsAverages ***
	-- **********************************************************************************
	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
	-- Get Away RotNum & TeamAway
		Select Top 1 	@TeamAway = r.Team,  @TeamHome = rh.Team,  @RotNum = r.RotNum
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;

	--		Select @GameDate, @RotNum, @TeamAway, @TeamHome; return;

		Set @GB = 0;
		While 1 = 1		-- Loop 3 times for each GB value
		BEGIN
			Select Top 1 @GB = g.GB
				From @GBTable g
				Where g.GB > @GB
				Order by g.GB
			If @@ROWCOUNT = 0
				BREAK;

			Set @ixVenue = 0

			Set @Team  = @TeamAway
			Set @Venue = @Away

			While @ixVenue < 2
			BEGIN	-- Venue Loop

				INSERT INTO TeamStatsAverages		-- Each Venue
				(
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					,[GB],			[StartGameDate]
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
				)
				Select @UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team, @Venue as Venue
						,@GB as GB			,Min(GameDate) AS StartGameDate
						,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)
						,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)
					From ( -- aw

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
						-- Adjustments
-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - S

							--	 OT already Out		|				2) Take out Last Min												 | ' 1   + (( (TmTL             / ScReg		   ) - 1 ) * @BxScLinePct)	
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctAllowed - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (ts.TeamStrengthBxScAdjPctScored  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt3
							--, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt1
							--, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt2
							--, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )	AS AverageMadeUsPt3

							--, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt1
							--, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt2
							--, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) )	AS AverageMadeOpPt3

						From BoxScores b
							JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Join TeamStrength ts ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  b.Venue = @Venue
							AND  b.Season = @Season
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = '1-Reg')
							AND  b.Exclude = 0
							Order BY b.GameDate DESC
					) x

				Set @ixVenue = @ixVenue + 1
				Set @Team  = @TeamHome
				Set @Venue = @Home

			END	-- Venue Loop

 	
		END	-- GB loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- Generate TeamStatsAverages - Rotation Loop	

END -- temp bypass

BEGIN -- #3C Todays Matchups

/*
6 Tm Line Stats - Last3 by HA
		 L3	 L5	 L7
Away	107.4	103.7	105.5
Home  112.0	109.2	109.7

Each Tm Line stat
3 Pt value Lines - 1, 2, 3
3 Stats per Pt Value - 
1) Tm Avg Pts
2) Opp OpVenue Pts Allowed
3) Lg Avg

	M5155 - Curve: 2 <== Adjust Boxscores Curve
	Home Team: PHI - Last 3  Actual Games Back: 3  Start Date: 12/18/2019
	Total  = 1 PTers +  2 PTers +  3 PTers + Tm Str Adj
	110.18 =  14.41  +   57.17  +   38.60  +    0.00
	Lg Avg Sc = 219.89        (Opp Stat Games Back: 10)   varOppStatAdjFactor
	Calc        = Pt * Pts  * ((MILAw/LgAvgAw)+ AdjFac) / (AdjFac+1)
	1 Pts 14.41 = 1 * 14.85 * ((16.15 / 17.17)  +  1)   /   (1 + 1)
	2 Pts 57.17 = 2 * 29.55 * ((25.82 / 27.62)  +  1)   /   (1 + 1)
	3 Pts 38.60 = 3 * 11.96 * ((13.77 / 11.96)  +  1)   /   (1 + 1)
Need 3 Stats per line  1			2		  3
*/


	Select '369' as Line#, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3
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
	-- *** #3C -  Rotation Loop for each Game of GameDate - Generate TodaysMatchups ***
	-- ********************************************************************************
	Declare @TotalLine as float, @OpenTotalLine as float, @SideLine float

	Delete from TodaysMatchups Where UserName = @UserName AND LeagueName = @LeagueName AND GameDate = @GameDate
	Set @RotNum = 0;
	
	While @RotNum < 1000		-- #3C - Generate TodaysMatchups
	BEGIN
		-- [UserName]  ,[LeagueName]       ,[GameDate]      ,[RotNum]  ,[GB]

		Select Top 1 
				@RotNum = r.RotNum, 	@TeamAway = r.Team,  @TeamHome = rh.Team, @TotalLine = r.TotalLine, @SideLine = r.SideLine
			-- '===>',	 r.RotNum, 	 r.Team, rh.Team
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeageName since Rotnum using Greater Than to make unique
			Order by r.RotNum
			
		If @@ROWCOUNT = 0
			BREAK;
		
		If @TotalLine = 0
			Set @TotalLine = null
		--Select '424', @TotalLine as tl

--	 / *	
		Insert Into TodaysMatchups (
			  UserName, GameDate, LeagueName, Season, SubSeason, RotNum, TeamAway, TeamHome		--6

			, UnAdjTotalAway, UnAdjTotalHome, UnAdjTotal
			, AdjAmtAway,  AdjAmtHome,  AdjAmt	--3
			, OurTotalLineAway, OurTotalLineHome, OurTotalLine	--3
			
			, TotalLine, SideLine, LineDiff,  Play	--3

			,BxScLinePct, TmStrAdjPct
			--6
			, AwayGB1, AwayGB2, AwayGB3
			, HomeGB1, HomeGB2, HomeGB3
			--9
			, AwayGB1Pt1,  AwayGB1Pt2,  AwayGB1Pt3
			, AwayGB2Pt1, AwayGB2Pt2,  AwayGB2Pt3
			, AwayGB3Pt1,  AwayGB3Pt2,  AwayGB3Pt3
			--9
			, HomeGB1Pt1,  HomeGB1Pt2,   HomeGB1Pt3
			, HomeGB2Pt1,  HomeGB2Pt2,   HomeGB2Pt3
			, HomeGB3Pt1,  HomeGB3Pt2,   HomeGB3Pt3

			, GB1, GB2, GB3
			, WeightGB1, WeightGB2, WeightGB3
		)
		
		Select  @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @Season as Season, @SubSeason as SubSeason, @RotNum as RotNum, tm2.TeamAway, tm2.TeamHome -- 6
				, CalcAway as UnAdjTotalAway, CalcHome as UnAdjTotalHome, CalcAway + CalcHome as UnAdjTotal

				, AdjAmtAway, AdjAmtHome, AdjAmtHome + AdjAmtHome as AdjAmt
				--4
				, CalcAway + AdjAmtAway as OurTotalLineAway
				, CalcHome + AdjAmtHome as OurTotalLineHome
				, CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome as OurTotalLine

				, @TotalLine as TotalLine, @SideLine as SideLine

				, CASE 
						WHEN @TotalLine IS Null THEN Null
						WHEN @TotalLine < 1	  THEN Null
						ELSE CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine
					END AS LineDiff

				, CASE 
						WHEN @TotalLine IS Null THEN Null
						WHEN @TotalLine = 0.0	  THEN Null
						WHEN (CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine) >= @ThresholdOver THEN @Over
						WHEN (CalcAway + CalcHome+ AdjAmtAway + AdjAmtHome - @TotalLine) <= @ThresholdUnder THEN @Under
						ELSE ''
					END AS Play
				--3
				, @BxScLinePct as BxScLinePct, @TmStrAdjPct as TmStrAdjPct

				, CalcAwayGB1Pt1 + CalcAwayGB1Pt2 + CalcAwayGB1Pt3 as AwayGB1
				, CalcAwayGB2Pt1 + CalcAwayGB2Pt2 + CalcAwayGB2Pt3 as AwayGB2
				, CalcAwayGB3Pt1 + CalcAwayGB3Pt2 + CalcAwayGB3Pt3 as AwayGB3
				, CalcHomeGB1Pt1 + CalcHomeGB1Pt2 + CalcHomeGB1Pt3 as HomeGB1
				, CalcHomeGB2Pt1 + CalcHomeGB2Pt2 + CalcHomeGB2Pt3 as HomeGB2
				, CalcHomeGB3Pt1 + CalcHomeGB3Pt2 + CalcHomeGB3Pt3 as HomeGB3
				--9
				, CalcAwayGB1Pt1 as AwayGB1Pt1, CalcAwayGB1Pt2 as AwayGB1Pt2, CalcAwayGB1Pt3 as AwayGB1Pt3
				, CalcAwayGB2Pt1 as AwayGB2Pt1, CalcAwayGB2Pt2 as AwayGB2Pt2, CalcAwayGB2Pt3 as AwayGB2Pt3
				, CalcAwayGB3Pt1 as AwayGB3Pt1, CalcAwayGB3Pt2 as AwayGB3Pt2, CalcAwayGB3Pt3 as AwayGB3Pt3
				--9
				, CalcHomeGB1Pt1 as HomeGB1Pt1, CalcHomeGB1Pt2 as HomeGB1Pt2, CalcHomeGB1Pt3 as HomeGB1Pt3
				, CalcHomeGB2Pt1 as HomeGB2Pt1, CalcHomeGB2Pt2 as HomeGB2Pt2, CalcHomeGB2Pt3 as HomeGB2Pt3
				, CalcHomeGB3Pt1 as HomeGB3Pt1, CalcHomeGB3Pt2 as HomeGB3Pt2, CalcHomeGB3Pt3 as HomeGB3Pt3

				, @GB1 as GB1, @GB2 as GB2, @GB3 as GB3
				, @WeightGB1 as WeightGB1, @WeightGB2 as WeightGB2, @WeightGB3 as WeightGB3

		  From (
			Select 'L435' as L435, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tm.TeamAway, tm.TeamHome
				, (Select AdjustmentAmount From AdjustmentsDaily Where LeagueName = @LeagueName AND GameDate = @GameDate AND Team = @TeamAway) as AdjAmtAway
				, (Select AdjustmentAmount From AdjustmentsDaily Where LeagueName = @LeagueName AND GameDate = @GameDate AND Team = @TeamHome) as AdjAmtHome

				, (
					((tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 ) * @WeightGB1) 
				 + ((tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 ) * @WeightGB2)
				 + ((tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 ) * @WeightGB3)
			 		) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcAway 

				, (
					((tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 ) * @WeightGB1) 
				 + ((tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 ) * @WeightGB2)
				 + ((tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 ) * @WeightGB3)
			 		) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcHome 
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

			  From (
	--* /
			  --    ,[LeagueName]      ,[GameDate]      ,[Season]      ,[SubSeason]      ,[TeamAway]      ,[TeamHome]      ,[RotNum]      ,[Time]
				Select '496' as Line#, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tAwayGB1.Team as TeamAway, tHomeGB1.Team as TeamHome
																															-- kdtodo use @TmAdjFac
				-- = Pt * Pts  * ((CHAHm/LgAvgHm)+ AdjFac) / (AdjFac+1)
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

						--, @Pt1 * tAwayGB1.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt1
						--, @Pt2 * tAwayGB1.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt2
						--, @Pt3 * tAwayGB1.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB1Pt3

						--, @Pt1 * tAwayGB2.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt1
						--, @Pt2 * tAwayGB2.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt2
						--, @Pt3 * tAwayGB2.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB2Pt3

						--, @Pt1 * tAwayGB3.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt1
						--, @Pt2 * tAwayGB3.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt2
						--, @Pt3 * tAwayGB3.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcAwayGB3Pt3

						--, @Pt1 * tHomeGB1.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt1
						--, @Pt2 * tHomeGB1.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt2
						--, @Pt3 * tHomeGB1.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB1Pt3

						--, @Pt1 * tHomeGB2.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt1
						--, @Pt2 * tHomeGB2.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt2
						--, @Pt3 * tHomeGB2.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB2Pt3

						--, @Pt1 * tHomeGB3.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt1
						--, @Pt2 * tHomeGB3.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt2
						--, @Pt3 * tHomeGB3.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_TMs ) / ( @Curve_Factor_TMs + 1.0 ) as CalcHomeGB3Pt3

						, tAwayGB1.AverageMadeUsPt1 as AverageMadeUsPt1
						, tHomeGB1.AverageMadeUsPt1 as AverageMadeOpPt1 
						, @LgAvgShotsMadeHomePt1 as LgAvgShotsMadeHomePt1
				From TeamStatsAverages tAwayGB1
				JOIN TeamStatsAverages tAwayGB2 ON tAwayGB2.UserName = @UserName AND tAwayGB2.GameDate = @GameDate AND tAwayGB2.RotNum = @RotNum    AND tAwayGB2.GB = @GB2
				JOIN TeamStatsAverages tAwayGB3 ON tAwayGB3.UserName = @UserName AND tAwayGB3.GameDate = @GameDate AND tAwayGB3.RotNum = @RotNum    AND tAwayGB3.GB = @GB3
				JOIN TeamStatsAverages tAwayGB10 ON tAwayGB10.UserName = @UserName AND tAwayGB10.GameDate = @GameDate AND tAwayGB10.RotNum = @RotNum    AND tAwayGB10.GB = @varTeamAvgGB

				JOIN TeamStatsAverages tHomeGB1 ON tHomeGB1.UserName = @UserName AND tHomeGB1.GameDate = @GameDate AND tHomeGB1.RotNum = @RotNum +1 AND tHomeGB1.GB = @GB1
				JOIN TeamStatsAverages tHomeGB2 ON tHomeGB2.UserName = @UserName AND tHomeGB2.GameDate = @GameDate AND tHomeGB2.RotNum = @RotNum +1 AND tHomeGB2.GB = @GB2
				JOIN TeamStatsAverages tHomeGB3 ON tHomeGB3.UserName = @UserName AND tHomeGB3.GameDate = @GameDate AND tHomeGB3.RotNum = @RotNum +1 AND tHomeGB3.GB = @GB3
				JOIN TeamStatsAverages tHomeGB10 ON tHomeGB10.UserName = @UserName AND tHomeGB10.GameDate = @GameDate AND tHomeGB10.RotNum = @RotNum +1 AND tHomeGB10.GB = @varTeamAvgGB

					Where tAwayGB1.UserName = @UserName AND tAwayGB1.GameDate = @GameDate AND tAwayGB1.RotNum = @RotNum	
						AND tAwayGB1.GB = @GB1

			) tm

		) tm2
		Set @RotNum = @RotNum + 1
	--	
	--return
	END	--  #3C - Generate TodaysMatchups
END	--  #3C -  TodaysMatchups

Select * from TodaysMatchups Where UserName = @UserName AND LeagueName = @LeagueName AND GameDate = @GameDate

-- select *   FROM [Rotation]   where gamedate >= '1/17/2020'
	return

/* for Debugging Display
						, '******' as '<===>'
						, b.ShotsMadeUsRegPt1
			
						, bL5.Q4Last1MinUsPt1, r.TotalLine, r.SideLine, r.TotalLineTeam as TLteam, b.ScoreRegUs as TeamScReg,  @BxScLinePct as CurPct
						, Cast(( 1 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1) * @BxScLinePct) ) as float) as CurvePctFac
						, cast((  Cast( b.ScoreRegUs as float)   /   b.ScoreOTUs   ) as float) as otFac, b.ScoreRegUs, b.ScoreOTUs


*/