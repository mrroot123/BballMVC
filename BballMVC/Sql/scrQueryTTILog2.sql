/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (5) [TTILog_ID]
      ,[TS]
      ,[UserName]
      ,[ApplicationName]
      ,[MessageNum]
      ,[MessageType]
      ,[MessageText]
      ,[CallStack]
  FROM [00TTI_LeagueScores].[dbo].[TTILog]
   where TS > Convert(Date, GetDate())
   order by [TTILog_ID] Desc