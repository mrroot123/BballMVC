  use [00TTI_LeagueScores]
  go

  CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO


  Declare @UserName	varchar(10) = 'Test'
			, @LeagueName varchar(8) = 'NBA'
			, @GameDate Date
			, @StartDate Date 
			, @EndDate Date
			, @Display bit = 0	-- Set to 1 to display TodaysMatchups
			, @TruncateTables bit = 0	-- Set to 1 to Truncate Tables
  ;

if @TruncateTables = 0
BEGIN
	
	Truncate Table TodaysMatchupsResults;
	Truncate Table TodaysMatchups;
--	Truncate Table TeamStrength;
END

SELECT @StartDate =   Min([StartDate])
  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
  where season = '1819' And Bypass = 0


Set @GameDate = @StartDate
Set @GameDate = DateAdd(d,1, @GameDate)

Set @GameDate = '12/1/2018'
Set @EndDate =  '5/1/2019' --  DateAdd(d,15, @GameDate)

Declare @RunTodays bit = 0			-- 1 = @RunTodays games only  -----------------  TODAYS GAMES ------------
If @RunTodays = 1
BEGIN
	Set @Display = 0;
	Set @GameDate = CONVERT(date, getdate()); Set @EndDate = @GameDate;
END

Declare @StartTime dateTime = GetDate();
SELECT @StartDate as StartDate, @EndDate as EndDate,  convert(Time(0), getdate()) as StartTime

---------------
-- Main Loop --
---------------
set @Display = 1
While @GameDate <= @EndDate
BEGIN
	print @GameDate
	exec uspCalcTodaysMatchups  @UserName, @LeagueName, @GameDate, @Display
	Set @GameDate = DateAdd(d,1, @GameDate)
	set @Display = 0
END


print getdate()

Select *, (wins*100) / (convert( float,wins)+Losses) * 1.0 as WinPct
From (
SELECT count(*) as MUPs

     ,round(avg(ScoreReg), 2) as ScoreReg
     ,round(avg(TotalLine), 2) as TotalLine
     ,round(avg(OurTotalLine), 2) as OurTotalLine
      ,round(avg([LineDiffResultReg]), 2) as LineDiffResultReg

		, Sum( Case
			When PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as Wins
		  
		, Sum( Case
			When PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as Losses

		, Sum( Case
			When mr.Play = 'Under' THEN 1
			ELSE 0
		  END) as Unders

		, Sum( Case
			When mr.Play = 'Over' THEN 1
			ELSE 0
		  END) as Overs

		, Sum( Case
			When mr.Play = 'Under'  AND mr.PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as UnderWins

		, Sum( Case
			When mr.Play = 'Under'  AND mr.PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as UnderLosses

		, Sum( Case
			When mr.Play = 'Over'  AND mr.PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as OverWins
		, Sum( Case
			When mr.Play = 'Over'  AND mr.PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as OverLosses

 --     ,[PlayResult]
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] mr
 --  Where mr.Play = 'Over'
  ) x

  select convert(Time(0), getdate()) as EndTime,  DateDiff(MINUTE, @StartTime, getdate()) as DurationMins