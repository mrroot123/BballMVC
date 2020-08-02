Use [00TTI_LeagueScores]

/*
Seed Strategy - For Current Season only - Set @LeagueName & @Season (ex NBA: 1819, WNBA: 17)

	BoxScoresSeeds Table - was LastSeasonHistory
		Gen Table Procedure
			Create @TeamTable by League - already done below
				For Each Team in @TeamTable
					For Each Venue
						Shot Calc - Top @GamesBack 
							ShotsMadePt# = Avg ShotsMadeUsRegPt1, 2, 3 
							ShotsAllowedPt# = Avg ShotsMadeOpRegPt1, 2, 3 
							ShotsAdjusted set to Shots above
						Where LG, GameDate <= LastSeason 2-Reg End
						Order by GameDate Desc

	One Time Seed
		BoxscoresLast5Min - NOT NEEDED - will be NULL for TeamStatAverages

	Before Start of League Season Seed Rows
		Boxscores
			Get Prev Season TeamAvgs (BG10?) + This Season Teams Adjustments
			varTeamSeedGames - Games per Team to Seed - Loop each Team by PreSeason StartDate - 1 then preDay on loop
		
		Rotation
			RotNum - Sort team Alphabetically and assign RotNum starting at 1 as ATL away, 2 ATL Home and so on
				 r.TotalLineTeam seeded w b.ScoreRegUs  
RotationID
LeagueName
GameDate		Lg StartDate - 1. Continue w prev Date Games Back times
RotNum		1 as ATL away, 2 ATL Home, 3 BOS away and so on
Venue			A/H
Team			Team
Opp			Team
GameTime
TV
SideLine
TotalLine
TotalLineTeam	- seeded w b.ScoreRegUs  
TotalLineOpp
OpenTotalLine
BoxScoreSource	- 'Seeded'
BoxScoreUrl
CreateDate	GameDate
UpdateDate	GameDate

		TeamStreagth - NO SEED Necessary
			Calc 1 TeamStrength Row for each Team, each Venue based on Boxscores Seeded rows

		DailySummary

*/
/*
	Loop Teams
		Loop Venues
*/

BEGIN -- 1) Declares
	Declare @LeagueName varchar(10) = 'WNBA'
	--		, @Season varchar(10) = '1819'
			, @Season varchar(10) = '20'

			, @SubSeason varchar(10) = '1-Reg'
			, @Team varchar(4) = 'ATL'
			, @Venue varchar(4) = 'Home'
			, @RotNum int = 0
			, @LoadTS date = GetDate()
			, @Seeded char(10) = 'Seeded'
	;
	Declare @varLgAvgGamesBack int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
	Declare @varTeamSeedGames int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamSeedGames')

	Declare @MinsPerGame int = (Select Periods * MinutesPerPeriod FROM [LeagueInfo] l WHERE  l.LeagueName = @LeagueName)
	--Select @MinsPerGame; return

	DECLARE @TeamTable TABLE (Team varchar(10))
END -- 1) Declares

BEGIN	-- 2) Set Table Vars
	Insert into @TeamTable 
	SELECT Distinct     TeamNameInDatabase
	  FROM [00TTI_LeagueScores].[dbo].[Team]
	  where LeagueName = @LeagueName 
	  --and TeamSource = @LeagueName
		and EndDate is null
		--Select * From @TeamTable; 	Select Count(*) as TeamsInTeamTable From @TeamTable; return

	--Select Distinct Team	From BoxScores	Where LeagueName = @leagueName AND Season = @Season Order By Team

	IF (Select count(*) as Teams From @TeamTable) <> (Select [NumberOfTeams] FROM [LeagueInfo] l WHERE  l.LeagueName = @LeagueName)
	BEGIN
		Select * from @TeamTable
		Select count(*) as Teams From @TeamTable
		Select [NumberOfTeams] as 'LgInfo.Teams' FROM [LeagueInfo] l WHERE  l.LeagueName = @LeagueName;return

		-- THROW 51000, 'Incorrect Number of Teams in @TeamTable', 1; 
		Select  'Incorrect Number of Teams in @TeamTable' as ErrorMsg
		declare @xxx int = 1 / 0
	END

	Declare @LoopLimit int = @varLgAvgGamesBack * (Select Count(*) From @TeamTable)
	--select @LoopLimit; return;

	DECLARE @VenueTable TABLE (Venue varchar(10))
	Insert into @VenueTable values('Away')
	Insert into @VenueTable values('Home')
	 --Select * From @VenueTable; return

 		Declare @SeasonStartDate Date
		Declare @savSeasonStartDate Date = ( SELECT min([StartDate])
														  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
														  where LeagueName = @leagueName   AND Season = @Season
														)
