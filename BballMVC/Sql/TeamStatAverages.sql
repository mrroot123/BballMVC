
use [00TTI_LeagueScores]
--select dbo.udfOppositeVenue('away')
--Print  dbo.udfOppositeVenue('away')
--print dbo.udfGetVenueReal(1.0, -1.0, 'Hxome')

-- VARS - League Vars & Daily  Vars

/*
#1	Set User vars - GamesBack, GamesBackWeights, Curves From UserLeagueParms
#2	While GameDate <= EndDate
#3A	Set (LgAvgs,  LastMinDefaults From DailySummary), Season,
#3B	For Each MU in GameDate Rotation
			*** Generate TeamStatsAverages
			Set TeamAway, TeamHome, RotNum from Rotation
			For Each GameBack
				INSERT INTO TeamStatsAverages Away & Home
			Next GamesBack
			
		Next MU

TeamStatsAverages RowCount = #ofMUPs * 2 (Aw/Hm) * 3 (GamesBack)
		
#3C	For Each MU in GameDate Rotation
			*** Generate TodaysMatchups
			Set TeamAway, TeamHome, RotNum from Rotation

		Next MU
#3D	Set GameDate = DateAdd(day, 1, GameDate);
	Next GameDate
*/

-- Inputed Vars --
--Declare @gamesBack int;

Declare @UserName	varchar(10)	= 'Test'
		, @LeagueName varchar(8) = 'NBA'
		, @GameDate Date		= '01/07/2020'
		, @EndDate  Date		= '12/23/2019' -- 1/9/2020 - not referenced
		, @Team varchar(10)
		, @Venue varchar(4)
		, @CurveBxScPct float	= .667
		, @CurveOppPct  float	= .667

		, @Season varchar(4) = '1920'
		, @SubSeason VarChar(10) = '1-reg'

		,  @LastMinPt1 float = 0.95
		 , @LastMinPt2 float = 0.61
		 , @LastMinPt3 float = 0.21

		, @LgGamesBack int 
		, @GamesBack1 int 
		, @GamesBack2 int
		, @GamesBack3 int
		, @gamesBack int

		, @WeightGB1 float = 1.0
		, @WeightGB2 float = 1.0
		, @WeightGB3 float = 1.0

		, @Curve float = 2.0


Declare @Pt1 as float = 1.00	-- Constants Point Values as float
		, @Pt2 as float = 2.00
		, @Pt3 as float = 3.00


Select @GamesBack1 = u.GamesBack1, @GamesBack2 = u.GamesBack2, @GamesBack3 = u.GamesBack3
	From UserLeagueParms u Where u.UserName = @UserName AND u.LeagueName = @LeagueName
--	Select  @GamesBack1, @GamesBack2, @GamesBack3
Set @GamesBack1 = 1
Set @GamesBack2 = 2
Set @GamesBack3 = 3
Declare @varLgAvgGamesBack int   = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
Declare @varTeamAvgGamesBack int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')



Select TOP 1 
	@LgGamesBack = li.NumberOfTeams * @varLgAvgGamesBack
  From LeagueInfo li 
  Where li.LeagueName = @LeagueName
    AND li.StartDate <= @GameDate
  Order by li.StartDate Desc
--  select @LgGamesBack

DECLARE @GamesBackTable TABLE (GamesBack INT)
Insert into @GamesBackTable values(@GamesBack1)
Insert into @GamesBackTable values(@GamesBack2)
Insert into @GamesBackTable values(@GamesBack3)

If NOT exists(Select * From @GamesBackTable Where GamesBack = @varTeamAvgGamesBack)
	Insert into @GamesBackTable values(@varTeamAvgGamesBack)		-- 10 GB CONSTANT for Opp Avgs

--Select  * from @GamesBackTable Order By GamesBack
--return


Declare @xxxCalcedVars char(1)
		, @Curve_Pct float
		, @Curve_Factor_opp float = 2.0
		;

Set @Curve_Pct = @Curve / (@Curve + 1.0)


-- **** DAily Vars ****


			
--Calce Curve_Factor			
--	Curve_Pct = Curve / (Curve + 1.0)		
-- TmTL = (TOTAL_Line - Side_Line * VenueSign) / 2  - VenueSign = 1 Home | (-1) Away

