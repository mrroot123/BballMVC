use [00TTI_LeagueScores]

--EXEC XuspInsertDailySummary 'Test', '12/19/2019', 'NBA', '1/1/2019', 1

--
/*

Declare @GameDate Date = '11/01/2019'
Delete  from DailySummary where GameDate =  @GameDate
Select 'Dsum row after delete', * from DailySummary where GameDate =  @GameDate
EXEC uspInsertDailySummary 'Test', @GameDate, 'NBA', '1/1/2019', 01
Select 'DailySummary row', * from DailySummary where GameDate =  @GameDate

*/
	SELECT 'Q2 Avg row'
	-- 1/6
--		@GameDate	,@LeagueName	,@Season	,@SubSeason		
--		,dbo.udfCalcSubSeasonPeriod(@GameDate, @LeagueName)
--	, (Select Count(*) / 2 From Rotation Where LeagueName = @LeagueName AND GameDate = @GameDate)
----	-- 2/10
--	, @LgAvgStartDate
	, Min(x.GameDate) as ActualStartDate	
	,Max(x.GameDate) as ActualEndDate	
--, @LgGamesBack as LgAvgGamesBack, Count(*) as ActualGamesBack	
	, AVG(x.ScoreRegOp) as LgAvgScoreAway	, AVG(x.ScoreRegUs) as LgAvgScoreHome
	, AVG(x.ScoreOT) as LgAvgScoreFinal
	, AVG(x.TotalLine) as LgAvgTotalLine
	, AVG(x.OurTotalLine) as LgAvgOurTotalLine
	-- 3/6
	, AVG(x.ShotsMadeOpRegPt1) as LgAvgShotsMadeAwayPt1 	, AVG(x.ShotsMadeOpRegPt2) as LgAvgShotsMadeAwayPt2 	, AVG(x.ShotsMadeOpRegPt3) as LgAvgShotsMadeAwayPt3 
	, AVG(x.ShotsMadeUsRegPt1) as LgAvgShotsMadeHomePt1 	, AVG(x.ShotsMadeUsRegPt2) as LgAvgShotsMadeHomePt2  	, AVG(x.ShotsMadeUsRegPt3) as LgAvgShotsMadeHomePt3 

	-- 3B/6
	, AVG(x.ShotsAttemptedOpRegPt1) as LgAvgShotsAttemptedAwayPt1 	, AVG(x.ShotsAttemptedOpRegPt2) as LgAvgShotsAttemptedAwayPt2 	, AVG(x.ShotsAttemptedOpRegPt3) as LgAvgShotsAttemptedAwayPt3 
	, AVG(x.ShotsAttemptedUsRegPt1) as LgAvgShotsAttemptedHomePt1 	, AVG(x.ShotsAttemptedUsRegPt2) as LgAvgShotsAttemptedHomePt2 	, AVG(x.ShotsAttemptedUsRegPt3) as LgAvgShotsAttemptedHomePt3 
	-- 3C/3
		
		, ( AVG(x.ShotsMadeOpRegPt2) + AVG(x.ShotsMadeUsRegPt2) + AVG(x.ShotsMadeOpRegPt3) + AVG(x.ShotsMadeUsRegPt3) )
		  / ( AVG(x.ShotsAttemptedOpRegPt2) + AVG(x.ShotsAttemptedUsRegPt2) + AVG(x.ShotsAttemptedOpRegPt3) + AVG(x.ShotsAttemptedUsRegPt3) )	as LgAvgShotPct
		, (AVG(x.ShotsMadeOpRegPt2) + AVG(x.ShotsMadeUsRegPt2)) / (AVG(x.ShotsAttemptedOpRegPt2) + AVG(x.ShotsAttemptedUsRegPt2) )	as LgAvgShotPctPt2
		, (AVG(x.ShotsMadeOpRegPt3) + AVG(x.ShotsMadeUsRegPt3)) / (AVG(x.ShotsAttemptedOpRegPt3) + AVG(x.ShotsAttemptedUsRegPt3) )	as LgAvgShotPctPt3
	-- 4/6
	, AVG(x.TurnOversOp) as LgAvgTurnOversAway 	, AVG(x.TurnOversUs) as LgAvgTurnOversHome
	, AVG(x.OffRBOp) as LgAvgOffRBAway 	, AVG(x.OffRBUs) as LgAvgOffRBHome	
	, AVG(x.AssistsOp) as LgAvgAssistsAway 	, AVG(x.AssistsUs) as LgAvgAssistsHome 	

	-- 5/6

	--, ( @LgAvgLastMinPt1 + @LgAvgLastMinPt2 * 2.0 +  @LgAvgLastMinPt3 * 3.0 ) * 2 as LgAvgLastMinPts
	--, @LgAvgLastMinPt1 as LgAvgLastMinPt1
	--, @LgAvgLastMinPt2 as LgAvgLastMinPt2
	--, @LgAvgLastMinPt3 as LgAvgLastMinPt3
	--, dbo.udfAdjustmentRecentLeagueHistory(@UserName,  @GameDate, @LeagueName)


	 FROM  (

		SELECT TOP (150)
			 b.* 
			 , r.TotalLine		-- 01/24/2021
			 , IsNull(tm.OurTotalLine,  r.TotalLine) as OurTotalLine  -- 05/23/2021 02/18/2021
		 FROM BoxScores b 
		 JOIN Rotation r on r.GameDate = b.GameDate  AND r.RotNum = b.RotNum
		 Left JOIN TodaysMatchups tm on tm.GameDate = b.GameDate  AND tm.RotNum = b.RotNum - 1	-- 05/23/2021 b.RotNum is Home / Even, tm.RotNum is Odd
		 WHERE b.Exclude = 0
			AND b.LeagueName = 'NBA'  
			AND b.Venue = 'Home'  -- Constant
			AND b.GameDate < '2019-12-19'
			--AND  (b.Season = @Season OR @BoxscoresSpanSeasons = 1)	-- 12/27/2020
			AND ( b.SubSeason = '1-Reg' OR  b.SubSeason = '1-Reg' )
			AND b.Source <> 'Seeded'
			AND b.GameDate >= '2019-01-01'
			AND r.TotalLine > 0

			Order by b.GameDate desc, RotNum
) x
/*
GameDate	Season	LeagueName	BoxscoresSpanSeasons	SubSeason	LgAvgStartDate
2019-12-19	1920	NBA			1							1-Reg			2019-01-01

			  @LeagueName as LeagueName
			, @GameDate as GameDate
			, @Season as Season
			, @BoxscoresSpanSeasons as BoxscoresSpanSeasons
			, @SubSeason as  SubSeason
			, @LgAvgStartDate as LgAvgStartDate

			EXEC uspInsertDailySummary 'Test', '12/19/2019', 'NBA', '1/1/2019', 1	

 EXEC uspCalcTodaysMatchups 'Test', 'NBA', '12/19/2019', 4
*/