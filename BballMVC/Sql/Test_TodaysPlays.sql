
Update TodaysPlays 
	Set Result = Null
		, PlayLength = 'H2'
		, PlayDirection = 'Under'
		, Line = 101
		
	 Where TodaysPlaysID = 8233


EXEC uspUpdateTodaysPlays

select  * from TodaysPlays Where TodaysPlaysID = 8233

