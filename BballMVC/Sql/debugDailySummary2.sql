USE [00TTI_LeagueScores_HISTORY]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertDailySummary]    Script Date: 12/17/2021 6:03:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            06/15/2020
-- Description:            Insert one row in DailySummary
-- ==================================================================
-- Change History
-- ==================================================================
-- 06/27/2020	Keith Doran						Added TS column to Insert
-- 07/05/2020	Keith Doran						Added udfCalcSubSeasonPeriod, AdjRecentLeagueHistory and UserName as IP parm
-- 09/27/2020	Keith Doran						Added @LgAvgStartDate as parm and in query - will override games back
--														Added DailySummary columns - ActualStartDate & ActualGmesBack
--	12/25/2020	Keith Doran						Renamed DailySummary columns - ActualStartDate --> LgAvgStartDateActual, ActualGamesBack --> LgAvgGamesBackActual
--	12/27/2020	Keith Doran						Modified adding @BoxscoresSpanSeasons = 1 to --> (b.Season = @Season OR @BoxscoresSpanSeasons = 1)
-- 01/09/2021	Keith Doran						Added RotNum to GameDate sort order in Select
-- 01/24/2021	Keith Doran						Added LgAvgTotalLine
-- 01/26/2021	Keith Doran						Hardcoded Last min Pt values - 1.10  .52  .25
-- 01/30/2021	Keith Doran						Moved to Prod
-- 02/18/2021	Keith Doran		02/19/2021	Added 10 new Columns - LgAvgShotsAttemptedAwayPt1, 2, 3, Home & LgAvgShotPct, Pt2, Pt3, LgAvgOurTotalLine
-- 05/23/2021	Keith Doran		05/23/2021	In Query x (first query) Made TodaysMatchups Left JOIN, Defaulted via IsNull tm.OurTotalLine --> r.TotalLine
-- 05/25/2021	Keith Doran		05/25/2021	Added column LgAvgEndDateActual
-- ==================================================================
-- EXEC uspInsertDailySummary 'Test', '12/19/2019', 'NBA', '1/1/2019', 1


/*
EXEC XuspInsertDailySummary 'Test', '12/19/2019', 'NBA', '1/1/2019', 1
	Declare @UserName varchar(10), @GameDate Date, @LeagueName varchar(10), @LgAvgStartDate Date 
	set @UserName = 'Test'; set @Leaguename = 'NBA'; Set = @GameDate = Convert(Date, GetDate()); 	Set @LgAvgStartDate = Convert(Date, dateAdd(d, -14, GetDate()));
*/
alter PROCEDURE [dbo].[XuspInsertDailySummary] (@UserName varchar(10), @GameDate Date, @LeagueName varchar(10), @LgAvgStartDate Date, @Display int = 0 )
AS
	SET NOCOUNT ON;
              
	BEGIN  
	Declare @Seeded varchar(10) = 'Seeded';
	Declare @Season varchar(4) 
		, @SubSeason varchar(10) ;

	Declare @SeasonInfoTable Table (
		[StartDate] [date] NOT NULL,
		[EndDate] [date] NOT NULL,
		[Season] [nvarchar](4) NOT NULL,
		[SubSeason] [nvarchar](20) NOT NULL,
		[Bypass] [bit] NOT NULL,
		[IncludePre] [bit] NOT NULL,
		[IncludePost] [bit] NOT NULL,
		[BoxscoreSource] [nvarchar](21) NOT NULL
	)

	Insert @SeasonInfoTable Exec [dbo].[uspQuerySeasonInfo]  @GameDate , @LeagueName -- populate @SeasonInfoTable row
	Select @Season = Season, @SubSeason = SubSeason from @SeasonInfoTable
select '59' as spLineNum, @Season as Season

	Declare @LgGamesBack int = dbo.udfQueryLeagueGamesBack( @GameDate, @LeagueName, @UserName)	-- select dbo.udfQueryLeagueGamesBack( GetDate(), 'NBA')

-- 01/26/2021	Declare @LgAvgLastMinPt1 float = 1.0, @LgAvgLastMinPt2 float = .6, @LgAvgLastMinPt3 float = .2;
	Declare @LgAvgLastMinPt1 float = 1.10, @LgAvgLastMinPt2 float = .52, @LgAvgLastMinPt3 float = .25;	-- Hardcoded 01/26/2021

	Declare @BoxscoresSpanSeasons bit
	Select TOP 1
			 @BoxscoresSpanSeasons = BoxscoresSpanSeasons
		From UserLeagueParms u Where UserName = @UserName AND LeagueName = @LeagueName
			and u.StartDate <= @GameDate
			order by u.StartDate desc

	if @Display > 0
		Select  @LeagueName as LeagueName
			, @GameDate as GameDate
			, @Season as Season
			, @BoxscoresSpanSeasons as BoxscoresSpanSeasons
			, @SubSeason as  SubSeason
			, @LgAvgStartDate as LgAvgStartDate
			, @LgGamesBack as LgGamesBack

--------------------------------------------------
--
	SELECT 'Sel 1' as Q1,
	-- 1/6
		@GameDate	,@LeagueName	,@Season	,@SubSeason		
		,dbo.udfCalcSubSeasonPeriod(@GameDate, @LeagueName)
	, (Select Count(*) / 2 From Rotation Where LeagueName = @LeagueName AND GameDate = @GameDate)
