Truncate Table BoxScoresBAK

SET IDENTITY_INSERT [BoxScoresBAK] off -- Must be OFF to insert & Must specify Colnames 

 Insert Into [BoxScoresBAK] (
Exclude,LeagueName,GameDate,RotNum,Team,Opp,Venue,GameTime,Season,SubSeason,SubSeasonPeriod,MinutesPlayed,OtPeriods,ScoreReg,ScoreOT,ScoreRegUs,ScoreRegOp,ScoreOTUs,ScoreOTOp,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp,Pace,Source,LoadDate,LoadTimeSeconds
 ) SELECT
Exclude,LeagueName,GameDate,RotNum,Team,Opp,Venue,GameTime,Season,SubSeason,SubSeasonPeriod,MinutesPlayed,OtPeriods,ScoreReg,ScoreOT,ScoreRegUs,ScoreRegOp,ScoreOTUs,ScoreOTOp,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp,Pace,Source,LoadDate,LoadTimeSeconds
  FROM BoxScores
