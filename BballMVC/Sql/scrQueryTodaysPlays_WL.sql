/****** Script for SelectTopNRows command from SSMS  ******/
Select 
	Sum(
		Case 
			When Result = 1 Then 1
			else 0
		End
		) as Wins
, 	Sum(
		Case 
			When Result = -1 Then 1
			else 0
		End
		) as Losses
	From 
	(
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
		  End as WL
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
	  and GameDate < convert(Date, GetDate()) and Result is not Null
--	 and PlayLength = 'Game'
) Q1