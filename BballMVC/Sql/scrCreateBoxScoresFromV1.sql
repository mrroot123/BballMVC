Use [00TTI_LeagueScores_V1]


Truncate Table [BoxScores_NEW] 
Declare @MinsPerGame float = 40.0;



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
,[GameDate]
,[RotNum]
,[Team]
,[Opp]
,[time]
,[Venue]
,[Season]
,[GameType]
,[MinutesPlayed]
, (MinutesPlayed - @MinsPerGame) / 5 
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
, Case When LeagueName = 'WNBA' Then  FTM * (@MinsPerGame / MinutesPlayed)  Else  FTM * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGM2pt * (@MinsPerGame / MinutesPlayed)  Else  FGM2pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGM3pt * (@MinsPerGame / MinutesPlayed)  Else  FGM3pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FTMopp * (@MinsPerGame / MinutesPlayed)  Else  FTMopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGm2ptopp * (@MinsPerGame / MinutesPlayed)  Else  FGm2ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGm3ptopp * (@MinsPerGame / MinutesPlayed)  Else  FGm3ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FTa * (@MinsPerGame / MinutesPlayed)  Else  FTa * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGa2pt * (@MinsPerGame / MinutesPlayed)  Else  FGa2pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGa3pt * (@MinsPerGame / MinutesPlayed)  Else  FGa3pt * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FTaopp * (@MinsPerGame / MinutesPlayed)  Else  FTaopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGa2ptopp * (@MinsPerGame / MinutesPlayed)  Else  FGa2ptopp * (40 / MinutesPlayed)  END
, Case When LeagueName = 'WNBA' Then  FGa3ptopp * (@MinsPerGame / MinutesPlayed)  Else  FGa3ptopp * (40 / MinutesPlayed)  END
,[Tover]
,[ToverOpp]
,[OffRB]
,[OffRBOpp]
,[Assists]
,[AssistsOpp]
, ''
, [GameDate]
, 1
--  FROM [00TTI_LeagueScores].[dbo].V1_BoxScores v
  FROM BoxScores_V1 v
	Where v.MinutesPlayed is not null 
	  AND v.ScReg is not null
	  AND v.ScRegOpp is not null
	  AND v.LeagueName = 'WNBA' and season = '19' and v.GameDate > '5/31/2019'

Select * from BoxScores_NEW

Select  * from BoxScores_NEW b where scorereg <> scoreOt