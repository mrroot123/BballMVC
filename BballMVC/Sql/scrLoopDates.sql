use [00TTI_LeagueScores]
go

Declare @StartDate date, @EndDate date

	Set @StartDate = '12/22/2020'
	Set @EndDate = GetDate()

	While @StartDate < @EndDate
	BEGIN	
		EXEC uspInsertTodaysMatchupsResults 'Test', @StartDate, 'NBA'
		Set @StartDate = DATEADD(D, 1, @StartDate)
	END	
