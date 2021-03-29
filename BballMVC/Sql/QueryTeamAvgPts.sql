/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT 
--	b.Venue
--	, b.Team, b.opp
--	, b.GameDate
--	,b.ScoreReg
--	,b.ScoreRegUs
--	, b.ScoreRegOp

--	--, min(b.GameDate) as StartDate
--	--, Count(*) as Games
--	--, Round(Avg(b.ScoreReg),1) as TmAvg
--	--, Round(Avg(b.ScoreRegUs),1) as AvgPtsScored
--	--, Round(Avg(b.ScoreRegOp),1) as AvgPtsAllowed  
--	FROM (
--		Select top 600 * From BoxScores order by gameDate Desc
--  )b
--  Where b.LeagueName= 'NBA' AND Season = '1920' and b.Source <> 'Seeded' and b.Team = 'was' and b.Venue='away'
----  Group By b.Venue, b.Team  
----  Order By b.Venue, Avg(b.ScoreReg) Desc

SELECT 
	b.Venue
	, b.Team
	, min(b.GameDate) as StartDate
	, Count(*) as Games
	, Round(Avg(b.ScoreReg),1) as TmAvg
	, Round(Avg(b.ScoreRegUs),1) as AvgPtsScored
	, Round(Avg(b.ScoreRegOp),1) as AvgPtsAllowed

	, Round(Avg(b.ShotsMadeUsRegPt1),1) as ScoredRegPt1
	, Round(Avg(b.ShotsMadeUsRegPt2),1) as ScoredRegPt2
	, Round(Avg(b.ShotsMadeUsRegPt3),1) as ScoredRegPt3

	, Round(Avg(b.ShotsMadeOpRegPt1),1) as AllowedRegPt1
	, Round(Avg(b.ShotsMadeOpRegPt2),1) as AllowedRegPt2
	, Round(Avg(b.ShotsMadeOpRegPt3),1) as AllowedRegPt3

  FROM (
		Select top 600 * From BoxScores Where Exclude = 0 order by gameDate Desc
  )b
  Where b.LeagueName= 'NBA' AND Season = '2021' and b.Source <> 'Seeded'
   and b.Team = 'NY' -- and b.Venue = 'Home'
  Group By b.Venue, b.Team  
  Order By b.Venue, Avg(b.ScoreReg) Desc