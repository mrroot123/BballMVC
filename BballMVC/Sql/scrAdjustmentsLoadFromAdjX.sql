USE [00TTI_LeagueScores]
GO

INSERT INTO [dbo].[Adjustments]
         ([LeagueName]
         ,[StartDate]
         ,[EndDate]
         ,[Team]
         ,[AdjustmentType]
         ,[AdjustmentAmount]
         ,[Player]
         ,[Description]
         ,[TS])
Select	
		[LeagueName]
      ,[StartDate]
      ,[EndDate]
      ,isnull([Team],'')
      ,[Type]
      ,[AdjAmt]
      ,[Player]
      ,isNull([Desc], '')
      ,IsNull(EndDate, StartDate)
  FROM [00TTI_LeagueScores].[dbo].[Adjustmentsx]
  Where AdjAmt is not null

