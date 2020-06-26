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


SELECT @StartDate =   Min([StartDate])
  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
  where season = '1819' And Bypass = 0


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

Declare @LoopHA int, @LoopDate int, @LoopGB int

Set @StartDate = '12/1/2016'
Set @EndDate =   '4/15/2017' 
						--	Set @EndDate = @StartDate

While Year(@StartDate) <  2020
BEGIN -- LoopDate 
	Set @LoopGB = 2
	While @LoopGB < 7
	BEGIN -- LoopGB
		Update UserLeagueParms 
			Set GB1 = @LoopGB
			  , GB2 = @LoopGB * 2
			  , GB3 = @LoopGB * 3
			Where UserName = @UserName		
		

		Set @LoopHA = 0
		While @LoopHA < 2
		BEGIN -- LoopHA
			Update UserLeagueParms 
				Set BothHome_Away =  @LoopHA	
				Where UserName = @UserName
			---------------
			-- Main Loop --
			---------------
			Set @StartTime = GETDATE();
			Set @GameDate = @StartDate
			
			Select @StartDate as StartDate, @EndDate as EndDate, convert(Time(0), @StartTime) as StartTime,  @LoopHA as BothHA

			While @GameDate <= @EndDate
			BEGIN
				exec uspCalcTodaysMatchups  @UserName, @LeagueName, @GameDate, @Display
				Set @GameDate = DateAdd(d,1, @GameDate)
				set @Display = 0
				--return
			END
			Set @EndTime = GETDATE();
			INSERT INTO [dbo].[AnalysisResults]
					(
					  [TS]   ,[RunDurationMinutes]
 						, Games, Plays
					 ,[LeagueName]           ,[StartDate]           ,[EndDate]
					 ,DefaultOTamt
					  ,[GB1]							,[GB2]						,[GB3]
					  ,[WeightGB1]           ,[WeightGB2]           ,[WeightGB3]
					  ,[Threshold]           ,[BxScLinePct]           ,[BxScTmStrPct]           ,[TmStrAdjPct]
					  ,[BothHome_Away]
					  ,[Wins]           ,[Losses]
					  ,   WLPct
					  ,[Unders]           ,[Overs]
					  ,[UnderWins]           ,[UnderLosses],   UnderPct
					  ,[OverWins]            ,[OverLosses],	OverPct
					  ,[Description]
					  , AvgScoreReg, AvgScoreRegwOT, AvgTotalLine, AvgOurTotalLine, AvgLineDiffResultReg
					 )
			Select 
				GETDATE(),  DateDiff(MINUTE, @StartTime, @EndTime)
				, Games, Plays
				,@LeagueName, @StartDate, @EndDate
				,@GameDefaultOTamt / 2
				,u.[GB1]      ,u.[GB2]      ,u.[GB3]
				,u.[WeightGB1]      ,u.[WeightGB2]      ,u.[WeightGB3]
				,u.[Threshold]      ,u.[BxScLinePct]      ,u.[BxScTmStrPct]      ,u.[TmStrAdjPct]
				,u.[BothHome_Away]
				, (overWins+UnderWins) as Wins, (overLosses+UnderLosses) as Losses
				, dbo.udfDivide( OverWins+UnderWins, OverWins+UnderWins + overLosses+UnderLosses) * 100.0 as WLPct
				, Unders, Overs
				, UnderWins,	UnderLosses, dbo.udfDivide( UnderWins, UnderLosses+UnderWins) * 100.0 as UnderPct
				, OverWins, OverLosses, dbo.udfDivide( OverWins, OverLosses+OverWins) * 100.0 as OverPct
				, ''
				, AvgScoreReg, AvgScoreRegwOT, AvgTotalLine, AvgOurTotalLine, AvgLineDiffResultReg
			From [UserLeagueParms] u
			 Join (
				Select 
					(Select count(*) From [TodaysMatchupsResults]) as Games
	 				,count(*) as Plays

			  ,round(avg(ScoreReg), 2) as AvgScoreReg
			  ,round(avg(ScoreReg), 2) + @GameDefaultOTamt as 'AvgScoreRegwOT'
			  ,round(avg(TotalLine), 2) as AvgTotalLine
			  ,round(avg(OurTotalLine), 2) as AvgOurTotalLine
				,round(avg([LineDiffResultReg]), 2) as AvgLineDiffResultReg

				, Sum(tmr.UnderWin) + Sum(tmr.UnderLoss) as Unders		, Sum(tmr.OverWin) + Sum(tmr.OverLoss) as Overs
				, Sum(tmr.UnderWin) as UnderWins		, Sum(tmr.UnderLoss) as UnderLosses
				, Sum(tmr.OverWin) as OverWins		, Sum(tmr.OverLoss) as OverLosses

				 From [TodaysMatchupsResults] tmr 
				  Where tmr.LeagueName = @LeagueName  AND  tmr.GameDate Between @StartDate and @EndDate
					AND tmr.Play > ' '
				 ) mr on 1 = 1
				Where u.UserName = 'Test'

			Set @LoopHA = @LoopHA + 1;
		END	-- LoopHA
		Set @LoopGB = @LoopGB + 2
	End -- LoopGB
	Set @StartDate = DateAdd(YYYY, 1,@StartDate)
	Set @EndDate	= DateAdd(YYYY, 1,@EndDate)
END -- LoopDate 

Select * From AnalysisResults

