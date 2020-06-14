/****** Script for SelectTopNRows command from SSMS  ******/
--Declare @BxScSource varchar(2) = 'lg';	--
Declare @BxScSource varchar(2) = 'lg' --  'lg';	-- Select DB - 00TTI_LeagueScores or 00TTI_LeagueScores_V1

-- Hardcoded Leage Averages
Declare @LgTmStrAway float = 108.5
		, @LgTmStrHome float = 111.5;

Declare @LeagueName varchar(10) = 'NBA'
		, @GameDate date
		, @Venue varchar(4)
		, @Team varchar(10)
;

Declare @varLgAvgGamesBack int = (Select Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varLgAvgGamesBack')

Set @GameDate = '1/7/2020'
Set @Venue = 'Away'
Set @Team = 'ATL'

Select * 
	, Round(CASE x.Venue 
			WHEN 'AWAY' THEN ((@LgTmStrAway / x.Scored) + 1 ) / 2
			ELSE				  ((@LgTmStrHome / x.Scored ) + 1 ) / 2
		END , 2) as ScoredAdjPct
	, Round(CASE x.Venue 
			WHEN 'AWAY' THEN ((@LgTmStrAway / x.Allowed ) + 1 ) / 2
			ELSE				  ((@LgTmStrHome / x.Allowed ) + 1 ) / 2
		END , 2) as ScoredAdjPct
	From
	(
		SELECT 
				Min(b.GameDate) as Start,
			  count(*) as Rows ,
				 b.[Team]
				, b.[Venue]
				, Round(Avg(b.[ScoreReg]), 1) as ScoreReg
				, Round(Avg(b.[ScoreReg]) - (@LgTmStrAway + @LgTmStrHome), 1) as ScoreRating
				,  Round(Avg(b.[ScoreRegUs]), 1) as Scored
				,  Round(Avg(b.[ScoreRegOp]), 1) as Allowed
		FROM
		(
				SElect TOP (@varLgAvgGamesBack) 
					b1.GameDate, b1.Team, b1.Venue, b1.ScoreReg, b1.ScoreRegUs, b1.ScoreRegOp
				  FROM [00TTI_LeagueScores].[dbo].[BoxScores] b1
					Where @BxScSource = 'lg' 
					  AND b1.Exclude = 0 AND b1.LeagueName = @LeagueName and Venue = @Venue and b1.Team = @Team AND b1.GameDate <= @GameDate
					order by b1.GameDate desc

				UNION
			   SElect TOP (@varLgAvgGamesBack) 
					b1.Date as GameDate, b1.Team, b1.H_A as Venue, (b1.ScReg + b1.ScRegOpp) as ScoreReg, b1.ScReg as ScoreRegUs, b1.ScRegOpp as ScoreRegOp
				  FROM [00TTI_LeagueScores_V1].[dbo].[BoxScores] b1
					Where @BxScSource = 'V1' 
					  AND b1.LeagueName = @LeagueName and b1.H_A = 'Home' and b1.Team = @Team AND b1.Date <= @GameDate
					order by b1.Date desc

		) b
		group by b.Team, b.Venue
	) x
Order by x.Team, x.Venue, x.ScoreRating desc

	
RETURN
				SElect top 10 
					b1.Date as GameDate, b1.Team, b1.H_A as Venue, (b1.ScReg + b1.ScRegOpp) as ScoreReg, b1.ScReg as ScoreRegUs, b1.ScRegOpp as ScoreRegOp
				  FROM [00TTI_LeagueScores_V1].[dbo].[BoxScores] b1
					Where b1.LeagueName = 'NBA' and b1.H_A = 'Home' and b1.Team = 'UTA'
					order by b1.Date desc

									SElect top 10 
					b1.GameDate, b1.Team, b1.Venue, b1.ScoreReg, b1.ScoreRegUs, b1.ScoreRegOp
				  FROM [00TTI_LeagueScores].[dbo].[BoxScores] b1
					Where b1.LeagueName = 'NBA' and Venue = 'Home' and b1.Team = 'UTA'
					order by b1.GameDate desc