Use [00TTI_LeagueScores]

/*
4	BoxScores	2018-09-27	2020-03-11	5758
4n	BoxScores_NEW	2009-10-01	2019-12-20	31098

Ren BoxScores_OLD
Cre BoxScores

4	BoxScores		2018-09-27	2020-03-11	5758

4n	BoxScores_NEW	2009-10-01	2019-12-20	31098
4	BoxScores_OLD	2018-09-27	2020-03-11	5758 

Insert into BoxScores <== BoxScores_NEW - ALL 2009-06-06	2019-12-09
Insert into BoxScores <== BoxScores_OLD - Where GameDate > 2019-12-09
*/

Truncate Table [BoxScores] 

----- BoxScores_NEW (ALL) ------
INSERT INTO [dbo].[BoxScores]   (
 [Exclude]
,[LeagueName]
,[GameDate]
,[RotNum]
,[Team]
,[Opp]
,[GameTime]
,[Venue]
,[Season]
,[SubSeason]
,[MinutesPlayed]
,[OtPeriods]
,[ScoreReg]
,[ScoreOT]
,[ScoreRegUs]
,[ScoreRegOp]
,[ScoreOTUs]
,[ScoreOTOp]
,[ScoreQ1Us]
,[ScoreQ1Op]
,[ScoreQ2Us]
,[ScoreQ2Op]
,[ScoreQ3Us]
,[ScoreQ3Op]
,[ScoreQ4Us]
,[ScoreQ4Op]
,[ShotsActualMadeUsPt1]
,[ShotsActualMadeUsPt2]
,[ShotsActualMadeUsPt3]
,[ShotsActualMadeOpPt1]
,[ShotsActualMadeOpPt2]
,[ShotsActualMadeOpPt3]
,[ShotsActualAttemptedUsPt1]
,[ShotsActualAttemptedUsPt2]
,[ShotsActualAttemptedUsPt3]
,[ShotsActualAttemptedOpPt1]
,[ShotsActualAttemptedOpPt2]
,[ShotsActualAttemptedOpPt3]
,[ShotsMadeUsRegPt1]
,[ShotsMadeUsRegPt2]
,[ShotsMadeUsRegPt3]
,[ShotsMadeOpRegPt1]
,[ShotsMadeOpRegPt2]
,[ShotsMadeOpRegPt3]
,[ShotsAttemptedUsRegPt1]
,[ShotsAttemptedUsRegPt2]
,[ShotsAttemptedUsRegPt3]
,[ShotsAttemptedOpRegPt1]
,[ShotsAttemptedOpRegPt2]
,[ShotsAttemptedOpRegPt3]
,[TurnOversUs]
,[TurnOversOp]
,[OffRBUs]
,[OffRBOp]
,[AssistsUs]
,[AssistsOp]
,[Source]
,[LoadDate]
,[LoadTimeSeconds]

)
SELECT -- top 1
 [Exclude]
,[LeagueName]
,[GameDate]
,[RotNum]
,[Team]
,[Opp]
,[GameTime]
,[Venue]
,[Season]
,[SubSeason]
,[MinutesPlayed]
,[OtPeriods]
,[ScoreReg]
,[ScoreOT]
,[ScoreRegUs]
,[ScoreRegOp]
,[ScoreOTUs]
,[ScoreOTOp]
,[ScoreQ1Us]
,[ScoreQ1Op]
,[ScoreQ2Us]
,[ScoreQ2Op]
,[ScoreQ3Us]
,[ScoreQ3Op]
,[ScoreQ4Us]
,[ScoreQ4Op]
,[ShotsActualMadeUsPt1]
,[ShotsActualMadeUsPt2]
,[ShotsActualMadeUsPt3]
,[ShotsActualMadeOpPt1]
,[ShotsActualMadeOpPt2]
,[ShotsActualMadeOpPt3]
,[ShotsActualAttemptedUsPt1]
,[ShotsActualAttemptedUsPt2]
,[ShotsActualAttemptedUsPt3]
,[ShotsActualAttemptedOpPt1]
,[ShotsActualAttemptedOpPt2]
,[ShotsActualAttemptedOpPt3]
,[ShotsMadeUsRegPt1]
,[ShotsMadeUsRegPt2]
,[ShotsMadeUsRegPt3]
,[ShotsMadeOpRegPt1]
,[ShotsMadeOpRegPt2]
,[ShotsMadeOpRegPt3]
,[ShotsAttemptedUsRegPt1]
,[ShotsAttemptedUsRegPt2]
,[ShotsAttemptedUsRegPt3]
,[ShotsAttemptedOpRegPt1]
,[ShotsAttemptedOpRegPt2]
,[ShotsAttemptedOpRegPt3]
,[TurnOversUs]
,[TurnOversOp]
,[OffRBUs]
,[OffRBOp]
,[AssistsUs]
,[AssistsOp]
,[Source]
,[LoadDate]
,[LoadTimeSeconds]

  FROM [00TTI_LeagueScores].[dbo].BoxScores_NEW
 


