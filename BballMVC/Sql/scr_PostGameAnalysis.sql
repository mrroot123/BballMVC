/****** Script for SelectTopNRows command from SSMS  ******/
SELECT season

		, round(Avg(ShotsMadeUsRegPt1 ),2) as Avg1made
		, round(Avg([ShotsAttemptedUsRegPt1] ),2) as Avg1Atmp
		, round(Avg(ShotsMadeUsRegPt1 / [ShotsAttemptedUsRegPt1]),2) as Avg1Pct

		, round(Avg(ShotsMadeUsRegPt2 ),2) as Avg2made
		, round(Avg([ShotsAttemptedUsRegPt2] ),2) as Avg2Atmp
		, round(Avg(ShotsMadeUsRegPt2 / [ShotsAttemptedUsRegPt2]),2) as Avg2Pct

		, round(Avg(ShotsMadeUsRegPt3 ),2) as Avg3made
		, round(Avg([ShotsAttemptedUsRegPt3] ),2) as Avg3Atmp
		, round(Avg(ShotsMadeUsRegPt3 / [ShotsAttemptedUsRegPt3]),2) as Avg3Pct

  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
   where LeagueName = 'nba'
	  and ShotsAttemptedUsRegPt1 > 0 and ShotsAttemptedUsRegPt2 > 0 and ShotsAttemptedUsRegPt3 > 0
	 group by Season	 
	 order by Season

	 return;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	tm.[GameDate]
	,tm.RotNum
      ,[TeamAway]

      ,[Play]      

-- ,Round(TmStrAway, 1) as TmStrAway
--,Round(UnAdjTotalAway, 1) as UnAdjTotalAway
--,Round(UnAdjTotal, 1) as UnAdjTotal
--,Round(AdjAmtAway, 1) as AdjAmtAway
,Round(OurTotalLineAway, 1) as OurTotalLineAway
--,Round(OurTotalLine, 1) as OurTotalLine
--,Round(SideLine, 1) as SideLine
--,Round(TotalLine, 1) as TotalLine
--,Round(PlayDiff, 1) as PlayDiff
, b.ScoreRegUs

, '-- 1 --' as Stats
,Round(b.ShotsMadeUsRegPt1, 1) as '1 PTers'
,Round(AwayProjectedPt1, 1) as 'Proj 1'
,Round(b.ShotsAttemptedUsRegPt1, 1) as '1 PTers Atmp'
,Round(AwayAverageAtmpUsPt1, 1) as 'Proj Atmp 1'
,Round((b.ShotsMadeUsRegPt1 * 100) / b.ShotsAttemptedUsRegPt1, 1) as '1 PTers %'
,Round((AwayProjectedPt1  * 100)/ AwayAverageAtmpUsPt1, 1) as 'Proj Atmp 1 %'

 , '-- 2 --' as Stats
,Round(b.ShotsMadeUsRegPt2, 1) as '2 PTers'
,Round(AwayProjectedPt2, 1) as 'Proj 2'
,Round(b.ShotsAttemptedUsRegPt2, 1) as '2 PTers Atmp'
,Round(AwayAverageAtmpUsPt2, 1) as 'Proj Atmp 2'
,Round((b.ShotsMadeUsRegPt2 * 100) / b.ShotsAttemptedUsRegPt2, 1) as '2 PTers %'
,Round((AwayProjectedPt2  * 100)/ AwayAverageAtmpUsPt2, 1) as 'Proj Atmp 2 %'

 , '-- 3 --' as Stats
,Round(b.ShotsMadeUsRegPt3, 1) as '3 PTers'
,Round(AwayProjectedPt3, 1) as 'Proj 3'
,Round(b.ShotsAttemptedUsRegPt3, 1) as '3 PTers Atmp'
,Round(AwayAverageAtmpUsPt3, 1) as 'Proj Atmp 3'
,Round((b.ShotsMadeUsRegPt3 * 100) / b.ShotsAttemptedUsRegPt3, 1) as '3 PTers %'
,Round((AwayProjectedPt3  * 100)/ AwayAverageAtmpUsPt3, 1) as 'Proj Atmp 3 %'


  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchups] tm
  JOIN BoxScores b ON b.GameDate = tm.GameDate AND b.RotNum = tm.RotNum
	Where tm.LeagueName = 'NBA' AND tm.GameDate >'3/5/2020'
		And ABS(OurTotalLineAway - b.ScoreRegUs) > 15
  order by rotnum