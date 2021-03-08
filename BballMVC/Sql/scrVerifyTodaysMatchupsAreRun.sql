
use [00TTI_LeagueScores]

/*
	Check if any TodaysMatchups were not run
	Verify every BoxScores row has matching TodaysMatchups row for Season
*/
	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()

			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '2021'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
	;

 Select  Distinct b.GameDate
  FROM boxscores b
  Left Join TodaysMatchups tm ON tm.LeagueName = b.LeagueName AND tm.GameDate = b.GameDate AND tm.RotNum = b.RotNum
  where b.LeagueName = @LeagueName 
  AND b.Venue = 'Away' 
  AND b.Season = @Season  and tm.GameDate is Null
  order by b.GameDate desc