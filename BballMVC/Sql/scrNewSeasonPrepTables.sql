
--- 10/08/2021	Bball Delete last season unnecessary rows from Tables in BballProd


-- Use [db_a791d7_leaguescores]
Use [00TTI_LeagueScores]

If NOT @@SERVICENAME = 'BBALLPROD'
	Throw 51000, 'Script can only run in BBALLPROD' ,1

Declare @LeagueName varchar(4) = 'NBA'
		, @Season varchar(4)
		, @LastSeason varchar(4)
		, @SeasonStartDate Date
		, @LastSeasonStartDate Date

Set @Season = (
		  Select top 1 Season From SeasonInfo
			Where StartDate <= GetDate() and LeagueName = @LeagueName
			order by StartDate desc	 
			 )

Set @LastSeason = (
		  Select top 1 Season From SeasonInfo
			Where Season < @Season  and LeagueName = @LeagueName
			order by Season desc	 
			 )

Select @LastSeason , @Season


Set @SeasonStartDate = (
			Select StartDate from SeasonInfo
			  Where Season = @LastSeason and SubSeason = '0-Pre'
	)
If @SeasonStartDate is null
BEGIN
	Set @SeasonStartDate = (
				Select StartDate from SeasonInfo
				  Where Season = @LastSeason and SubSeason = '1-Reg'
		)
END

Set @LastSeasonStartDate = (
			Select StartDate from SeasonInfo
			  Where Season = @Season and SubSeason = '0-Pre'
	)
If @LastSeasonStartDate is null
BEGIN
	Set @LastSeasonStartDate = (
				Select StartDate from SeasonInfo
				  Where Season = @Season and SubSeason = '0-Pre'
		)
END

Select  @LeagueName
		, @LastSeason 
		, @Season 
		, @LastSeasonStartDate 
		, @SeasonStartDate --			
		

Truncate Table TTILog

Delete
	From	Adjustments
	Where LeagueName = @LeagueName AND StartDate < @LastSeasonStartDate

Delete
	From	BoxScores
	Where LeagueName = @LeagueName AND Season < @LastSeason

Delete
	From	BoxScoresLast5Min
	Where LeagueName = @LeagueName AND GameDate < @LastSeasonStartDate

Delete
	From	DailySummary
	Where LeagueName = @LeagueName AND Season < @LastSeason
	
Delete
	From	Lines
	Where LeagueName = @LeagueName AND GameDate < @SeasonStartDate

Delete
	From	Rotation
	Where LeagueName = @LeagueName AND Season < @LastSeason
	
Delete
	From	TeamStatsAverages
	Where LeagueName = @LeagueName AND GameDate < @LastSeasonStartDate

Delete
	From	TeamStrength
	Where LeagueName = @LeagueName AND GameDate < @LastSeasonStartDate

Delete
	From	TodaysMatchups
	Where LeagueName = @LeagueName AND Season < @LastSeason
	
Delete
	From	TodaysPlays
	Where LeagueName = @LeagueName AND GameDate < @LastSeasonStartDate
	