--	-- 2/10
	, @LgAvgStartDate
--	, Min(x.GameDate) as ActualStartDate
--	,Max(x.GameDate) as ActualEndDate	
--, @LgGamesBack as LgAvgGamesBack, Count(*) as ActualGamesBack	
--	, AVG(x.ScoreRegOp) as LgAvgScoreAway	, AVG(x.ScoreRegUs) as LgAvgScoreHome
--	, AVG(x.ScoreOT) as LgAvgScoreFinal
--	, AVG(x.TotalLine) as LgAvgTotalLine
--	, AVG(x.OurTotalLine) as LgAvgOurTotalLine
--	-- 3/6
--	, AVG(x.ShotsMadeOpRegPt1) as LgAvgShotsMadeAwayPt1 	, AVG(x.ShotsMadeOpRegPt2) as LgAvgShotsMadeAwayPt2 	, AVG(x.ShotsMadeOpRegPt3) as LgAvgShotsMadeAwayPt3 
--	, AVG(x.ShotsMadeUsRegPt1) as LgAvgShotsMadeHomePt1 	, AVG(x.ShotsMadeUsRegPt2) as LgAvgShotsMadeHomePt2  	, AVG(x.ShotsMadeUsRegPt3) as LgAvgShotsMadeHomePt3 

--	-- 3B/6
--	, AVG(x.ShotsAttemptedOpRegPt1) as LgAvgShotsAttemptedAwayPt1 	, AVG(x.ShotsAttemptedOpRegPt2) as LgAvgShotsAttemptedAwayPt2 	, AVG(x.ShotsAttemptedOpRegPt3) as LgAvgShotsAttemptedAwayPt3 
--	, AVG(x.ShotsAttemptedUsRegPt1) as LgAvgShotsAttemptedHomePt1 	, AVG(x.ShotsAttemptedUsRegPt2) as LgAvgShotsAttemptedHomePt2 	, AVG(x.ShotsAttemptedUsRegPt3) as LgAvgShotsAttemptedHomePt3 
--	-- 3C/3
		
	--	, ( AVG(x.ShotsMadeOpRegPt2) + AVG(x.ShotsMadeUsRegPt2) + AVG(x.ShotsMadeOpRegPt3) + AVG(x.ShotsMadeUsRegPt3) )
	--	  / ( AVG(x.ShotsAttemptedOpRegPt2) + AVG(x.ShotsAttemptedUsRegPt2) + AVG(x.ShotsAttemptedOpRegPt3) + AVG(x.ShotsAttemptedUsRegPt3) )	as LgAvgShotPct
	--	, (AVG(x.ShotsMadeOpRegPt2) + AVG(x.ShotsMadeUsRegPt2)) / (AVG(x.ShotsAttemptedOpRegPt2) + AVG(x.ShotsAttemptedUsRegPt2) )	as LgAvgShotPctPt2
	--	, (AVG(x.ShotsMadeOpRegPt3) + AVG(x.ShotsMadeUsRegPt3)) / (AVG(x.ShotsAttemptedOpRegPt3) + AVG(x.ShotsAttemptedUsRegPt3) )	as LgAvgShotPctPt3
	---- 4/6
--	, AVG(x.TurnOversOp) as LgAvgTurnOversAway 	, AVG(x.TurnOversUs) as LgAvgTurnOversHome
--	, AVG(x.OffRBOp) as LgAvgOffRBAway 	, AVG(x.OffRBUs) as LgAvgOffRBHome	
--	, AVG(x.AssistsOp) as LgAvgAssistsAway 	, AVG(x.AssistsUs) as LgAvgAssistsHome 	

	-- 5/6

	, ( @LgAvgLastMinPt1 + @LgAvgLastMinPt2 * 2.0 +  @LgAvgLastMinPt3 * 3.0 ) * 2 as LgAvgLastMinPts
	, @LgAvgLastMinPt1 as LgAvgLastMinPt1
	, @LgAvgLastMinPt2 as LgAvgLastMinPt2
	, @LgAvgLastMinPt3 as LgAvgLastMinPt3
	, dbo.udfAdjustmentRecentLeagueHistory(@UserName,  @GameDate, @LeagueName)


	 FROM  (
 
		SELECT TOP (@LgGamesBack) 'xCols' as xCols,
			 b.* 
			 , r.TotalLine		-- 01/24/2021
			 , IsNull(tm.OurTotalLine,  r.TotalLine) as OurTotalLine  -- 05/23/2021 02/18/2021
		 FROM BoxScores b 
		 JOIN Rotation r on r.GameDate = b.GameDate  AND r.RotNum = b.RotNum
		 Left JOIN TodaysMatchups tm on tm.GameDate = b.GameDate  AND tm.RotNum = b.RotNum - 1	-- 05/23/2021 b.RotNum is Home / Even, tm.RotNum is Odd
		 WHERE b.Exclude = 0
			AND b.LeagueName = @LeagueName  
			AND b.Venue = 'Home'  -- Constant
			AND b.GameDate < @GameDate
			AND  (b.Season = @Season OR @BoxscoresSpanSeasons = 1)	-- 12/27/2020
			AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
			AND b.Source <> @Seeded
			AND b.GameDate >= @LgAvgStartDate
			AND r.TotalLine > 0

			Order by b.GameDate desc, RotNum
		) x 

	END
