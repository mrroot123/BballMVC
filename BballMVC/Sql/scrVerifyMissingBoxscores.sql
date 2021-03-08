

use [00TTI_LeagueScores]
/*
	Verify if Boxscores are Missing
	Compare Rotation vs Boxscore - Exclude Cancelled Games
*/

Select IsNull(b.rotnum, r.RotNum) , r.Canceled, r.*
  FROM [00TTI_LeagueScores].[dbo].Rotation r
  left Join BoxScores b on b.GameDate = r.GameDate and b.RotNum = r.RotNum
  where
	r.GameDate < Convert(Date, GetDate()) and  r.Season = '2021' and
	-- r.GameDate <= '2/12/2021' and  r.GameDate > '1/1/2021' and 
	 r.Venue = 'Away' and
	  b.RotNum is null and r.Canceled = 0
    order by r.gamedate desc, r.rotnum

-- Verify Rotaion & TodaysMatchups vs BoxScores
Select IsNull(r.rotnum, b.RotNum) , b.*
  FROM BoxScores b
  left Join Rotation r on b.GameDate = r.GameDate and b.RotNum = r.RotNum
  left Join TodaysMatchups tm on b.GameDate = tm.GameDate and b.RotNum = tm.RotNum
  where
	b.GameDate < Convert(Date, GetDate()) and  b.Season = '2021' and
	-- r.GameDate <= '2/12/2021' and  r.GameDate > '1/1/2021' and 
	 b.Venue = 'Away' and
	  (r.RotNum is null or tm.RotNum is null)
    order by b.gamedate desc, b.rotnum

