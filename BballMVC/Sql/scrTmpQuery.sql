
 -- Select * From BoxScores Where LeagueName  = 'wnba' AND Season = '20' AND Source = 'Seeded' order by Team, RotNum, Venue; return
	

 Select Team, Venue, count(*) From BoxScores 
	Where LeagueName  = 'wnba' AND Season = '20' AND Source = 'Seeded'
	group by Team, Venue  order by Team, Venue
 --SELECT *  FROM [00TTI_LeagueScores].[dbo].[BoxScoresSeeds] where LeagueName = 'wnba'