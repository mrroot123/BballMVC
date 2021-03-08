
use [00TTI_LeagueScores]

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()

			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'Both'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @GB3 int	= 7
			, @ixVenue as int
			, @GameTime varchar(5)
	;
-- Query Last 7 Boxscores by Team
 Select Top (@GB3) 
 tm.TeamAway, tm.TeamHome, tm.TotalLine
	, Round(tm.OurTotalLine, 1) as OurTotalLine
	, Round(tmr.LineDiffResultReg, 1) as LineDiffResultReg
	, Round(ts.TeamStrength, 1) as TeamStrength
	,
     @Team ,b.GameDate
      ,b.RotNum
      ,b.Opp
      ,b.Venue
      ,b.OtPeriods
      ,b.ScoreReg
      ,b.ScoreOT
      ,b.ScoreRegUs
      ,b.ScoreRegOp
	,b.*
  FROM BoxScores b
  Left Join TeamStrength   ts ON ts.LeagueName = b.LeagueName AND ts.GameDate = b.GameDate AND ts.Team = b.Team
  Left Join TodaysMatchups tm ON tm.LeagueName = b.LeagueName AND tm.GameDate = b.GameDate AND (tm.TeamAway = b.Team or tm.TeamHome = b.Team)
  Left Join TodaysMatchupsResults tmr ON tmr.LeagueName = b.LeagueName AND tmr.GameDate = b.GameDate AND (tmr.TeamAway = b.Team or tmr.TeamHome = b.Team)
  Where b.LeagueName = @LeagueName AND b.GameDate < @GameDate AND b.Team = @Team
	AND (b.Venue = @Venue or @Venue = 'Both')
	AND b.Exclude = 0
  order by b.GameDate desc

  Select top 1 *
   from TeamStatsAverages tsa
	Where tsa.LeagueName = @LeagueName and tsa.GameDate < @GameDate and tsa.Team = @Team AND tsa.GB = @GB3
	 order by tsa.GameDate Desc