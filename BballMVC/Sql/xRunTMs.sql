  use [00TTI_LeagueScores]
  go

  CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

SET NOCOUNT ON

  Declare @UserName	varchar(10) = 'Test'
			, @LeagueName varchar(8) = 'NBA'
			, @GameDate Date
			, @StartDate Date 
			, @EndDate Date
			, @Display bit = 0	-- Set to 1 to display TodaysMatchups
			, @RunID nchar(10) = convert(varchar, Getdate(),1) --  1=mm/dd/yy  5=dd-mm-yy
  ;


SELECT @StartDate =   Min([StartDate])
  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
  where season = '18' And Bypass = 0


Set @GameDate = @StartDate
Set @GameDate = DateAdd(d,1, @GameDate)

Set @StartDate = '12/1/2017'
Set @EndDate =   '12/2/2017' --'4/15/2018' --  DateAdd(d,15, @GameDate) '12/2/2017' --
Set @GameDate =  @StartDate 

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

Set @StartDate = '2/1/2021'
Set @EndDate =   '2/27/2021' 
Set @EndYear = 2022
Set @LoopGBStart = 5
Set @LoopGBLimit = 6
Set @LoopHALimit = 1	-- 2 for both 

--Set @StartDate = '12/1/2019'
--Set @EndDate =   '3/12/2020'
--						--	
While Year(@StartDate) <  @EndYear
BEGIN -- LoopDate 
	Set @LoopGB = @LoopGBStart
	While @LoopGB < @LoopGBLimit
	BEGIN -- LoopGB
		--Update UserLeagueParms 
		--	Set GB1 = @LoopGB
		--	  , GB2 = @LoopGB * 2
		--	  , GB3 = @LoopGB * 3
		--	Where UserName = @UserName		
		

		Set @LoopHA = 0
		While @LoopHA < @LoopHALimit
		BEGIN -- LoopHA
			--Update UserLeagueParms 
			--	Set BothHome_Away =  @LoopHA	
			--	Where UserName = @UserName
			---------------
			-- Main Loop ------------------------------------------------------------
			---------------
			Set @StartTime = GETDATE();
			Set @GameDate = @StartDate
			Select '============ NEW ITERATION ============================================='
		--	Select @StartDate as StartDate, @EndDate as EndDate, convert(Time(0), @StartTime) as StartTime,  @LoopGB as GamesBack, @LoopHA as BothHA
			set @Display = 0; 			--kd
			While @GameDate <= @EndDate
			BEGIN
			   Select  CAST( GETDATE() AS time(0)) AS 'time', @GameDate as GameDate,  @StartDate as StartDate, @EndDate as EndDate, convert(Time(0), @StartTime) as StartTime,  @LoopGB as GamesBack, @LoopHA as BothHA
				print @GameDate
				exec uspCalcTodaysMatchups  @UserName, @LeagueName, @GameDate, @Display
				Set @GameDate = DateAdd(d,1, @GameDate)
				set @Display = 0
				--break
				--return	-- kd
			END
			Set @EndTime = GETDATE();
			Exec  uspInsertAnalysisResults @RunID, @UserName, @LeagueName
						, @StartDate, @EndDate, @StartTime, @EndTime 
						, @GameDefaultOTamt 
			
			Set @LoopHA = @LoopHA + 1;
		END	-- LoopHA
		Set @LoopGB = @LoopGB + 2
	End -- LoopGB


	Set @StartDate = DateAdd(YYYY, 1,@StartDate)
	Set @EndDate	= DateAdd(YYYY, 1,@EndDate)

END -- LoopDate 

Select @RunID as RunID
EXEC uspQueryAnalysisResults @RunID

EXEC uspQueryAnalysisResults '09/15/20'
-- Truncate Table AnalysisResults
