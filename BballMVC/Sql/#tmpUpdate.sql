  Use [00TTI_LeagueScores]


begin 
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
			, @Venue varchar(4)
			, @SubSeason VarChar(10) 
			--, @TeamAway varchar(8) 
			--, @TeamHome varchar(8)
			--, @RotNum int
--			, @ixVenue as int
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

	Set @Team = 'ATL';

END
  ----------------------------------------------------------------------------------------------------------
Begin -- Update
  update  bss
	 set bss.HomeShotsScoredPt1 = avgs.ScoredPt1
		, bss.HomeShotsScoredPt2 = avgs.ScoredPt2
		, bss.HomeShotsScoredPt3 = avgs.ScoredPt3
		, bss.HomeShotsAdjustedScoredPt1 = avgs.ScoredPt1
		, bss.HomeShotsAdjustedScoredPt2 = avgs.ScoredPt2
		, bss.HomeShotsAdjustedScoredPt3 = avgs.ScoredPt3
		
		, bss.HomeShotsAllowedPt1 = avgs.AllowedPt1
		, bss.HomeShotsAllowedPt2 = avgs.AllowedPt2
		, bss.HomeShotsAllowedPt3 = avgs.AllowedPt3
		, bss.HomeShotsAdjustedAllowedPt1 = avgs.AllowedPt1
		, bss.HomeShotsAdjustedAllowedPt2 = avgs.AllowedPt2
		, bss.HomeShotsAdjustedAllowedPt3 = avgs.AllowedPt3
	FROM BoxScoresSeeds bss
	JOIN ( 
	---------------------------------------------------------------------------------------------
						Select TOP (@varTeamAvgGB)	@Team as Team

, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS ScoredPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS ScoredPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS ScoredPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt3

						From BoxScores b
							JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Left Join TeamStrength ts ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  b.Venue = @Home
							AND  b.Season = @PrevSeason
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC
----------------------------------------------------------------------------
				) avgs
	       ON avgs.Team = bss.Team 
				AND bss.UserName = @UserName
				AND bss.LeagueName = @LeagueName
				AND bss.Season = @Season
END

	Select * from BoxScoresSeeds Where team = 'ATL' order by Team