END	-- 2) Set Table Vars

BEGIN -- 3) Delete This Years SEEDS if they exist
 Select * From BoxScores Where LeagueName  = @LeagueName AND Season = @Season AND Source = @Seeded
  return
END -- 3)

BEGIN -- 4) Insert Seeds
	Select '====>', @LeagueName, @Season, @SeasonStartDate


		declare @ctrLoop int = 0;
		While 1 = 1		-- Loop 300 times
		BEGIN	-- Times Loop
			Set @ctrLoop = @ctrLoop + 1;
			If @ctrLoop > @LoopLimit
				BREAK;


			Set @Venue = '';
			While 1 = 1		-- Loop for each Venue value
			BEGIN	-- Venue Loop
				Select Top 1 @Venue = Venue
					From @VenueTable 
					Where Venue > @Venue
					Order by Venue
				If @@ROWCOUNT = 0
					BREAK;

				Set @SeasonStartDate = @savSeasonStartDate;
				Set @RotNum = @RotNum + 1;

					Set @SeasonStartDate = DATEADD(D, -1, @SeasonStartDate)

Select '====>', @Team, @Venue, @SeasonStartDate

--if @ctrLoop = 1
-- /*
	INSERT INTO BoxScores 
	(	Exclude
	-- 1/7
		, LeagueName, GameDate, RotNum, Team, Opp, Venue, GameTime
	-- 2/5
		, Season, SubSeason, SubSeasonPeriod, MinutesPlayed, OtPeriods
	-- 3/6
		, ScoreReg, ScoreOT, ScoreRegUs, ScoreRegOp, ScoreOTUs, ScoreOTOp
	-- 4/8
		, ScoreQ1Us, ScoreQ1Op, ScoreQ2Us, ScoreQ2Op, ScoreQ3Us, ScoreQ3Op, ScoreQ4Us, ScoreQ4Op
	-- 5/3
		, ShotsActualMadeUsPt1, ShotsActualMadeUsPt2, ShotsActualMadeUsPt3
	-- 6/3
		, ShotsActualMadeOpPt1, ShotsActualMadeOpPt2, ShotsActualMadeOpPt3
	-- 7/3
		, ShotsActualAttemptedUsPt1, ShotsActualAttemptedUsPt2, ShotsActualAttemptedUsPt3
	-- 8/3
		, ShotsActualAttemptedOpPt1, ShotsActualAttemptedOpPt2, ShotsActualAttemptedOpPt3
	-- 9/6
		, ShotsMadeUsRegPt1, ShotsMadeUsRegPt2, ShotsMadeUsRegPt3, ShotsMadeOpRegPt1, ShotsMadeOpRegPt2, ShotsMadeOpRegPt3
	-- 10/3
		, ShotsAttemptedUsRegPt1, ShotsAttemptedUsRegPt2, ShotsAttemptedUsRegPt3
	-- 11/3
		, ShotsAttemptedOpRegPt1, ShotsAttemptedOpRegPt2, ShotsAttemptedOpRegPt3
	-- 12/6
		, TurnOversUs, TurnOversOp, OffRBUs, OffRBOp, AssistsUs, AssistsOp
	-- 13/4
		, Pace, Source, LoadDate, LoadTimeSeconds
	)	--*/
Select 0 as Exclude
-- 1/7
, @LeagueName, @SeasonStartDate, @RotNum, @Team, '', @Venue, ''
-- 2/5
, @Season, @SubSeason, 0, @MinsPerGame, 0
-- 3/6
	, 220, 220, 220, 220, 220, 220
-- 4/8
	, 55, 55, 55, 55, 55, 55, 55, 55
-- 5/3 Actual Made us
	, b.ThisYearShotsMadePt1, b.ThisYearShotsMadePt2, b.ThisYearShotsMadePt3
