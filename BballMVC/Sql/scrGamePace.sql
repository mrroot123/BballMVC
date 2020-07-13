Use [00TTI_LeagueScores]

Declare @LeagueName varchar(10) = 'NBA'
		, @GameDate Date
		, @AvgLgPace float	= 165.0

If @LeagueName = 'WNBA'
	Set @AvgLgPace  = 135;


Set @AvgLgPace = (Select TOP 1  LgAvgPace From DailySummary 
						Where LeagueName = @LeagueName AND GameDate <= @GameDate 
						  and LgAvgPace is not Null
						Order by GameDate Desc

Update BoxScores
	Set Pace = (ShotsActualAttemptedUsPt2 + ShotsActualAttemptedUsPt3
					+ ShotsActualAttemptedUsPt1 / 2.0 + TurnOversUs - OffRBUs)
						 * (ScoreRegUs / (ScoreOTUs*1.0))
				+
					(ShotsActualAttemptedOpPt2 + ShotsActualAttemptedOpPt3
					+ ShotsActualAttemptedOpPt1 / 2.0 + TurnOversOp	- OffRBOp)
						 * (ScoreRegOp / (ScoreOTOp*1.0))
				- @AvgLgPace + TmPace
		, Volitility = 
			From BoxScores b
			Join Rotation r ON r.LeagueName = b.LeagueName and r.GameDate = b.GameDate
			Where b.LeagueName = @LeagueName and b.GameDate = @GameDate
/*
      
      GamePace(AWAY) _
           = ( _
             (FGA2Pt(AWAY) + FGA3Pt(AWAY)) _
           + ((FTA(AWAY) - LG_FTA) / 2) _
           - (OffRB(AWAY) - LG_OffRB) _
           + (TOver(AWAY) - LG_Tover) _
 _
           + (FGA2Pt(HOME) + FGA3Pt(HOME)) _
           + ((FTA(HOME) - LG_FTA) / 2) _
           - (OffRB(HOME) - LG_OffRB) _
           + (TOver(HOME) - LG_Tover) _
           + ((LG_Pace - TeamPace(HOME)) * Pct_TeamPace) _
              ) * LG_Reg_Minutes_Played / MinutesPlayed(AWAY)                  '*** MinutesPlayed Home & Away are always the same

*/