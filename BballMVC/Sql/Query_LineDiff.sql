/****** Script for SelectTopNRows command from SSMS  ******/

SELECT  Max(b.[LeagueName]) as Lg
      ,Min(	format(b.[Date], 'dd-MM-yyyy')) as StartDate
      ,Max(	format(b.[Date], 'dd-MM-yyyy')) as EndDate
      ,Count(*) as games

      ,round(AVG( b.[LineDiff]), 1) AS AvgDiff

  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores] b
   where b.LeagueName = 'NBA'
	  AND b.LineDiff is not null
	  and Abs(b.LineDiff) > 2
	  and b.date < '12/31/2019' and b.date > '11/1/2018'
	 -- Order by b.Date desc

/* ***** Script for SelectTopNRows command from SSMS  ****** /
SELECT TOP (1000) b.[LeagueName]
      ,b.[Date]
      ,b.[Team]
      ,b.[Opp]
      ,b.[Order]
      ,b.[TotalLine]
      ,b.[LineDiff]
      ,b.[ScReg]+b.[ScRegOpp] as RegFinal
		,round(s.CalcedTotalLine,1) as OurLine

  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores] b
   join V1_Schedule s on s.Date = b.Date  and s.[Order] = b.[order]
   where b.LeagueName = 'NBA'
	  AND b.LineDiff is not null
	  Order by b.Date desc

	  */