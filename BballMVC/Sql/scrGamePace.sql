

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