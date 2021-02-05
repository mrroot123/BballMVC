/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [GameDate]      ,[LeagueName]      ,[RotNum]
      ,[TeamAway]      ,[TeamHome]
      ,[PlayLength]      ,[PlayDirection]      ,[Line]      ,[Info]      ,[PlayAmount]      ,[Juice]
      ,[OtAffacted]      ,[FinalScore]		,Result
		,Case When Result > 0 Then Result Else ' ' END as Win
		,Case When Result < 0 Then abs(Result) Else ' ' END as Loss
      ,[ResultAmount]
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate = ( select max(WeekEndDate) from [TodaysPlays]
				 where result is not null)
   order by GameDate, RotNum