-- 6/3 Actual Made Op
	, b.ThisYearShotsAllowedPt1, b.ThisYearShotsAllowedPt2, b.ThisYearShotsAllowedPt3
-- 7/3 Attempt Up
	, b.ThisYearShotsMadePt1*1.3 , b.ThisYearShotsMadePt2*2, b.ThisYearShotsMadePt3*3
-- 8/3 Attempt Op
	, b.ThisYearShotsAllowedPt1*1.3 , b.ThisYearShotsAllowedPt2*2, b.ThisYearShotsAllowedPt3*3
-- 9/6
	, b.ThisYearShotsMadePt1, b.ThisYearShotsMadePt2, b.ThisYearShotsMadePt3
	, b.ThisYearShotsAllowedPt1, b.ThisYearShotsAllowedPt2, b.ThisYearShotsAllowedPt3
-- 10/3 Attempt us reg
	, b.ThisYearShotsMadePt1, b.ThisYearShotsMadePt2, b.ThisYearShotsMadePt3
-- 11/3 Attempt op reg
	, b.ThisYearShotsAllowedPt1, b.ThisYearShotsAllowedPt2, b.ThisYearShotsAllowedPt3
-- 12/6
	, 13, 13, 10, 10, 22, 22
-- 13/4
	, null, @Seeded, @LoadTS, 0
	FROM BoxScoresSeeds b
	 WHERE b.LeagueName = @LeagueName AND b.Team = @Team AND b.Venue = @Venue AND b.Season = @Season
		
			END	-- Venue Loop
 return			
		END	-- Teams loop
END -- 4)

Select * From BoxScores Where LeagueName  = @LeagueName AND Season = @Season AND Source = @Seeded

return




BEGIN -- commented
	Select --@SeasonStartDate = 
	DateAdd(d, -1, Min(GameDate)) From Boxscores

	INSERT INTO BoxScoresLast5Min (
		[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Opp]
      ,[Venue]
      ,[Q4Last5MinScore]
      ,[Q4Last1MinScore]
      ,[Q4Score]
      ,[Q4Last1MinScoreUs]
      ,[Q4Last1MinScoreOp]
      ,[Q4Last1MinWinningTeam]
      ,[Q4Last1MinUsPt1]
      ,[Q4Last1MinUsPt2]
      ,[Q4Last1MinUsPt3]
      ,[Q4Last1MinOpPt1]
      ,[Q4Last1MinOpPt2]
      ,[Q4Last1MinOpPt3]
      ,[Source]
      ,[LoadDate]	
	)
	Values
	(
		@leagueName
      , @SeasonStartDate
      , 1
      , ''
      , ''
      ,'Away'
      ,0
      ,0
      ,0
      ,0
      ,0
      ,''
      ,1.0
      ,.60
      ,.20
      ,0
      ,0
      ,0
      ,@Seeded
      ,@LoadTS	
	)
					Select 0 as Exclude, @LeagueName as LeagueName, @SeasonStartDate as GameDate, @RotNum as RotNum, @Team, '', @Venue, '', @Season, @SubSeason
	INSERT INTO BoxScoresLast5Min (
		[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Opp]
      ,[Venue]
      ,[Q4Last5MinScore]
      ,[Q4Last1MinScore]
      ,[Q4Score]
      ,[Q4Last1MinScoreUs]
      ,[Q4Last1MinScoreOp]
      ,[Q4Last1MinWinningTeam]
      ,[Q4Last1MinUsPt1]
      ,[Q4Last1MinUsPt2]
      ,[Q4Last1MinUsPt3]
      ,[Q4Last1MinOpPt1]
      ,[Q4Last1MinOpPt2]
      ,[Q4Last1MinOpPt3]
      ,[Source]
      ,[LoadDate]	
	)
	Values
	(
		@leagueName
      , @SeasonStartDate
      , 2
      , ''
      , ''
      ,'Home'
      ,0
      ,0
      ,0
      ,0
      ,0
      ,''
      ,1.0
      ,.60
      ,.20
      ,0
      ,0
      ,0
      ,@Seeded
      ,@LoadTS	
	)


	print 'DONE'
END