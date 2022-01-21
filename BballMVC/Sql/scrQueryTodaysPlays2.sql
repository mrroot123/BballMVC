/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [GameDate]
      ,[LeagueName]
      ,[RotNum]
      
      ,[TeamAway]
      ,[TeamHome]
      ,[WeekEndDate]
      ,[PlayLength]
      ,[PlayDirection]
      ,[Line]
      ,[Info]
      ,[PlayAmount]
      ,[PlayWeight]
      ,[Juice]
      ,[Out]
      ,[Author]
		, Case Result
			When 1 Then 'W'
			When -1 Then 'L'
			When 0  Then 'T'
			else 
			 'x'
		  End
      ,[Result]
      ,[OtAffacted]
      ,[ScoreAway]
      ,[ScoreHome]
      ,[FinalScore]
      ,[ResultAmount]
      ,[CreateUser]
      ,[CreateDate]
  FROM [db_a791d7_leaguescores].[dbo].[TodaysPlays]
   where WeekEndDate > '12/1/2021' -- = '2022-01-02'
	 and PlayLength <> 'Game'