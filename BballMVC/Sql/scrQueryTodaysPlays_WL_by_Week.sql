
SELECT 

       [WeekEndDate]
		 , sum(ResultAmount) as Amt
		 ,	Sum(
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
  FROM [db_a791d7_leaguescores].[dbo].[TodaysPlays]
   where WeekEndDate > '12/1/2021' -- = '2022-01-02'

	  and GameDate < convert(Date, GetDate()) and Result is not Null
	Group By WeekEndDate
	Order By WeekEndDate
