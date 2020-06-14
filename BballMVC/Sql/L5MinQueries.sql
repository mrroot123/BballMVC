

--Select   L.Q4Score - L.Q4Last1MinScore
--	,L.Q4Score , L.Q4Last1MinScore
--	, l.Q4Last1MinScoreUs ,  (l.Q4Last1MinPt1Us + l.Q4Last1MinPt2Us * 2 + l.Q4Last1MinPt3Us * 3) as UsPtsLmin
--	, l.Q4Last1MinScoreOpp,  (l.Q4Last1MinPt1Opp + l.Q4Last1MinPt2Opp * 2 + l.Q4Last1MinPt3Opp * 3) as OppPtsLmin
--  FROM [00TTI_LeagueScores].[dbo].[BoxScoresLast5Min] L
--   Where l.Venue = 'Home' and l.LeagueName = 'NBA'
--	and ((L.Q4Score - L.Q4Last1MinScore) <> (l.Q4Last1MinPt1Us + l.Q4Last1MinPt2Us * 2 + l.Q4Last1MinPt3Us * 3) + (l.Q4Last1MinPt1Opp + l.Q4Last1MinPt2Opp * 2 + l.Q4Last1MinPt3Opp * 3) )

Declare @r int = 3;

Select  Count(*) As Games, Min(L.GameDate) as Start, Max(L.GameDate) as EndDate
,	Round(avg( Cast( (L.Q4Score - L.Q4Last1MinScore)         AS Float)), 3) as PtsLmin
,  Round(Avg( Cast( (l.Q4Last1MinUsPt1 + l.Q4Last1MinOpPt1) AS Float)), 3) as Pt1
,  Round(Avg( Cast( (l.Q4Last1MinUsPt2 + l.Q4Last1MinOpPt1) AS Float)), 3) as Pt2
,  Round(Avg( Cast( (l.Q4Last1MinUsPt3 + l.Q4Last1MinOpPt1) AS Float)), 3) as Pt3
  FROM [00TTI_LeagueScores].[dbo].[BoxScoresLast5Min] L
   Where l.Venue = 'Home' and l.LeagueName = 'NBA'
