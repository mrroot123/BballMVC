/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

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
		--	AND LeagueName = 'nba'
			AND GameDate > '7/24/2020'
		 Group by LeagueName, Team
	--	
		 ) q1
 ) q2
	JOIN (Select 'DAL' as Team) ts ON ts.team = q2.Team

	  Order by LeagueName, ScoreReg desc



	 return
	 -- Uta stats

	 /****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

Select  'UTA'
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
		AND LeagueName = 'nba'
		AND Team = 'UTA'
		Order by GameDate desc
	) q1

		SELECT TOP (5) 
			[LeagueName], Team, GameDate
			,[ScoreReg]      ,[ScoreRegUs]      ,[ScoreRegOp]
			,[ShotsActualMadeUsPt1]      ,[ShotsActualMadeUsPt2]      ,[ShotsActualMadeUsPt3]
			,[ShotsActualMadeOpPt1]      ,[ShotsActualMadeOpPt2]      ,[ShotsActualMadeOpPt3]
	  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
	  Where Exclude = 0
		AND LeagueName = 'nba'
		AND Team = 'UTA'
		Order by GameDate desc