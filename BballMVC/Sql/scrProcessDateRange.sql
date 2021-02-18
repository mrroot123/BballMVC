Use [00TTI_LeagueScores]

Declare  @UserName	varchar(10), @GameDate Date, @LeagueName varchar(8), @EndDate Date;

Set @UserName = 'Test'
Set @LeagueName = 'NBA';
Set @GameDate = '12/22/2020';
Set @EndDate = GetDate();

While @GameDate < @EndDate
BEGIN
	EXEC [uspInsertTodaysMatchupsResults] @UserName, @GameDate, @LeagueName
	Set @GameDate = DATEADD(DAY, 1, @GameDate)
END