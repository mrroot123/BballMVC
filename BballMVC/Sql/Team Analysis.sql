
Declare @LgAvg float

Select  @LgAvg = Avg(b.ScoreReg)
  From BoxScores b

  Print( @LgAvg )

Select q.*
  From (
	Select  Min(b.GameDate) as GD 
		, ' League' as Team
		,  'Home' as Venue
		, count(*) as Games
		, Round(Avg(b.ScoreReg),1) AS TmStr
		, Round(Avg(b.ScoreRegTeam),1) AS AvgSc
		, Round(Avg(b.ShotsActualMadeUsRegPt1),1) AS Pt1
		, Round(Avg(b.ShotsActualMadeUsRegPt2),1) AS Pt2
		, Round(Avg(b.ShotsActualMadeUsRegPt3),1) AS Pt3

		, Round(Avg(b.ScoreRegOpp),1)  AS PtsAllowed
		, Round(Avg(b.ShotsActualMadeOppRegPt1),1) AS Allowed_Pt1
		, Round(Avg(b.ShotsActualMadeOppRegPt2),1) AS Allowed_Pt2
		, Round(Avg(b.ShotsActualMadeOppRegPt3),1) AS Allowed_Pt3

	From BoxScores b
	Where b.Exclude = 0 AND b.LeagueName = 'NBA' AND b.Venue = 'Home'
	--	b.Team, b.Venue
	) q

union

Select q.*
  From (
	Select  Min(b.GameDate) as GD 
		, b.Team
		, b.Venue
		, count(*) as Games
		, Round(Avg(b.ScoreReg),1) AS TmStr
		, Round(Avg(b.ScoreRegTeam),1) AS AvgSc
		, Round(Avg(b.ShotsActualMadeUsRegPt1),1) AS Pt1
		, Round(Avg(b.ShotsActualMadeUsRegPt2),1) AS Pt2
		, Round(Avg(b.ShotsActualMadeUsRegPt3),1) AS Pt3

		, Round(Avg(b.ScoreRegOpp),1)  AS PtsAllowed
		, Round(Avg(b.ShotsActualMadeOppRegPt1),1) AS Allowed_Pt1
		, Round(Avg(b.ShotsActualMadeOppRegPt2),1) AS Allowed_Pt2
		, Round(Avg(b.ShotsActualMadeOppRegPt3),1) AS Allowed_Pt3

	From BoxScores b
	Where b.Exclude = 0 AND b.LeagueName = 'NBA'
	  Group by 	b.Team, b.Venue
	) q
	Order by q.Team, q.Venue