--	' 1 + (((TmTL / ScReg) - 1) * Curve_Pct)		
--Curve 	2		
--C_Pct	0.666666667		
--TmTL	200		TmTL = (TOTAL_Line - Side_Line) / 2
--ScReg	210		
--C_Factor	0.968253968		



-- Adjustments
-- 1 - OT
-- 2 - Last Min
-- 3 - Curve Actual Score (1, 2, 3pters --> Calculated or Line)
-- 4 - Opp Tm Strength - not applied yet

 

Declare @TeamAway varchar(8) = 'ATL'
		, @TeamHome varchar(8) = 'BOS'
--		, @Venue varchar(8) = 'Home'		-- 'Away'
		, @RotNum int = 0;

Set @TeamAway  = 'ATL';  
Set @TeamHome  = 'BOS';   


--Select @LeagueName as LeagueName
--	, @GameDate as GameDate
--	, @TeamAway as TeamAway
--	, @TeamHome as TeamHome
--	, @GamesBack1 as GamesBack1
--	, @GamesBack2 as GamesBack2
--	, @GamesBack3 as GamesBack3
--	, @Curve_Pct as Curve_Pct


	SET @GamesBack = @GamesBack1;

If 1 = 1
	BEGIN
-- ************************************
-- ***   Generate League Averages   ***
-- ************************************
Declare @LgAvgShotsMadeAwayPt1 float, @LgAvgShotsMadeAwayPt2 float, @LgAvgShotsMadeAwayPt3 float
		, @LgAvgShotsMadeHomePt1 float, @LgAvgShotsMadeHomePt2 float, @LgAvgShotsMadeHomePt3 float
--		,  @OTpct float;	
		
			
--SELECT @OTpct = AVG(x.ScoreReg / x.ScoreOT) 
--	FROM (
--	SELECT TOP (@GamesBack) ScoreReg, ScoreOT
--	 FROM BoxScores b 
--		WHERE b.LeagueName = @LeagueName  
--		AND b.Venue = 'Home'  -- Constant
--		AND b.Season = @Season
--		AND b.GameDate < @GameDate
--		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
--	 Order by b.GameDate desc
--	) x
--Print (@OTpct)

-- kdtodo - Get LgAvgs from DailySummary table
SELECT 
	  @LgAvgShotsMadeAwayPt1 = AVG(x.ShotsMadeOpRegPt1)
	, @LgAvgShotsMadeAwayPt2 = AVG(x.ShotsMadeOpRegPt2)
	, @LgAvgShotsMadeAwayPt3 = AVG(x.ShotsMadeOpRegPt3) 

	, @LgAvgShotsMadeHomePt1 = AVG(x.ShotsMadeUsRegPt1)
	, @LgAvgShotsMadeHomePt2 = AVG(x.ShotsMadeUsRegPt2)
	, @LgAvgShotsMadeHomePt3 = AVG(x.ShotsMadeUsRegPt3) 
 FROM (
	SELECT TOP (@LgGamesBack) b.* 
	 FROM BoxScores b 
		WHERE b.LeagueName = @LeagueName  
		AND b.Venue = 'Home'  -- Constant
		AND b.GameDate < @GameDate
		AND b.Season = @Season
		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
		Order by b.GameDate desc
	) x

-- Select @LgAvgShotsMadeAwayPt1 , @LgAvgShotsMadeAwayPt2 , @LgAvgShotsMadeAwayPt3 	  , @LgAvgShotsMadeHomePt1 , @LgAvgShotsMadeHomePt2 , @LgAvgShotsMadeHomePt3 

END
--	  end  Generate League Averages 

		--Select Count(*) / 2 as Matchups	From Rotation r	Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate 

