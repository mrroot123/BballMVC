

-- EXEC uspUpdateTodaysPlays  

Declare @WeekEndDate Date = ( select max(WeekEndDate) from [TodaysPlays] where result is not null)

set  @WeekEndDate = '1/24/2021'

SELECT 
		 max(WeekEndDate) as WeekEnd
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as WeeklyResult
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate = @WeekEndDate

SELECT 
		 GameDate
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as DailyResult
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate = @WeekEndDate
  Group by GameDate

SELECT [GameDate]      ,[LeagueName]      ,[RotNum]
      ,[TeamAway]      ,[TeamHome]
      ,[PlayLength]      ,[PlayDirection]      ,[Line]      ,[Info]      ,[PlayAmount]      ,[Juice]
      ,[OtAffacted]      ,[FinalScore]		,Result
		,Case When Result > 0 Then Result Else ' ' END as Win
		,Case When Result < 0 Then abs(Result) Else ' ' END as Loss
      ,[ResultAmount]
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate = @WeekEndDate
   order by GameDate, RotNum

