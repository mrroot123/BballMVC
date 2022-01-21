--Use [00TTI_LeagueScores]


-- EXEC uspUpdateTodaysPlays  

Declare @WeekEndDate Date = ( select max(WeekEndDate) from [TodaysPlays] where result is not null)
-- Select @WeekEndDate as ThisWeekEndDate

--set  @WeekEndDate = '3/21/2021'

 
-- Weekly --
SELECT 
		 max(WeekEndDate) as ThisWeekEnd
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as WeeklyResult
      ,Sum(OtAffacted) as OtAffacted
  FROM [TodaysPlays]
  where WeekEndDate = @WeekEndDate

-- Weeklys --
SELECT 'Weeklys' as 'Type',
		 max(WeekEndDate) as WeekEnd
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as WeeklyResult
		,Sum(OtAffacted) as OtAffacted
  FROM [TodaysPlays]
  where WeekEndDate > '12/1/2021'
    Group by WeekEndDate

-- Dailys --
SELECT 'Dailys' as 'Type',
		 GameDate
		,Sum(Case When Result > 0 Then Result Else ' ' END) as Wins
		,Sum(Case When Result < 0 Then abs(Result) Else ' ' END) as Losses
      ,Sum([ResultAmount]) as DailyResult
  FROM [TodaysPlays]
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
  FROM [TodaysPlays] t
  where WeekEndDate = @WeekEndDate
   order by GameDate, RotNum

