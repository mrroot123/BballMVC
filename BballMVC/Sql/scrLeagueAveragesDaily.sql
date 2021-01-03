
Select  b.GameDate, count(*) as Games
	,Round(AVG( b.ScoreRegOp+b.ScoreRegUs),2) as ScoreReg
	,Round(AVG( b.ScoreRegOp),2) as Away
	,Round(AVG( b.ScoreRegUs),2) as Home
--, b.ScoreRegUs, *
From BoxScores b
where gamedate >= '12/22/2020'
and b.Venue = 'Home'
Group by b.GameDate
Order by b.GameDate