----- BoxScores_OLD - Where GameDate > 2019-12-09 ------
INSERT INTO [dbo].[BoxScores]   (
 [Exclude]
,[LeagueName]
,[GameDate]
,[RotNum]
,[Team]
,[Opp]
,[GameTime]
,[Venue]
,[Season]
,[SubSeason]
,[MinutesPlayed]
,[OtPeriods]
,[ScoreReg]
,[ScoreOT]
,[ScoreRegUs]
,[ScoreRegOp]
,[ScoreOTUs]
,[ScoreOTOp]
,[ScoreQ1Us]
,[ScoreQ1Op]
,[ScoreQ2Us]
,[ScoreQ2Op]
,[ScoreQ3Us]
,[ScoreQ3Op]
,[ScoreQ4Us]
,[ScoreQ4Op]
,[ShotsActualMadeUsPt1]
,[ShotsActualMadeUsPt2]
,[ShotsActualMadeUsPt3]
,[ShotsActualMadeOpPt1]
,[ShotsActualMadeOpPt2]
,[ShotsActualMadeOpPt3]
,[ShotsActualAttemptedUsPt1]
,[ShotsActualAttemptedUsPt2]
,[ShotsActualAttemptedUsPt3]
,[ShotsActualAttemptedOpPt1]
,[ShotsActualAttemptedOpPt2]
,[ShotsActualAttemptedOpPt3]
,[ShotsMadeUsRegPt1]
,[ShotsMadeUsRegPt2]
,[ShotsMadeUsRegPt3]
,[ShotsMadeOpRegPt1]
,[ShotsMadeOpRegPt2]
,[ShotsMadeOpRegPt3]
,[ShotsAttemptedUsRegPt1]
,[ShotsAttemptedUsRegPt2]
,[ShotsAttemptedUsRegPt3]
,[ShotsAttemptedOpRegPt1]
,[ShotsAttemptedOpRegPt2]
,[ShotsAttemptedOpRegPt3]
,[TurnOversUs]
,[TurnOversOp]
,[OffRBUs]
,[OffRBOp]
,[AssistsUs]
,[AssistsOp]
,[Source]
,[LoadDate]
,[LoadTimeSeconds]

)
SELECT -- top 1
 [Exclude]
,[LeagueName]
,[GameDate]
,[RotNum]
,[Team]
,[Opp]
,[GameTime]
,[Venue]
,[Season]
,[SubSeason]
,[MinutesPlayed]
,[OtPeriods]
,[ScoreReg]
,[ScoreOT]
,[ScoreRegUs]
,[ScoreRegOp]
,[ScoreOTUs]
,[ScoreOTOp]
,[ScoreQ1Us]
,[ScoreQ1Op]
,[ScoreQ2Us]
,[ScoreQ2Op]
,[ScoreQ3Us]
,[ScoreQ3Op]
,[ScoreQ4Us]
,[ScoreQ4Op]
,[ShotsActualMadeUsPt1]
,[ShotsActualMadeUsPt2]
,[ShotsActualMadeUsPt3]
,[ShotsActualMadeOpPt1]
,[ShotsActualMadeOpPt2]
,[ShotsActualMadeOpPt3]
,[ShotsActualAttemptedUsPt1]
,[ShotsActualAttemptedUsPt2]
,[ShotsActualAttemptedUsPt3]
,[ShotsActualAttemptedOpPt1]
,[ShotsActualAttemptedOpPt2]
,[ShotsActualAttemptedOpPt3]
,[ShotsMadeUsRegPt1]
,[ShotsMadeUsRegPt2]
,[ShotsMadeUsRegPt3]
,[ShotsMadeOpRegPt1]
,[ShotsMadeOpRegPt2]
,[ShotsMadeOpRegPt3]
,[ShotsAttemptedUsRegPt1]
,[ShotsAttemptedUsRegPt2]
,[ShotsAttemptedUsRegPt3]
,[ShotsAttemptedOpRegPt1]
,[ShotsAttemptedOpRegPt2]
,[ShotsAttemptedOpRegPt3]
,[TurnOversUs]
,[TurnOversOp]
,[OffRBUs]
,[OffRBOp]
,[AssistsUs]
,[AssistsOp]
,[Source]
,[LoadDate]
,[LoadTimeSeconds]

  FROM [00TTI_LeagueScores].[dbo].[BoxScores_OLD]
   Where GameDate > '2019-12-20'
 


	Select count(*) as Rows
		, Min(GameDate) as StartDate
		, Max(GameDate) as EndDate
	 From [BoxScores] 