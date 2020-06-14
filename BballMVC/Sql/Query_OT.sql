use [00TTI_LeagueScores]

Select 
	Avg(ScoreReg) as AvgReg
	,Avg(ScoreOT) as AvgFinal
	,Round(Avg(ScoreOT) - Avg(ScoreReg), 2) as OTpts

  From BoxScores
   Where Exclude = 0
	  AND LeagueName = 'NBA'

	  Select Season, Round(Avg( ScoreReg), 2) as Reg,  Round(Avg( ScoreOT), 2) as Final
	, Round( Avg( ScoreOT) - Avg( ScoreReg), 2) as OTpts
 From BoxScores
 Where Exclude = 0
 Group by Season