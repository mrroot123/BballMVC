Use [00TTI_LeagueScores]


/*
Loop Seasons
	Loop Teams
		Loop Venues
*/

Declare @leagueName varchar(10) = 'NBA'
		, @Season varchar(10) = '1819'
		, @SubSeason varchar(10) = '1-Reg'
		, @Team varchar(4)
		, @Venue varchar(4)
		, @RotNum int
		, @LoadDate date = GetDate()
;
Declare @varLgAvgGamesBack int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')
Declare @varTeamSeedGames int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamSeedGames')

DECLARE @SeasonTable TABLE (Season varchar(10))
Insert into @SeasonTable values('1819')
Insert into @SeasonTable values('1920')
--Select * From @SeasonTable

DECLARE @TeamTable TABLE (Team varchar(10))

Insert into @TeamTable 
Select Distinct Team
	From BoxScores
	Where LeagueName = @leagueName AND Season = @Season
	Order By Team
	kdtodo redo query - use enddate is null
--Select * From @TeamTable order By team


DECLARE @VenueTable TABLE (Venue varchar(10))
Insert into @VenueTable values('Away')
Insert into @VenueTable values('Home')
Select * From @VenueTable

	Set @Season = '';
	While 1 = 1		-- Loop for each Season value
	BEGIN		-- Season Loop
		Select Top 1 @Season = Season
			From @SeasonTable 
			Where Season > @Season
			Order by Season
		If @@ROWCOUNT = 0
			BREAK;

		Declare @SeasonStartDate Date
		Declare @savSeasonStartDate Date = ( SELECT min([StartDate])
														  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
														  where LeagueName = @leagueName   AND Season = @Season
														)
		
		-- (Select Min(b2.GameDate)  From BoxScores b2
			--	Where b2.LeagueName = @leagueName AND b2.Season = @Season AND b2.SubSeason = @SubSeason);

		Set @RotNum = 0;
		Set @Team = '';
		While 1 = 1		-- Loop for each Team value
		BEGIN
			Select Top 1 @Team = Team
				From @TeamTable 
				Where Team > @Team
				Order by Team
			If @@ROWCOUNT = 0
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

				Declare @ctrLoop int = 0;
				WHILE @ctrLoop < @varTeamSeedGames
				BEGIN		-- Loop 20 times per Team / Venue
					Set @ctrLoop = @ctrLoop + 1
					Set @SeasonStartDate = DATEADD(D, -1, @SeasonStartDate)
--if @ctrLoop = 1
				INSERT INTO BoxScores
					Select 0 as Exclude, @LeagueName as LeagueName, @SeasonStartDate as GameDate, @RotNum as RotNum, @Team, '', @Venue, '', @Season, @SubSeason
							, Avg(b1.MinutesPlayed) as MinutesPlayed
							, Avg(b1.OtPeriods) as OtPeriods
							, Avg(b1.ScoreReg) as ScoreReg
							, Avg(b1.ScoreOT) as ScoreOT
							, Avg(b1.ScoreRegUs) as ScoreRegUs
							, Avg(b1.ScoreRegOp) as ScoreRegOp
							, Avg(b1.ScoreOTUs) as ScoreOTUs
							, Avg(b1.ScoreOTOp) as ScoreOTOp
							, Avg(b1.ScoreQ1Us) as ScoreQ1Us
							, Avg(b1.ScoreQ1Op) as ScoreQ1Op
							, Avg(b1.ScoreQ2Us) as ScoreQ2Us
							, Avg(b1.ScoreQ2Op) as ScoreQ2Op
							, Avg(b1.ScoreQ3Us) as ScoreQ3Us
							, Avg(b1.ScoreQ3Op) as ScoreQ3Op
							, Avg(b1.ScoreQ4Us) as ScoreQ4Us
							, Avg(b1.ScoreQ4Op) as ScoreQ4Op
							, Avg(b1.ShotsActualMadeUsPt1) as ShotsActualMadeUsPt1
							, Avg(b1.ShotsActualMadeUsPt2) as ShotsActualMadeUsPt2
							, Avg(b1.ShotsActualMadeUsPt3) as ShotsActualMadeUsPt3
							, Avg(b1.ShotsActualMadeOpPt1) as ShotsActualMadeOpPt1
							, Avg(b1.ShotsActualMadeOpPt2) as ShotsActualMadeOpPt2
							, Avg(b1.ShotsActualMadeOpPt3) as ShotsActualMadeOpPt3
							, Avg(b1.ShotsActualAttemptedUsPt1) as ShotsActualAttemptedUsPt1
							, Avg(b1.ShotsActualAttemptedUsPt2) as ShotsActualAttemptedUsPt2
							, Avg(b1.ShotsActualAttemptedUsPt3) as ShotsActualAttemptedUsPt3
							, Avg(b1.ShotsActualAttemptedOpPt1) as ShotsActualAttemptedOpPt1
							, Avg(b1.ShotsActualAttemptedOpPt2) as ShotsActualAttemptedOpPt2
							, Avg(b1.ShotsActualAttemptedOpPt3) as ShotsActualAttemptedOpPt3
							, Avg(b1.ShotsMadeUsRegPt1) as ShotsMadeUsRegPt1
							, Avg(b1.ShotsMadeUsRegPt2) as ShotsMadeUsRegPt2
							, Avg(b1.ShotsMadeUsRegPt3) as ShotsMadeUsRegPt3
							, Avg(b1.ShotsMadeOpRegPt1) as ShotsMadeOpRegPt1
							, Avg(b1.ShotsMadeOpRegPt2) as ShotsMadeOpRegPt2
							, Avg(b1.ShotsMadeOpRegPt3) as ShotsMadeOpRegPt3
							, Avg(b1.ShotsAttemptedUsRegPt1) as ShotsAttemptedUsRegPt1
							, Avg(b1.ShotsAttemptedUsRegPt2) as ShotsAttemptedUsRegPt2
							, Avg(b1.ShotsAttemptedUsRegPt3) as ShotsAttemptedUsRegPt3
							, Avg(b1.ShotsAttemptedOpRegPt1) as ShotsAttemptedOpRegPt1
							, Avg(b1.ShotsAttemptedOpRegPt2) as ShotsAttemptedOpRegPt2
							, Avg(b1.ShotsAttemptedOpRegPt3) as ShotsAttemptedOpRegPt3
							, Avg(b1.TurnOversUs) as TurnOversUs
							, Avg(b1.TurnOversOp) as TurnOversOp
							, Avg(b1.OffRBUs) as OffRBUs
							, Avg(b1.OffRBOp) as OffRBOp
							, Avg(b1.AssistsUs) as AssistsUs
							, Avg(b1.AssistsOp) as AssistsOp
							, 'Seeded'
							, @LoadDate
							, 0


					 From (
						Select TOP (@varLgAvgGamesBack) *
						  From BoxScores b
						  Where b.LeagueName = @leagueName AND b.Season = @Season AND b.SubSeason = @SubSeason
							 AND b.Team = @Team AND b.Venue = @Venue
							 AND b.GameDate >= @SeasonStartDate
							Order By b.GameDate
							) b1

				End		-- Loop 10 times per Team / Venue
					
		
			END	-- Venue Loop
--return			
		END	-- Team Loop

	END	-- Season Loop
	print 'DONE'
