USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertDailySummary]    Script Date: 9/19/2020 6:49:31 PM ******/
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
-- 06/27/2020	Keith Doran		Added TS column to Insert
-- 07/05/2020	Keith Doran		Added udfCalcSubSeasonPeriod, AdjRecentLeagueHistory and UserName as IP parm
-- ==================================================================
-- EXEC uspInsertDailySummary 'Test', '9/18/2020', 'NBA'
Declare @UserName varchar(10) = 'Test', @GameDate Date, @LeagueName varchar(10) = 'NBA'

	Set @GameDate = convert(Date, Getdate())

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
	Insert @SeasonInfoTable Exec [dbo].[uspQuerySeasonInfo]  @GameDate , @LeagueName 
	Select @Season = Season, @SubSeason = SubSeason from @SeasonInfoTable


	Declare @LgGamesBack int = dbo.udfQueryLeagueGamesBack( @GameDate, @LeagueName)	-- select dbo.udfQueryLeagueGamesBack( GetDate(), 'NBA')

	set @LgGamesBack = 60;

	Declare @LgAvgLastMinPt1 float = 1.0, @LgAvgLastMinPt2 float = .6, @LgAvgLastMinPt3 float = .2;

	Declare @BoxScoresLast5Min_GameDate Date = @GameDate
	Declare @BoxScoresLast5Min_MinDate Date = (Select Min(GameDate) From  BoxScoresLast5Min Where  LeagueName = @LeagueName  )
	IF NOT @BoxScoresLast5Min_MinDate is Null
	BEGIN
		if @GameDate < DateADD(yyyy, 1, @BoxScoresLast5Min_MinDate)
			Set @BoxScoresLast5Min_GameDate = DateADD(yyyy, 1, @BoxScoresLast5Min_MinDate)

		Select  @LgAvgLastMinPt1 = AVG(Q4Last1MinUsPt1) 
				, @LgAvgLastMinPt2 = AVG(Q4Last1MinUsPt2) 
				, @LgAvgLastMinPt3 = AVG(Q4Last1MinUsPt3) 
		from BoxScoresLast5Min Where  LeagueName = @LeagueName  
			AND Venue = 'Home'  -- Constant
			AND GameDate Between DATEADD(yyyy,-1, @BoxScoresLast5Min_GameDate) AND @BoxScoresLast5Min_GameDate
	END



	--INSERT INTO [dbo].[DailySummary]
 --  (
	---- 1 / 6
	--	[GameDate]						,[LeagueName]					,[Season]					 ,[SubSeason]           
	--	,[SubSeasonPeriod]
 --     ,[NumOfMatchups]      

	---- 2/5	     
	--	,[LgAvgStartDate]          ,[LgAvgGamesBack]        
	--	,[LgAvgScoreAway],[LgAvgScoreHome]
	--	,[LgAvgScoreFinal]
	---- 3/6
 --     ,[LgAvgShotsMadeAwayPt1]   ,[LgAvgShotsMadeAwayPt2]   ,[LgAvgShotsMadeAwayPt3]
 --     ,[LgAvgShotsMadeHomePt1]   ,[LgAvgShotsMadeHomePt2]   ,[LgAvgShotsMadeHomePt3]
	---- 4/6
	--	,LgAvgTurnOversAway, LgAvgTurnOversHome
	--	,LgAvgOffRBAway,	LgAvgOffRBHome
	--	,LgAvgAssistsAway, LgAvgAssistsHome
	---- 5/6
 --     ,[LgAvgLastMinPts]         ,[LgAvgLastMinPt1]         ,[LgAvgLastMinPt2]        ,[LgAvgLastMinPt3]
	--	,AdjRecentLeagueHistory
	--	, TS
	--)
Declare @StartDate date = '7/22/2020'
		
	SELECT 
	-- 1/6
		@GameDate	,@LeagueName	,@Season	,@SubSeason		
		,dbo.udfCalcSubSeasonPeriod(@GameDate, @LeagueName)
	, (Select Count(*) / 2 From Rotation Where LeagueName = @LeagueName AND GameDate = @GameDate)
	-- 2/5
	, Min(x.GameDate) as LgAvgStartDate	, Count(*) as LgAvgGamesBack	
	, AVG(x.ScoreRegOp) as LgAvgScoreAway	, AVG(x.ScoreRegUs) as LgAvgScoreHome
	, AVG(x.ScoreOT) as LgAvgScoreFinal
	-- 3/6
	, AVG(x.ShotsMadeOpRegPt1) as LgAvgShotsMadeAwayPt1 	, AVG(x.ShotsMadeOpRegPt2) as LgAvgShotsMadeAwayPt2 	, AVG(x.ShotsMadeOpRegPt3) as LgAvgShotsMadeAwayPt3 
	, AVG(x.ShotsMadeUsRegPt1) as LgAvgShotsMadeHomePt1 	, AVG(x.ShotsMadeUsRegPt2) as LgAvgShotsMadeHomePt2  	, AVG(x.ShotsMadeUsRegPt3) as LgAvgShotsMadeHomePt3 


	-- 4/6
	, AVG(x.TurnOversOp) as LgAvgTurnOversAway 	, AVG(x.TurnOversUs) as LgAvgTurnOversHome
	, AVG(x.OffRBOp) as LgAvgOffRBAway 	, AVG(x.OffRBUs) as LgAvgOffRBHome	
	, AVG(x.AssistsOp) as LgAvgAssistsAway 	, AVG(x.AssistsUs) as LgAvgAssistsHome 	

	-- 5/6
--	,  Min(lm.GameDate) as LastMinStartDate
	, ( @LgAvgLastMinPt1 + @LgAvgLastMinPt2 * 2.0 +  @LgAvgLastMinPt3 * 3.0 ) * 2 as LgAvgLastMinPts
	, @LgAvgLastMinPt1 as LgAvgLastMinPt1
	, @LgAvgLastMinPt2 as LgAvgLastMinPt2
	, @LgAvgLastMinPt3 as LgAvgLastMinPt3
	, dbo.udfAdjustmentRecentLeagueHistory(@UserName,  @GameDate, @LeagueName)
	, GETDATE()
	 FROM  (
		SELECT TOP (@LgGamesBack) b.* 
		 FROM BoxScores b 
			WHERE b.Exclude = 0
			AND b.LeagueName = @LeagueName  
			AND b.Venue = 'Home'  -- Constant
			AND b.GameDate < @GameDate

			AND b.GameDate > IsNull(@StartDate, '1/1/2000')

			--AND b.Season = @Season
			AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
			AND b.Source <> @Seeded

			Order by b.GameDate desc
		) x 


end