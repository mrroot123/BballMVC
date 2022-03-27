/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [TodaysMatchupsID]
,[GameDate]
,[Season]
,[SubSeason]
,[TeamAway]
,[TeamHome]
,[RotNum]
,[GameTime]
,Round(PlayDiff, 1) as PlayDiff
,[OpenPlayDiff]
,[AdjustedDiff]
,Round(TmStrAway, 1) as TmStrAway
,Round(TmStrHome, 1) as TmStrHome
,Round(UnAdjTotalAway, 1) as UnAdjTotalAway
,Round(UnAdjTotalHome, 1) as UnAdjTotalHome
,Round(UnAdjTotal, 1) as UnAdjTotal
,[AdjAmtAway]
,[AdjAmtHome]
,[AdjAmt]
,[AdjOTwithSide]
,Round(OurTotalLineAway, 1) as OurTotalLineAway
,Round(OurTotalLineHome, 1) as OurTotalLineHome
,Round(OurTotalLine, 1) as OurTotalLine
,[SideLine]
,[TotalLine]
,[OpenTotalLine]
,[Play]


,[BxScLinePct]
,[TmStrAdjPct]
,[GB1]
,[GB2]
,[GB3]
,[WeightGB1]
,[WeightGB2]
,[WeightGB3]
,Round(AwayGB1, 1) as AwayGB1
,Round(AwayGB2, 1) as AwayGB2
,Round(AwayGB3, 1) as AwayGB3
,Round(HomeGB1, 1) as HomeGB1
,Round(HomeGB2, 1) as HomeGB2
,Round(HomeGB3, 1) as HomeGB3
,Round(AwayGB1Pt1, 1) as AwayGB1Pt1
,Round(AwayGB1Pt2, 1) as AwayGB1Pt2
,Round(AwayGB1Pt3, 1) as AwayGB1Pt3
,Round(AwayGB2Pt1, 1) as AwayGB2Pt1
,Round(AwayGB2Pt2, 1) as AwayGB2Pt2
,Round(AwayGB2Pt3, 1) as AwayGB2Pt3
,Round(AwayGB3Pt1, 1) as AwayGB3Pt1
,Round(AwayGB3Pt2, 1) as AwayGB3Pt2
,Round(AwayGB3Pt3, 1) as AwayGB3Pt3
,Round(HomeGB1Pt1, 1) as HomeGB1Pt1
,Round(HomeGB1Pt2, 1) as HomeGB1Pt2
,Round(HomeGB1Pt3, 1) as HomeGB1Pt3
,Round(HomeGB2Pt1, 1) as HomeGB2Pt1
,Round(HomeGB2Pt2, 1) as HomeGB2Pt2
,Round(HomeGB2Pt3, 1) as HomeGB2Pt3
,Round(HomeGB3Pt1, 1) as HomeGB3Pt1
,Round(HomeGB3Pt2, 1) as HomeGB3Pt2
,Round(HomeGB3Pt3, 1) as HomeGB3Pt3
,Round(TotalBubbleAway, 1) as TotalBubbleAway
,Round(TotalBubbleHome, 1) as TotalBubbleHome
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchups]
  where Season = '2122'
