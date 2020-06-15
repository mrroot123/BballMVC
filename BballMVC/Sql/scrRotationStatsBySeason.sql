
use [00TTI_LeagueScores]

	Select 'Boxscores' as 'Table', LeagueName, Season, SubSeason, Venue, Min(GameDate) as StartDate, Max(GameDate) as EndDate,  count(*) as Rows
		from 
		--	Rotation
			Boxscores
		Where LeagueName = 'NBA' and SubSeason = '1-Reg' and Season > '1516' and Venue = 'Away'
		Group by LeagueName, Season, SubSeason,  Venue
		order by LeagueName, Season, SubSeason,  Venue

			Select  'Rotation' as 'Table',  LeagueName, Season, SubSeason, Venue, Min(GameDate) as StartDate, Max(GameDate) as EndDate,  count(*) as Rows
		from 
			Rotation
		--	Boxscores
		Where LeagueName = 'NBA' and SubSeason = '1-Reg' and Season > '1516' and Venue = 'Away'
		Group by LeagueName, Season, SubSeason,  Venue
		order by LeagueName, Season, SubSeason,  Venue
