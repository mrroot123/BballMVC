/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

Declare @LeagueName VarChar(4) = 'WNBA', @Team varchar(4) = 'SEA', @Team2 varchar(4) = 'SEA'
Set @LeagueName  = 'NBA'
Set @Team = 'MIA'
Set @Team2 = 'BOS'

Select top 1 *
  FROM [00TTI_LeagueScores].[dbo].[DailySummary]
  where LeagueName = @LeagueName 
  order by GameDate desc


Select q2.*
FROM(

	Select q1.*

		FROM(
		SELECT 
				[LeagueName], Team
		,Round(Avg([ScoreReg]),1) as [ScoreReg]
		,Round(Avg([ScoreRegUs]),1) as [ScoreRegUs]
		,Round(Avg([ScoreRegOp]),1) as [ScoreRegOp]
		, Count(*) as Games
		, Min(GameDate) as Start	, Max(GameDate) as EndDate

				--,[ScoreReg]      ,[ScoreRegUs]      ,[ScoreRegOp]
				--,[ShotsActualMadeUsPt1]      ,[ShotsActualMadeUsPt2]      ,[ShotsActualMadeUsPt3]
				--,[ShotsActualMadeOpPt1]      ,[ShotsActualMadeOpPt2]      ,[ShotsActualMadeOpPt3]
		  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
		  Where Exclude = 0
			AND LeagueName = @LeagueName
			AND GameDate > '9/2/2020'
		 Group by LeagueName, Team
	--	
		 ) q1
 ) q2
	JOIN (Select @Team as Team) ts ON ts.team = q2.Team

	  Order by LeagueName, ScoreReg desc



	-- return
	 -- Uta stats

	 /****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

Select  @Team2
	,Round(Avg([ScoreReg]),1) as [ScoreReg]
	,Round(Avg([ScoreRegUs]),1) as [ScoreRegUs]
	,Round(Avg([ScoreRegOp]),1) as [ScoreRegOp]
	, Count(*) as Games
	, Min(GameDate) as Start	, Max(GameDate) as EndDate

  From (
	SELECT TOP (5) *
			--[LeagueName]
			--,[ScoreReg]      ,[ScoreRegUs]      ,[ScoreRegOp]
			--,[ShotsActualMadeUsPt1]      ,[ShotsActualMadeUsPt2]      ,[ShotsActualMadeUsPt3]
			--,[ShotsActualMadeOpPt1]      ,[ShotsActualMadeOpPt2]      ,[ShotsActualMadeOpPt3]
	  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
	  Where Exclude = 0
			AND LeagueName = @LeagueName
			AND Team = @Team2
		Order by GameDate desc
	) q1

		SELECT TOP (5) 
			[LeagueName], GameDate, SubSeason, Team, Opp
			,[ScoreReg]      ,[ScoreRegUs]      ,[ScoreRegOp]
			,[ShotsActualMadeUsPt1]      ,[ShotsActualMadeUsPt2]      ,[ShotsActualMadeUsPt3]
			,[ShotsActualMadeOpPt1]      ,[ShotsActualMadeOpPt2]      ,[ShotsActualMadeOpPt3]
	  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
	  Where Exclude = 0
			AND LeagueName = @LeagueName
			AND Team = @Team2
			AND GameDate > '9/2/2020'
		Order by GameDate desc