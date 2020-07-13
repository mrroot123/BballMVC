
Update TodaysMatchupsResults
SET           TodaysMatchupsResults.Season = t.Season
, TodaysMatchupsResults.SubSeason = t.SubSeason
FROM          TodaysMatchupsResults r
INNER JOIN    boxscores t
ON            r.GameDate = t.GameDate and r.RotNum = t.RotNum