Use [00TTI_LeagueScores]

Declare @LeagueName varchar(4) = 'NBA', @Season varchar(4) = '1920', @UserName varchar(25) = 'Test'

	Declare @Pt1 as float = 1.00	-- Constants Point Values as float
			, @Pt2 as float = 2.00
			--, @Pt3 as float = 3.00
			--, @Over  as char(8) = 'Over'
			--, @Under as char(8) = 'Under'
			, @Away as char(4) = 'Away'
			, @Home as char(4) = 'Home'
			, @REG_1 as char(5) = '1-Reg'

	-- 3) Parms
	Declare
			  @Team varchar(10)
			, @SubSeason VarChar(10) 
			--, @TeamAway varchar(8) 
			--, @TeamHome varchar(8)
			--, @RotNum int
	;

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

	Declare @PrevSeason varchar(4) = (Select top 1 Season
												  FROM SeasonInfo si
												  Where si.LeagueName = @LeagueName and si.Season < @Season
												  order by si.Season Desc
												 )
	Declare @GameDate Date = (   Select TOP 1 EndDate			
												 FROM [00TTI_LeagueScores].[dbo].[SeasonInfo] si			
											  where LeagueName = @LeagueName		
												AND si.Season =	@PrevSeason	
												and si.SubSeason < '2'		
											  order by StartDate desc			
									)

	-- UserLeagueParms		
	Declare @BxScLinePct float, @BxScTmStrPct float

	Select @BxScLinePct = BxScLinePct, @BxScTmStrPct = BxScTmStrPct 
		From UserLeagueParms Where UserName = @UserName AND LeagueName = @LeagueName

	Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')

	Select @LeagueName as League, @Season as Season, @PrevSeason as PrevSeason, @GameDate as GameDate
			, @BxScLinePct as BxScLinePct, @BxScTmStrPct as BxScTmStrPct,  @varTeamAvgGB as  varTeamAvgGB 


	Declare  @TeamTable TABLE (Team varchar(4));
	Insert Into @TeamTable (Team)
		SELECT  distinct  [TeamNameInDatabase]
		  FROM [00TTI_LeagueScores].[dbo].[Team]
		  where enddate is null and LeagueName = @LeagueName
		  Order By [TeamNameInDatabase]
-- Select * from @TeamTable

	Declare @Today DateTime = GetDate();

-- Loop for each Team in League

	Set @Team = '';
	While @Team < 'C'	-- LOOP
	BEGIN
	-- Get Away RotNum & TeamAway
		Select Top 1 	@Team = tt.Team
			From @TeamTable tt
			Where tt.Team > @Team
			Order by tt.Team
		
						Select TOP 3	bsAw.GameDate, bsAw.Team
							, bsAw.ShotsMadeUsRegPt1 as AwayShotsMadeUsRegPt1
							, bsAw.ShotsMadeUsRegPt2 as AwayShotsMadeUsRegPt2
							, bsAw.ShotsMadeUsRegPt3 as AwayShotsMadeUsRegPt3

						From BoxScores bsAw
							JOIN Rotation r ON r.GameDate = bsAw.GameDate AND r.RotNum = bsAw.RotNum
							Left Join TeamStrength ts ON ts.GameDate = bsAw.GameDate  AND  ts.LeagueName = bsAw.LeagueName  AND  ts.Team = bsAw.Opp
							Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = bsAw.GameDate AND  bL5.RotNum = bsAw.RotNum
		
						Where bsAw.LeagueName = @LeagueName
							AND	bsAw.GameDate <	 @GameDate
							AND	bsAw.Team =	@Team
							AND  bsAw.Venue = @Away
							AND  bsAw.Season = @PrevSeason
							AND  (bsAw.SubSeason = @SubSeason OR bsAw.SubSeason = @REG_1)	--  '1-Reg'
							AND  bsAw.Exclude = 0
							Order BY bsAw.GameDate DESC


END


