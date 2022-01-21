  use [00TTI_LeagueScores]
  go
/*
Checkpoint is a process that writes current in-memory dirty pages (modified pages) 
   and transaction log records to physical disk. In SQL Server checkpoints are used to reduce the time
	 required for recovery in the event of system failure. Checkpoint is regularly issued for each database.
*/
  CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO
/*
Update UserLeagueParms
  Set TeamAdjPct = 0.0
	, TMUPsWeightLgAvgGB1 = 1
	, TMUPsWeightLgAvgGB2 = 2
	, TMUPsWeightLgAvgGB3 = 3
 where StartDate = '10/2/2019'


 select TeamAdjPct, * from UserLeagueParms
 where StartDate = '10/2/2019'
 for JSON Auto
 */
select * from UserLeagueParms
 where StartDate = '10/2/2019'
--> scrRunTMs Analysis
SET NOCOUNT ON
Declare @ScriptName varchar(20) = 'scrRunTMs'

  Declare @UserName	varchar(10) = 'Test'
			, @LeagueName varchar(8) = 'NBA'
			, @GameDate Date
			, @StartDate Date 
			, @EndDate Date
			, @Display bit = 0	-- Set to 1 to display TodaysMatchups
			, @RunDate char(8) = convert(varchar, Getdate(),1) --  1=mm/dd/yy  5=dd-mm-yy
			, @RunCtr int = 0
			, @RunID varChar(10)	-- mm/dd/yy-n	n=0 or greater for that day / day iteration number 
  ;

-- Gen @RunID (mm/dd/yy-n)
 While 1 < 2
 Begin
	Set @RunID = concat(@RunDate, '-', convert(Varchar, @RunCtr))
	if Not Exists (Select * from AnalysisResults Where RunID = @RunID)
		Break;
	Set @RunCtr = @RunCtr + 1
End
 -- TEST select @Runid as RunID; return

--SELECT @StartDate =   Min([StartDate])
--  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
--  where season = '18' And Bypass = 0


--Set @GameDate = @StartDate
--Set @GameDate = DateAdd(d,1, @GameDate)

--Set @StartDate = '12/1/2017'
--Set @EndDate =   '12/2/2017' --'4/15/2018' --  DateAdd(d,15, @GameDate) '12/2/2017' --
--Set @GameDate =  @StartDate 

Declare @RunTodays bit = 0			-- 1 = @RunTodays games only  -----------------  TODAYS GAMES ------------
If @RunTodays = 1
BEGIN
	Set @Display = 0;
	Set @GameDate = CONVERT(date, getdate()); Set @EndDate = @GameDate;
END

Declare @GameDefaultOTamt float = 2 * ( Select TOP 1 DefaultOTamt From LeagueInfo 
											WHERE LeagueName = @LeagueName AND StartDate < GetDate() 
											Order by StartDate Desc) ;
Declare @StartTime dateTime = GetDate(), @EndTime DateTime

Declare @LoopHA int, @LoopDate int, @LoopGB int, @EndYear int, @LoopGBStart int, @LoopGBLimit int, @LoopHALimit int
	, @Description varchar(25) = ''

Set @StartDate = '11/28/2019'
Set @EndDate =    GetDate()	--
Set @EndYear = 2020
Set @LoopGBStart = 0
Set @LoopGBLimit = 1	-- Loop once
Set @LoopHALimit = 1	-- 2 for both 
Set @Description = 'TMUPsWeightLgAvg 1 to 1, TeamAdjPct now zero'

--Update UserLeagueParms
--	Set GB1 = 3
--	  , GB2 = 5
--	  , GB3 = 7
--	Where UserLeagueParmsID =
-- (
-- Select top 1 UserLeagueParmsID from UserLeagueParms 
--	where LeagueName = @LeagueName and StartDate <= @GameDate
--	Order by StartDate Desc
--	)

--Set @StartDate = '12/1/2019'
--Set @EndDate =   '3/12/2020'
--						--	
While Year(@StartDate) <  @EndYear
BEGIN -- LoopDate 
	Set @LoopGB = @LoopGBStart
	While @LoopGB <  @LoopGBLimit
	BEGIN -- LoopGB
		--Update UserLeagueParms 
		--	Set GB1 = @LoopGB
		--	  , GB2 = @LoopGB * 2
		--	  , GB3 = @LoopGB * 3
		--	Where UserName = @UserName		
		

		Set @LoopHA = 0
		While @LoopHA <	1	-- @LoopHALimit
		BEGIN -- LoopHA
			--Update UserLeagueParms 
			--	Set BothHome_Away =  @LoopHA	
			--	Where UserName = @UserName
			---------------
			-- Main Loop ------------------------------------------------------------
			---------------
			Set @StartTime = GETDATE();
			Set @GameDate = @StartDate
			Select '============ NEW ITERATION =============================================', @ScriptName
			Select @StartDate as StartDate, @EndDate as EndDate, convert(Time(0), @StartTime) as StartTime,  @LoopGB as GamesBack, @LoopHA as BothHA
			set @Display = 03; 			--kd
			While @GameDate <= @EndDate	
			BEGIN	-- Date Loop
			 --  Select  CAST( GETDATE() AS time(0)) AS 'time', @GameDate as GameDate,  @StartDate as StartDate, @EndDate as EndDate, convert(Time(0), @StartTime) as StartTime,  @LoopGB as GamesBack, @LoopHA as BothHA
				print @GameDate
				exec uspCalcTodaysMatchups  @UserName, @LeagueName, @GameDate, @Display
				Set @GameDate = DateAdd(d,1, @GameDate)
				set @Display = 0
				--break
				--print 'done'
				--return	-- kd
			END
			Set @EndTime = GETDATE();
			Exec  uspInsertAnalysisResults @RunID, @UserName, @LeagueName
						, @StartDate, @EndDate, @StartTime, @EndTime 
						, @GameDefaultOTamt , @Description
			
			Set @LoopHA = @LoopHA + 1;
		END	-- LoopHA
		Set @LoopGB = @LoopGB + 2
	End -- LoopGB


	Set @StartDate = DateAdd(YYYY, 1,@StartDate)
	Set @EndDate	= DateAdd(YYYY, 1,@EndDate)

END -- LoopDate 

Select @RunID as RunID, @Description as Description
EXEC uspQueryAnalysisResults @RunID

--EXEC uspQueryAnalysisResults '09/15/20'
-- Truncate Table AnalysisResults
