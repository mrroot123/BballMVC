use [00TTI_LeagueScores]

	declare @Today date = convert(Date, Getdate());
		
	--exec uspCalcTodaysMatchups  @UserName, @LeagueName, @GameDate, @Display
	exec uspCalcTodaysMatchups  'Test', 'WNBA', @Today, 1

	