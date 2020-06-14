

 SELECT  
 bs.LeagueName,
 bs.Venue, bs.Season, bs.SubSeason  
 , Count(*) as Games 
 , (Min(bs.GameDate)) as StartDate 
 , (Max(bs.GameDate)) as EndDate 
 , avg(bs.ScoreReg) as AvgScoreReg
 , avg(bs.ScoreOT) as AvgFinalOT 
 , '===>' as AWAY
 , Avg(bs.AwayFTMwOTadj)as AwayAvgFTM 
 , Avg(bs.AwayFGM2PtwOTadj)as AwayAvgFGM2Pt 
 , Avg(bs.AwayFGM3PtwOTadj)as AwayAvgFGM3Pt 
 , '===>' as HOME
 , Avg(bs.HomeFTMwOTadj)as HomeAvgFTM 
 , Avg(bs.HomeFGM2PtwOTadj)as HomeAvgFGM2Pt 
 , Avg(bs.HomeFGM3PtwOTadj)as HomeAvgFGM3Pt 
  , '===>' as Attempts
 , Avg(bs.AwayFTAwOTadj)as AwayAvgFTA 
 , Avg(bs.AwayFGA2PtwOTadj)as AwayAvgFGA2Pt 
 , Avg(bs.AwayFGA3PtwOTadj)as AwayAvgFGA3Pt 
 , Avg(bs.HomeFTAwOTadj)as HomeAvgFTA 
 , Avg(bs.HomeFGA2PtwOTadj)as HomeAvgFGA2Pt 
 , Avg(bs.HomeFGA3PtwOTadj)as HomeAvgFGA3Pt 


 FROM ( 
 Select TOP 300  
 b2.LeagueName, b2.Venue, b2.Season, b2.SubSeason, b2.GameDate, b2.ScoreReg, b2.ScoreOT, b2.ScoreRegTeam, b2.ScoreOTTeam, b2.ScoreRegOpp, b2.ScoreOTOpp 
 , (b2.ShotsActualMadeOppPt1    *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFTMwOTadj 
 , (b2.ShotsActualMadeOppPt2 *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFGM2PtwOTadj 
 , (b2.ShotsActualMadeOppPt3 *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFGM3PtwOTadj 
 , (b2.ShotsActualMadeUsPt1       *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFTMwOTadj 
 , (b2.ShotsActualMadeUsPt2    *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFGM2PtwOTadj 
 , (b2.ShotsActualMadeUsPt3    *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFGM3PtwOTadj 

 , (b2.ShotsActualAttemptedOppPt1    *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFTAwOTadj 
 , (b2.ShotsActualAttemptedOppPt2 *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFGA2PtwOTadj 
 , (b2.ShotsActualAttemptedOppPt3 *  (b2.ScoreRegOpp) / (b2.ScoreOTOpp) ) as AwayFGA3PtwOTadj 
 , (b2.ShotsActualAttemptedUsPt1       *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFTAwOTadj 
 , (b2.ShotsActualAttemptedUsPt2    *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFGA2PtwOTadj 
 , (b2.ShotsActualAttemptedUsPt3    *  (b2.ScoreRegTeam   ) / (b2.ScoreOTTeam   ) ) as HomeFGA3PtwOTadj 


   FROM BoxScores b2 
   Where b.Exclude = 0 AND b2.LeagueName = 'NBA' 
  and b2.GameDate < '12/19/2019'
  and b2.Venue = 'Home' 
  and b2.Season = '1920' 
  AND b2.SubSeason = '1-Reg' 
   order by b2.GameDate desc, b2.RotNum desc 
   ) as bs 
 Group by bs.LeagueName, bs.Venue, bs.Season, bs.SubSeason  




