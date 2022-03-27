
Declare   @Teams Table (Team varchar(4), Wins int)
Declare   @TeamNames Table (Team varchar(4))

Insert into @Teams
Select TeamNameInDatabase,
(
 Select top 1  
	 convert(int,   Replace(left(TeamRecordAway, 2), '-', ''))
	from TodaysMatchups
	where TeamAway = TeamNameInDatabase
	 order by GameDate desc
 )
from Team where LeagueName = 'NBA' and TeamSource = 'League' and EndDate is null order by TeamNameInDatabase

Select top 10 * from @Teams order by wins desc

Insert into @TeamNames
Select top 10 Team from @Teams order by wins desc

Select * from @TeamNames order by 1

Declare @Season varchar(4) = 
	--'2021' 
	  '2122'
Select @Season,
(
Select  count(*)
	from TodaysMatchups
  Where Season = @Season and Canceled = 0
	And TeamAway in (select Team from @TeamNames) 
	And TeamHome in (select Team from @TeamNames) 
	and playdiff < 0.0
) as Unders
,
(
Select count(*)
	from TodaysMatchups
  Where Season = @Season and Canceled = 0
	And TeamAway in (select Team from @TeamNames) 
	And TeamHome in (select Team from @TeamNames) 
	and playdiff > 0.0
) as Overs


