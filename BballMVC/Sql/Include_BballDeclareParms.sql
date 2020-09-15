use [00TTI_LeagueScores]

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = '8/22/2020'

			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
	;
