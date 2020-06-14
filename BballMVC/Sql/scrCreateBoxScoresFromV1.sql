Use [00TTI_LeagueScores]

Truncate Table [BoxScores_NEW] 





----- Away ------
INSERT INTO [dbo].[BoxScores_NEW]   (
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









SELECT -- top 100
  0
,[LeagueName]
,[Date]
,[Order]
,[Team]
,[Opp]
,[time]
,[H_A]
,[Season]
,[GameType]
,[MinutesPlayed]
, Case When LeagueName = 'NBA' Then  (MinutesPlayed - 48) / 5 Else   (MinutesPlayed - 40) / 5 END
,[ScReg]+scRegOpp
,[ScOT] + ScOtOpp
, ScReg
,[ScRegOpp]
, ScOT
,[ScOTOpp]
,[Qtr1]
,[Qtr1Opp]
,[Qtr2]
,[Qtr2Opp]
,[Qtr3]
,[Qtr3Opp]
,[Qtr4]
,[Qtr4Opp]
,[FTM]
,[FGM2Pt]
,[FGM3Pt]
, FTMopp
,[FGM2PtOpp]
, FGM3PTopp
,[FTA]
,[FGA2Pt]
,[FGA3Pt]
,[FTAopp]
,[FGA2Ptopp]
,[FGA3Ptopp]
, Case When LeagueName = 'NBA' Then  FTM * (48 / MinutesPlayed)  Else  FTM * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGM2pt * (48 / MinutesPlayed)  Else  FGM2pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGM3pt * (48 / MinutesPlayed)  Else  FGM3pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FTMopp * (48 / MinutesPlayed)  Else  FTMopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGm2ptopp * (48 / MinutesPlayed)  Else  FGm2ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGm3ptopp * (48 / MinutesPlayed)  Else  FGm3ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FTa * (48 / MinutesPlayed)  Else  FTa * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGa2pt * (48 / MinutesPlayed)  Else  FGa2pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGa3pt * (48 / MinutesPlayed)  Else  FGa3pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FTaopp * (48 / MinutesPlayed)  Else  FTaopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGa2ptopp * (48 / MinutesPlayed)  Else  FGa2ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'NBA' Then  FGa3ptopp * (48 / MinutesPlayed)  Else  FGa3ptopp * (40 / MinutesPlayed)  END
,[Tover]
,[ToverOpp]
,[OffRB]
,[OffRBOpp]
,[Assists]
,[AssistsOpp]
, ''
, [Date]
, 1
  FROM [00TTI_LeagueScores].[dbo].V1_BoxScores v
	Where v.MinutesPlayed is not null 
	  AND v.ScReg is not null
	  AND v.ScRegOpp is not null

Select * from BoxScores_NEW