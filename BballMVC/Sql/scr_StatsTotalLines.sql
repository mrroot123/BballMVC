use [00TTI_LeagueScores]


	Declare
			  @LeagueName varchar(10) = 'NBA'
			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '20'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
			, @GameDate date = '8/8/2020'
	;


EXEC [uspInsertTodaysMatchupsResults] 'Test', @GameDate, 'WNBA'
EXEC [uspInsertTodaysMatchupsResults] 'Test', @GameDate, 'NBA'

	Select tmr.LeagueName, tmr.Season, tmr.GameDate
		, min(tmr.GameDate) as StartDate, max(tmr.GameDate) as EndDate, count(*) as Games
		, Round(avg( tmr.OurTotalLine),1) as 'Our TL'
		, Round(avg( tmr.TotalLine),1) as TL
		, Round(avg(  b.ScoreOT),1) as FinalSc
	  From TodaysMatchupsResults tmr
	  Join BoxScores b on b.GameDate = tmr.GameDate AND b.RotNum = tmr.RotNum
	   Where tmr.GameDate > '7/24/2020'
		-- tmr.Season = @Season
		Group by tmr.LeagueName, tmr.Season, tmr.GameDate
		Order by tmr.LeagueName, tmr.Season, tmr.GameDate