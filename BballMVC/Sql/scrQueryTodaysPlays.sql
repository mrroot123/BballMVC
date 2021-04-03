Use [00TTI_LeagueScores]

-- EXEC uspUpdateTodaysPlays  

Declare @WeekEndDate Date = ( select max(WeekEndDate) from [TodaysPlays] where result is not null)

--set  @WeekEndDate = '3/21/2021'

 
-- Weekly --
SELECT 
		 max(WeekEndDate) as WeekEnd
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as WeeklyResult
      ,Sum(OtAffacted) as OtAffacted
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate = @WeekEndDate

-- Weeklys --
SELECT 
		 max(WeekEndDate) as WeekEnd
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as WeeklyResult
		,Sum(OtAffacted) as OtAffacted
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate > '12/1/2020'
    Group by WeekEndDate

-- Dailys --
SELECT 
		 GameDate
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as DailyResult
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where WeekEndDate =  @WeekEndDate
  Group by GameDate

  -- All Plays for week --
SELECT [GameDate]      ,[LeagueName]      ,[RotNum]
      ,[TeamAway]      ,[TeamHome]
      ,[PlayLength]      ,[PlayDirection]      ,[Line]      ,[Info]      ,[PlayAmount]      ,[Juice]
      ,[OtAffacted]      ,[FinalScore]		,Result
		,Case When Result > 0 Then Result Else ' ' END as Win
		,Case When Result < 0 Then abs(Result) Else ' ' END as Loss
      ,[ResultAmount], t.CreateDate
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays] t
  where WeekEndDate = @WeekEndDate
   order by GameDate, RotNum

