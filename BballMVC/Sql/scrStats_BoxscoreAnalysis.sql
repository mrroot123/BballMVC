/****** Script for SelectTopNRows command from SSMS  ******/
SELECT top 30 
		 [LeagueName]
		,
      ,[Date]
      --,[Team]
      --,[Opp]
      ,[Order]

      ,[Season]
      ,[GameType]

      ,[TotalLine]

      ,[MinutesPlayed]
      ,[ScReg]
      ,[ScRegOpp]
      ,[ScOT]
      ,[ScOTOpp]

      ,[uo_Game]

  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores] b
 --  Group by b.LeagueName