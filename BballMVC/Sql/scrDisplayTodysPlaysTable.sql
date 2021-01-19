use [00TTI_LeagueScores]

  exec uspUpdateTodaysPlays
SELECT 'Sum Plays' as 'Desc'
      ,Sum([Result]) as 'Plays Up'
      ,Sum([ResultAmount]) as PlayAmt
 

 --  delete
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]



SELECT 
 --[TodaysPlaysID]
 --           ,[CreateDate]
	--			,[WeekEndDate]
  [GameDate]
    ,[LeagueName]
      ,[RotNum]
    --  ,[GameTime]
      ,[TeamAway]
      ,[TeamHome]
      
    --  ,[PlayLength]
      ,[PlayDirection]
      ,[Line]
    --  ,[Info]
    --  ,[PlayAmount]
   --   ,[PlayWeight]
      ,[Juice]
   --   ,[Out]
   --   ,[Author]
      ,([Result])
      ,[OtAffacted]
      ,[FinalScore]
      ,[ResultAmount]
      ,[CreateUser]

 --  delete
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]

  order by GameDate, rotnum