if 1 = 1 BEGIN -- temp if to Bypass TeamStatsAverages
	 Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate
	-- **********************************************************************************
	-- *** #3B - Rotation Loop for each Game of GameDate - Generate TeamStatsAverages ***
	-- **********************************************************************************
	Set @RotNum = 0;
	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
	-- Get Away RotNum & TeamAway
		Select Top 1 	@TeamAway = r.Team,  @RotNum = r.RotNum
			From Rotation r
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;

	-- Get  TeamHome
		Select Top 1 	@TeamHome = r.Team
			From Rotation r
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum = @RotNum + 1		-- RotNum = Away RotNum + 1
			Order by r.RotNum
		If @@ROWCOUNT = 0
		BEGIN
	--		throw 50001, 'Home Row not found', 1  
			BREAK;
		END

	--	Select @GameDate, @RotNum, @TeamAway, @TeamHome

		Set @gamesBack = 0;
		While 1 = 1		-- Loop 3 times for each GamesBack value
		BEGIN
			Select Top 1 @gamesBack = g.GamesBack
				From @GamesBackTable g
				Where g.GamesBack > @gamesBack
				Order by g.gamesBack
			If @@ROWCOUNT = 0
				BREAK;

			Declare @ixVenue as int = 0

			Set @Team  = @TeamAway
			Set @Venue = 'Away'

			While @ixVenue < 2
			BEGIN	-- Venue Loop

				INSERT INTO TeamStatsAverages		-- Each Venue
				(
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					,[GamesBack],			[StartGameDate]
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
				)
				Select @UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	,Max(Team) as Team	,max(Venue) as Venue
						,Max(GamesBack) AS GamesBack			,Min(GameDate) AS StartGameDate
						,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)
						,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)
					From ( -- aw

						Select TOP (@GamesBack)	@GamesBack as GamesBack
		
						,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
						--	 OT already Out		|				Take out Last Min										     | ' 1   + (( (TmTL             / ScReg		   ) - 1  ) * Curve_Pct)	
							, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt1
							, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt2
							, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt3

							, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt1
							, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt2
							, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt3

						From BoxScores b
							JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
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
				Set @Venue = 'Home'

			END	-- Venue Loop

 		 --*** GamesBack1 - Away
			--INSERT INTO TeamStatsAverages		-- Away
			--(
			--	 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
			--	,[GamesBack],			[StartGameDate]
			--	,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
			--	,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
			--)
			--	Select @UserName			,@LeagueName			,@GameDate	, @RotNum	,Max(aw.Team) as Team	,max(aw.Venue) as Venue
			--			,Max(GamesBack) AS GamesBack			,Min(aw.GameDate) AS StartGameDate
			--			,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)
			--			,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)
			--		From ( -- aw

			--			Select TOP (@GamesBack)	@GamesBack as GamesBack
		
			--			,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
			--			--	 OT already Out		|				Take out Last Min										     | ' 1   + (( (TmTL             / ScReg		   ) - 1  ) * Curve_Pct)	
			--				, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt1
			--				, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt2
			--				, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt3

			--				, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt1
			--				, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt2
			--				, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt3

			--			From BoxScores b
			--				JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
			--			 Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
			--			Where b.LeagueName = @LeagueName
			--				AND	b.GameDate <	 @GameDate
			--				AND	b.Team =	 @TeamAway
			--				AND  b.Venue = 'Away'
			--				AND  b.Season = @Season
			--				AND  (b.SubSeason = @SubSeason OR b.SubSeason = '1-Reg')
			--				AND  b.Exclude = 0
			--			 Order BY b.GameDate DESC
			--		) aw

 		------ *** GamesBack1 - Home
			--INSERT INTO TeamStatsAverages		-- Home
			--(
			--	 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
			--	,[GamesBack],			[StartGameDate]
			--	,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
			--	,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
			--)
			--	Select @UserName			,@LeagueName			,@GameDate	, @RotNum+1	,Max(Team) as Team	,max(Venue) as Venue
			--			,Max(GamesBack) AS GamesBack			,Min(GameDate) AS StartGameDate
			--			,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)
			--			,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)
			--		From ( -- hm

			--			Select TOP (@GamesBack)	@GamesBack as GamesBack
		
			--			,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp
			--			--	 OT already Out		|				Take out Last Min										    | ' 1   + (( (TmTL             / ScReg			  ) - 1  ) * Curve_Pct)	
			--				, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt1
			--				, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt2
			--				, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @Curve_Pct) )	AS AverageMadeUsPt3

			--				, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LastMinPt1) + @LastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt1
			--				, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LastMinPt2) + @LastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt2
			--				, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LastMinPt3) + @LastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp  ) - 1.0) * @Curve_Pct) )	AS AverageMadeOpPt3

			--			From BoxScores b
			--				JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
			--			 Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
			--			Where b.LeagueName = @LeagueName
			--				AND	b.GameDate <	 @GameDate
			--				AND	b.Team =	 @TeamHome
			--				AND  b.Venue = 'Home'
			--				AND  b.Season = @Season
			--				AND  (b.SubSeason = @SubSeason OR b.SubSeason = '1-Reg')
			--				AND  b.Exclude = 0
			--			 Order BY b.GameDate DESC
			--		) hm

		END	-- GamesBack loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- Generate TeamStatsAverages - Rotation Loop	

	--Select * FROM TeamStatsAverages		-- Display Results
	-- where GameDate = @GameDate
	--Order by GameDate, RotNum, GamesBack

	--RETURN
