
Select Avg(l.Q4Last1MinPt1Us) as PT1
		, Avg(l.Q4Last1MinPt2Us) as PT2
		, Avg(l.Q4Last1MinPt3Us) as PT3

		, Avg(l.Q4Last1MinPt1Opp) as AllowedPT1
		, Avg(l.Q4Last1MinPt2Opp) as AllowedPT2
		, Avg(l.Q4Last1MinPt3Opp) as AllowedPT3
  From BoxScoresLast5Min l
  Where Venue = 'Home'