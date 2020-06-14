/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) s.[LeagueName]
      ,s.[Date]
 --     ,s.[Season]
 --     ,s.[SubSeason]
      ,s.[Away_Team]
      ,s.[Home_Team]
      ,s.[Order]
		, Abs( (b.screg + b.ScRegOpp) - s.TotalLine)  
		- Abs( (b.screg + b.ScRegOpp) - s.[CalcedTotalLine])  
			as Diff
		, (b.screg + b.ScRegOpp) as Reg
		, (b.scOT + b.ScOTOpp) as Final
     ,s.[CalcedTotalLine] as OurLine
      ,s.[TotalLine]
      ,s.[OpenTotalLine]
      ,s.[Diff]
      ,s.[sUnderDiff]
      ,s.[sOverDiff]
      ,s.[CalcedPlay]
      ,s.[Play]
      ,s.[PlayResult]
      ,s.[PlayHistoryLineDiffAway]
      ,s.[PlayHistoryLineDiffHome]

  FROM [00TTI_LeagueScores].[dbo].[Schedule] s
  Join BoxScores b  ON b.Date = s.Date and b.[Order] = s.[Order]
  Where s.LineDiff = 0 and s.OpenLineDiff = 0 