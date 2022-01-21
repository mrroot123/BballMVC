Declare
	 @LeagueName Char(4) = 'NBA'
	 ,@Team char(4) = 'GS'
	 ,@Venue char(4) = 'Home'
	 ,@Season char(4) = '2122'
	 ,@SubSeason char(8) = '1-Reg'



Select @LeagueName as League
		, Round( Avg(b.ScoreReg*100)/100,2) As AvgScReg

		, Round( Avg(((ScoreQ1Us + ScoreQ2Us + ScoreQ1Op + ScoreQ2Op) * 100) / (b.ScoreReg) ),2) As ScorePctH1
		, Round( Avg(((ScoreQ3Us + ScoreQ4Us + ScoreQ3Op + ScoreQ4Op) * 100) / (b.ScoreReg) ),2) As ScorePctH2

		, Round( Avg(((ScoreQ1Us + ScoreQ1Op) * 100) / (b.ScoreReg) ),2) As ScorePctH1
		, Round( Avg(((ScoreQ2Us + ScoreQ2Op) * 100) / (b.ScoreReg) ),2) As ScorePctH2
		, Round( Avg(((ScoreQ3Us + ScoreQ3Op) * 100) / (b.ScoreReg) ),2) As ScorePctH3
		, Round( Avg(((ScoreQ4Us + ScoreQ4Op) * 100) / (b.ScoreReg) ),2) As ScorePctH4

	   FROM BoxScores b
		Where b.LeagueName = @LeagueName
		  And b.Season = @Season
		  And b.SubSeason = @SubSeason
--return
Select  @Team as Team
	, Round( Avg([ScoreRegUs]),1) As ScoreUs
	, Round( Avg([ScoreRegUs])/4,1) As ScoreUsPerQtr
	
	, Round( Avg(ScoreQ1Us + ScoreQ2Us + ScoreQ1Op + ScoreQ2Op),1) As ScoreH1
	, Round( Avg(ScoreQ3Us + ScoreQ4Us + ScoreQ3Op + ScoreQ4Op),1) As ScoreH2
	

	, Round( Avg(ScoreQ1Us + ScoreQ1Op),1) As ScoreQ1
	, Round( Avg(ScoreQ2Us + ScoreQ2Op),1) As ScoreQ2
	, Round( Avg(ScoreQ3Us + ScoreQ3Op),1) As ScoreQ3
	, Round( Avg(ScoreQ4Us + ScoreQ4Op),1) As ScoreQ4

	, Round( Avg(ScoreQ1Us + ScoreQ2Us),1) As ScoreUsH1
	, Round( Avg(ScoreQ3Us + ScoreQ4Us),1) As ScoreUsH2

	, Round( Avg(ScoreQ1Us),1) As ScoreUsQtr1
	, Round( Avg(ScoreQ2Us),1) As ScoreUsQtr2
	, Round( Avg(ScoreQ3Us),1) As ScoreUsQtr3
	, Round( Avg(ScoreQ4Us),1) As ScoreUsQtr4
,'OP-->'
		, Round( Avg([ScoreRegOp]),1) As ScoreOp
	, Round( Avg([ScoreRegOp])/4,1) As ScoreOpPerQtr
	
	, Round( Avg(ScoreQ1Op + ScoreQ2Op),1) As ScoreOpH1
	, Round( Avg(ScoreQ3Op + ScoreQ4Op),1) As ScoreOpH2

	, Round( Avg(ScoreQ1Op),1) As ScoreOpQtr1
	, Round( Avg(ScoreQ2Op),1) As ScoreOpQtr2
	, Round( Avg(ScoreQ3Op),1) As ScoreOpQtr3
	, Round( Avg(ScoreQ4Op),1) As ScoreOpQtr4

  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
   Where Team = @Team
	 And Venue = @Venue
	and GameDate > '10/19/2021'