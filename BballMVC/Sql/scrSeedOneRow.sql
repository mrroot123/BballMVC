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

Declare @LeagueName varchar(10) = 'NBA'
		, @Season varchar(10) = '1819'
--		, @Season varchar(10) = '1920'

		, @SubSeason varchar(10) = '1-Reg'
		, @Team varchar(4) = 'ATL'
		, @Venue varchar(4) = 'Home'
		, @RotNum int = 1
		, @LoadTS date = GetDate()
		, @Seeded char(10) = 'Seeded'
;
Declare @varLgAvgGamesBack int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
Declare @varTeamSeedGames int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamSeedGames')



DECLARE @TeamTable TABLE (Team varchar(10))

Insert into @TeamTable 
SELECT Distinct     TeamNameInDatabase
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where LeagueName = @LeagueName and TeamSource = @LeagueName and EndDate is null

--Select Distinct Team
--	From BoxScores
--	Where LeagueName = @leagueName AND Season = @Season
--	Order By Team

IF (Select count(*) as Teams From @TeamTable) <> (Select [NumberOfTeams] FROM [LeagueInfo] l WHERE  l.LeagueName = @LeagueName)
BEGIN
	Select * from @TeamTable
	-- THROW 51000, 'Incorrect Number of Teams in @TeamTable', 1; 
	Select  'Incorrect Number of Teams in @TeamTable' as ErrorMsg
	declare @xxx int = 1 / 0
END


Declare @LoopLimit int = @varLgAvgGamesBack * (Select Count(*) From @TeamTable)
--select @LoopLimit; return;

Declare @LgAvg as float = 218 -- kd calc

DECLARE @VenueTable TABLE (Venue varchar(10))
Insert into @VenueTable values('Away')
Insert into @VenueTable values('Home')
-- Select * From @VenueTable


		Declare @SeasonStartDate Date
		Declare @savSeasonStartDate Date = ( SELECT min([StartDate])
														  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
														  where LeagueName = @leagueName   AND Season = @Season
														)

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
--if @ctrLoop = 1
				INSERT INTO BoxScores
					Select 0 as Exclude, @LeagueName as LeagueName, @SeasonStartDate as GameDate, @RotNum as RotNum, @Team, '', @Venue, '', @Season, @SubSeason
							, 0  -- (b1.MinutesPlayed) as MinutesPlayed
							, 0  -- (b1.OtPeriods) as OtPeriods
							, @LgAvg		  -- (b1.ScoreReg) as ScoreReg
							, @LgAvg + 2  -- (b1.ScoreOT) as ScoreOT
							, @LgAvg / 2  -- (b1.ScoreRegUs) as ScoreRegUs
							, @LgAvg / 2  -- (b1.ScoreRegOp) as ScoreRegOp
							, @LgAvg / 2  -- (b1.ScoreOTUs) as ScoreOTUs
							, @LgAvg / 2  -- (b1.ScoreOTOp) as ScoreOTOp
							, @LgAvg / 8  -- (b1.ScoreQ1Us) as ScoreQ1Us
							, @LgAvg / 8  -- (b1.ScoreQ1Op) as ScoreQ1Op
							, @LgAvg / 8  -- (b1.ScoreQ2Us) as ScoreQ2Us
							, @LgAvg / 8  -- (b1.ScoreQ2Op) as ScoreQ2Op
							, @LgAvg / 8  -- (b1.ScoreQ3Us) as ScoreQ3Us
							, @LgAvg / 8  -- (b1.ScoreQ3Op) as ScoreQ3Op
							, @LgAvg / 8  -- (b1.ScoreQ4Us) as ScoreQ4Us
							, @LgAvg / 8  -- (b1.ScoreQ4Op) as ScoreQ4Op
							, @LgAvg / 10   -- (b1.ShotsActualMadeUsPt1) as ShotsActualMadeUsPt1
							, @LgAvg / 7  -- (b1.ShotsActualMadeUsPt2) as ShotsActualMadeUsPt2
							, @LgAvg / 30  -- (b1.ShotsActualMadeUsPt3) as ShotsActualMadeUsPt3
							, @LgAvg / 10  -- (b1.ShotsActualMadeOpPt1) as ShotsActualMadeOpPt1
							, @LgAvg / 7  -- (b1.ShotsActualMadeOpPt2) as ShotsActualMadeOpPt2
							, @LgAvg / 30 -- (b1.ShotsActualMadeOpPt3) as ShotsActualMadeOpPt3
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt1) as ShotsActualAttemptedUsPt1
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt2) as ShotsActualAttemptedUsPt2
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt3) as ShotsActualAttemptedUsPt3
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt1) as ShotsActualAttemptedOpPt1
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt2) as ShotsActualAttemptedOpPt2
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt3) as ShotsActualAttemptedOpPt3
							, @LgAvg / 10   -- (b1.ShotsActualMadeUsPt1) as ShotsActualMadeUsPt1
							, @LgAvg / 7  -- (b1.ShotsActualMadeUsPt2) as ShotsActualMadeUsPt2
							, @LgAvg / 30  -- (b1.ShotsActualMadeUsPt3) as ShotsActualMadeUsPt3
							, @LgAvg / 10  -- (b1.ShotsActualMadeOpPt1) as ShotsActualMadeOpPt1
							, @LgAvg / 7  -- (b1.ShotsActualMadeOpPt2) as ShotsActualMadeOpPt2
							, @LgAvg / 30 -- (b1.ShotsActualMadeOpPt3) as ShotsActualMadeOpPt3
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt1) as ShotsActualAttemptedUsPt1
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt2) as ShotsActualAttemptedUsPt2
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedUsPt3) as ShotsActualAttemptedUsPt3
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt1) as ShotsActualAttemptedOpPt1
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt2) as ShotsActualAttemptedOpPt2
							, @LgAvg / 15  -- (b1.ShotsActualAttemptedOpPt3) as ShotsActualAttemptedOpPt3
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, 10  -- (b1.TurnOversUs) as TurnOversUs
							, @Seeded
							, @LoadTS
							, 0

		
			END	-- Venue Loop
--return			
		END	-- Times loop


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
