/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [AdjustmentsCodesID]
      ,[Type]
      ,[Description]
      ,[Range]
      ,[BypassDropDown]
  FROM [00TTI_LeagueScores].[dbo].[AdjustmentsCodes]
  order by BypassDropDown