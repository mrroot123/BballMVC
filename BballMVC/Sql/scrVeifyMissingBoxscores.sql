/**
SELECT *
-- delete
  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
  where GameDate = '2/1/2021' 

    order by gamedate desc, rotnum
	 */
use [00TTI_LeagueScores]
Select IsNull(b.rotnum, r.RotNum) , r.Canceled, r.*
  FROM [00TTI_LeagueScores].[dbo].Rotation r
  left Join BoxScores b on b.GameDate = r.GameDate and b.RotNum = r.RotNum
  where
	r.GameDate < Convert(Date, GetDate()) and  r.Season = '2021' and
	-- r.GameDate <= '2/12/2021' and  r.GameDate > '1/1/2021' and 
	 r.Venue = 'Away' and
	  b.RotNum is null and r.Canceled = 0
    order by r.gamedate desc, r.rotnum

