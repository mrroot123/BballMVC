use [00TTI_LeagueScores]

	Declare
			  @LeagueName varchar(10) = 'NBA'
			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
			, @GameDate date = '3/6/2020'
	;

Select Team
	, Round(Avg(ScoreRegUs+ScoreRegOp),1) as Total
	, Round(Avg(ScoreRegUs),1) as Team

	, Round(Avg(b.ShotsMadeUsRegPt1),1) + Round(Avg(b.ShotsMadeUsRegPt2),1) * 2 +  Round(Avg(b.ShotsMadeUsRegPt3),1) *3 as 'Team Sum'


	, Round(Round(Avg(ScoreRegUs),1)  - 
		(Round(Avg(b.ShotsMadeUsRegPt1),1) + Round(Avg(b.ShotsMadeUsRegPt2),1) * 2 +  Round(Avg(b.ShotsMadeUsRegPt3),1) *3), 1)  as 'Team DIFF'


	, Round(Avg(b.ShotsMadeusRegPt1),1) as Pt1
	, Round(Avg(b.ShotsMadeusRegPt2),1) as Pt2
	, Round(Avg(b.ShotsMadeusRegPt3),1) as Pt3
	
	, 'OPP==>'
	, Round(Avg(ScoreRegOp),1) as Op
	, Round(Avg(b.ShotsMadeOpRegPt1),1) + Round(Avg(b.ShotsMadeOpRegPt2),1) * 2 +  Round(Avg(b.ShotsMadeOpRegPt3),1) *3 as 'Opp Sum'


	, Round(Round(Avg(ScoreRegOp),1)  - 
		(Round(Avg(b.ShotsMadeOpRegPt1),1) + Round(Avg(b.ShotsMadeOpRegPt2),1) * 2 +  Round(Avg(b.ShotsMadeOpRegPt3),1) *3), 1)  as 'OPP DIFF'



	, Round(Avg(b.ShotsMadeOpRegPt1),1) as Pt1op
	, Round(Avg(b.ShotsMadeOpRegPt2),1) as Pt2op
	, Round(Avg(b.ShotsMadeOpRegPt3),1) as Pt3op
From BoxScores b
where Season = @Season
 Group BY b.Team
 order by b.Team
