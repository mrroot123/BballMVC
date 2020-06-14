use [00TTI_LeagueScores]

Truncate Table TodaysMatchups

Insert Into TodaysMatchups
Select top 10000 
	* from Schedule s
Where 	s.LeagueName ='NBA' and s.Season > '1718'