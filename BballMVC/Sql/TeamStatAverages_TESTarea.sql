use [00TTI_LeagueScores]

Declare @GameDate Datetime = GetDate();
Declare @LeagueName varchar(8) = 'NBA';
Declare @Team varchar(8) = 'ATL';
Declare @Venue varchar(8) = 'Home';

Declare @GamesBack1 int =  10;

Select TOP (@GamesBack1)
 b.*
From BoxScoresLast5Min b
 JOIN BoxScoresLast5Min bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
Where b.LeagueName = @LeagueName
-- AND	b.Team = @Team
-- AND  b.Venue = @Venue
 Order BY b.GameDate DESC