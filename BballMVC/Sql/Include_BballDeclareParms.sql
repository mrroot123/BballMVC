	Declare
			  @LeagueName varchar(10) = 'NBA'
			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
			, @GameDate date = '3/6/2020'
	;
