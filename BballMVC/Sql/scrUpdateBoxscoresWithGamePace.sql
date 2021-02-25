Use [00TTI_LeagueScores]

Declare @LeagueName varchar(10) = 'NBA'
		, @GameDate Date
		, @AvgLgPace float	= 165.0
		, @TmPace float	= 165.0

If @LeagueName = 'WNBA'
	Set @AvgLgPace  = 135;




Update BoxScoresxxx
	Set Pace = (ShotsActualAttemptedUsPt2 + ShotsActualAttemptedUsPt3