END -- temp bypass

	--Select * FROM TeamStatsAverages		-- Display Results
	--	Where Team = 'PHI' or Team = 'DET'
	--Order by GameDate, RotNum, GamesBack


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

	-- ********************************************************************************
	-- *** #3C -  Rotation Loop for each Game of GameDate - Generate TodaysMatchups ***
	-- ********************************************************************************
	Set @RotNum = 0;

	While @RotNum < 1000		-- #3C - Generate TodaysMatchups
	BEGIN
		-- [UserName]  ,[LeagueName]       ,[GameDate]      ,[RotNum]  ,[GamesBack]

		Select Top 1 
				@RotNum = r.RotNum, 	@TeamAway = r.Team,  @TeamHome = rh.Team
			-- '===>',	 r.RotNum, 	 r.Team, rh.Team
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeageName since Rotnum using Greater Than to make unique
			Order by r.RotNum
			
		If @@ROWCOUNT = 0
			BREAK;
--	/-*	
		Select 'L439' as L439, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tm.TeamAway, tm.TeamHome

			, (tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 )  as CalcAwayGB1
			, (tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 )  as CalcAwayGB2
			, (tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 )  as CalcAwayGB3
			, (
				((tm.CalcAwayGB1Pt1 + tm.CalcAwayGB1Pt2 + tm.CalcAwayGB1Pt3 ) * @WeightGB1) 
			 + ((tm.CalcAwayGB2Pt1 + tm.CalcAwayGB2Pt2 + tm.CalcAwayGB2Pt3 ) * @WeightGB2)
			 + ((tm.CalcAwayGB3Pt1 + tm.CalcAwayGB3Pt2 + tm.CalcAwayGB3Pt3 ) * @WeightGB3)
			 	) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcAway

			, (tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 )  as CalcHomeGB1
			, (tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 )  as CalcHomeGB2
			, (tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 )  as CalcHomeGB3
			, (
				((tm.CalcHomeGB1Pt1 + tm.CalcHomeGB1Pt2 + tm.CalcHomeGB1Pt3 ) * @WeightGB1) 
			 + ((tm.CalcHomeGB2Pt1 + tm.CalcHomeGB2Pt2 + tm.CalcHomeGB2Pt3 ) * @WeightGB2)
			 + ((tm.CalcHomeGB3Pt1 + tm.CalcHomeGB3Pt2 + tm.CalcHomeGB3Pt3 ) * @WeightGB3)
			 	) / (@WeightGB1 + @WeightGB2 + @WeightGB3)	as CalcHome
		  From (
--*/
		  --    ,[LeagueName]      ,[GameDate]      ,[Season]      ,[SubSeason]      ,[TeamAway]      ,[TeamHome]      ,[RotNum]      ,[Time]
			Select 'L461' as L461, @UserName as UserName, @GameDate as GameDate, @LeagueName as LaegueName, @RotNum as RotNum, tAwayGB1.Team as TeamAway, tHomeGB1.Team as TeamHome

			-- = Pt * Pts  * ((CHAHm/LgAvgHm)+ AdjFac) / (AdjFac+1)
					, @Pt1 * tAwayGB1.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB1Pt1
					, @Pt2 * tAwayGB1.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB1Pt2
					, @Pt3 * tAwayGB1.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB1Pt3

					, @Pt1 * tAwayGB2.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB2Pt1
					, @Pt2 * tAwayGB2.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB2Pt2
					, @Pt3 * tAwayGB2.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB2Pt3

					, @Pt1 * tAwayGB3.AverageMadeUsPt1 * ((  tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB3Pt1
					, @Pt2 * tAwayGB3.AverageMadeUsPt2 * ((  tHomeGB10.AverageMadeOpPt2 / @LgAvgShotsMadeHomePt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB3Pt2
					, @Pt3 * tAwayGB3.AverageMadeUsPt3 * ((  tHomeGB10.AverageMadeOpPt3 / @LgAvgShotsMadeHomePt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcAwayGB3Pt3

					, @Pt1 * tHomeGB1.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB1Pt1
					, @Pt2 * tHomeGB1.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB1Pt2
					, @Pt3 * tHomeGB1.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB1Pt3

					, @Pt1 * tHomeGB2.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB2Pt1
					, @Pt2 * tHomeGB2.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB2Pt2
					, @Pt3 * tHomeGB2.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB2Pt3

					, @Pt1 * tHomeGB3.AverageMadeUsPt1 * ((  tAwayGB10.AverageMadeOpPt1 / @LgAvgShotsMadeAwayPt1) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB3Pt1
					, @Pt2 * tHomeGB3.AverageMadeUsPt2 * ((  tAwayGB10.AverageMadeOpPt2 / @LgAvgShotsMadeAwayPt2) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB3Pt2
					, @Pt3 * tHomeGB3.AverageMadeUsPt3 * ((  tAwayGB10.AverageMadeOpPt3 / @LgAvgShotsMadeAwayPt3) + @Curve_Factor_opp ) / ( @Curve_Factor_opp + 1.0 ) as CalcHomeGB3Pt3

					, tAwayGB1.AverageMadeUsPt1 as AverageMadeUsPt1
					, tHomeGB1.AverageMadeUsPt1 as AverageMadeOpPt1 
					, @LgAvgShotsMadeHomePt1 as LgAvgShotsMadeHomePt1
			From TeamStatsAverages tAwayGB1
			JOIN TeamStatsAverages tAwayGB2 ON tAwayGB2.UserName = @UserName AND tAwayGB2.GameDate = @GameDate AND tAwayGB2.RotNum = @RotNum    AND tAwayGB2.GamesBack = @GamesBack2
			JOIN TeamStatsAverages tAwayGB3 ON tAwayGB3.UserName = @UserName AND tAwayGB3.GameDate = @GameDate AND tAwayGB3.RotNum = @RotNum    AND tAwayGB3.GamesBack = @GamesBack3
			JOIN TeamStatsAverages tAwayGB10 ON tAwayGB10.UserName = @UserName AND tAwayGB10.GameDate = @GameDate AND tAwayGB10.RotNum = @RotNum    AND tAwayGB10.GamesBack = @varTeamAvgGamesBack

			JOIN TeamStatsAverages tHomeGB1 ON tHomeGB1.UserName = @UserName AND tHomeGB1.GameDate = @GameDate AND tHomeGB1.RotNum = @RotNum +1 AND tHomeGB1.GamesBack = @GamesBack1
			JOIN TeamStatsAverages tHomeGB2 ON tHomeGB2.UserName = @UserName AND tHomeGB2.GameDate = @GameDate AND tHomeGB2.RotNum = @RotNum +1 AND tHomeGB2.GamesBack = @GamesBack2
			JOIN TeamStatsAverages tHomeGB3 ON tHomeGB3.UserName = @UserName AND tHomeGB3.GameDate = @GameDate AND tHomeGB3.RotNum = @RotNum +1 AND tHomeGB3.GamesBack = @GamesBack3
			JOIN TeamStatsAverages tHomeGB10 ON tHomeGB10.UserName = @UserName AND tHomeGB10.GameDate = @GameDate AND tHomeGB10.RotNum = @RotNum +1 AND tHomeGB10.GamesBack = @varTeamAvgGamesBack

				Where tAwayGB1.UserName = @UserName AND tAwayGB1.GameDate = @GameDate AND tAwayGB1.RotNum = @RotNum	
					AND tAwayGB1.GamesBack = @GamesBack1
		) tm
		Set @RotNum = @RotNum + 1
	--	return
	END	--  #3C - Generate TodaysMatchups

	return

/* for Debugging Display
						, '******' as '<===>'
						, b.ShotsMadeUsRegPt1
			
						, bL5.Q4Last1MinUsPt1, r.TotalLine, r.SideLine, r.TotalLineTeam as TLteam, b.ScoreRegUs as TeamScReg,  @Curve_Pct as CurPct
						, Cast(( 1 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1) * @Curve_Pct) ) as float) as CurvePctFac
						, cast((  Cast( b.ScoreRegUs as float)   /   b.ScoreOTUs   ) as float) as otFac, b.ScoreRegUs, b.ScoreOTUs


*/