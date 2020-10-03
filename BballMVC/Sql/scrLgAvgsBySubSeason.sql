use [00TTI_LeagueScores]
Select b.LeagueName,  b.SubSeason, Round(AVG(scoreReg),1) as RegSc, count(*) as Games
 from BoxScores b
 where season in ( '20', '1920') and b.Venue = 'Home'
 group by b.LeagueName, b.SubSeason
  order by b.LeagueName, b.SubSeason