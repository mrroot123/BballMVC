/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

-- select * from BoxScores where exclude = 1

SELECT TOP (200) [BoxScoresID]
      ,[LeagueName],[GameDate],[RotNum],[Team],[Opp],[Venue]

		-- Verify OUR / US scores
		-- 1) Verify QTRs vs Reg
		, ScoreQ1Us + ScoreQ2Us + ScoreQ3Us + ScoreQ4Us as 'QtrsTotUs-->'
      ,[ScoreRegUs] as '<--ScoreRegUs'
		-- 2) Verify Total Pts vs Final
		, ( ShotsActualMadeUsPt1 * 1 + ShotsActualMadeUsPt2 * 2 + ShotsActualMadeUsPt3 * 3 ) as 'TotalPtsUs-->'
      ,[ScoreOTUs]   as '<--ScoreOtUs'

		-- Verify QTRs vs Reg
		, ScoreQ1Op + ScoreQ2Op + ScoreQ3Op + ScoreQ4Op as 'QtrsTotOp-->'
      ,[ScoreRegOp] as '<--ScoreRegOp'
		-- Verify Total Pts vs Final
		, (
			ShotsActualMadeOpPt1 * 1 +
			ShotsActualMadeOpPt2 * 2 +
			ShotsActualMadeOpPt3 * 3 ) as 'TotalPtsOp-->'
      ,[ScoreOTOp]  as '<--ScoreOtOp'
/*
      ,[ScoreReg]
      ,[ScoreOT]
      ,[ScoreRegOp]
      ,[ScoreOTOp]
      ,[ScoreQ1Us]
      ,[ScoreQ1Op]
      ,[ScoreQ2Us]
      ,[ScoreQ2Op]
      ,[ScoreQ3Us]
      ,[ScoreQ3Op]
      ,[ScoreQ4Us]
      ,[ScoreQ4Op]
		*/
      ,[ShotsActualMadeUsPt1]      ,[ShotsActualMadeUsPt2]      ,[ShotsActualMadeUsPt3]      ,[ShotsActualMadeOpPt1]      ,[ShotsActualMadeOpPt2]      ,[ShotsActualMadeOpPt3]      
		,[ShotsActualAttemptedUsPt1],[ShotsActualAttemptedUsPt2],[ShotsActualAttemptedUsPt3],[ShotsActualAttemptedOpPt1],[ShotsActualAttemptedOpPt2],[ShotsActualAttemptedOpPt3]
		/*
      ,[ShotsMadeUsRegPt1]
      ,[ShotsMadeUsRegPt2]
      ,[ShotsMadeUsRegPt3]
      ,[ShotsMadeOpRegPt1]
      ,[ShotsMadeOpRegPt2]
      ,[ShotsMadeOpRegPt3]
      ,[ShotsAttemptedUsRegPt1]
      ,[ShotsAttemptedUsRegPt2]
      ,[ShotsAttemptedUsRegPt3]
      ,[ShotsAttemptedOpRegPt1]
      ,[ShotsAttemptedOpRegPt2]
      ,[ShotsAttemptedOpRegPt3]
      ,[TurnOversUs]
      ,[TurnOversOp]
      ,[OffRBUs]
      ,[OffRBOp]
      ,[AssistsUs]
      ,[AssistsOp]
      ,[Source]
      ,[LoadDate]
      ,[LoadTimeSeconds]
*/
  FROM   (	Select * From BoxScores  where Source <> 'Seeded') b
   where exclude <= 01
	  AND (
					   ScoreQ1Us + ScoreQ2Us + ScoreQ3Us + ScoreQ4Us  <> [ScoreRegUs]
				OR  ( ShotsActualMadeUsPt1 * 1 + ShotsActualMadeUsPt2 * 2 + ShotsActualMadeUsPt3 * 3 ) <> [ScoreOTUs] 
				OR	   ScoreQ1Op + ScoreQ2Op + ScoreQ3Op + ScoreQ4Op  <> [ScoreRegOp]
				OR  ( ShotsActualMadeOpPt1 * 1 + ShotsActualMadeOpPt2 * 2 + ShotsActualMadeOpPt3 * 3 ) <> [ScoreOTOp] 
			)
--		AND Gamedate = '12-26-2019' 	 and team in ('MIN', 'SAC')
  order by gamedate desc
 -- return
  Select * From BoxScores_NEW
  Where 
   (GameDate = '2020-01-31' AND RotNum = 507)
 OR (GameDate = '2020-01-31' AND RotNum = 508)
 OR (GameDate = '2020-01-28' AND RotNum = 543)
 OR (GameDate = '2020-01-28' AND RotNum = 544)
 OR (GameDate = '2020-01-06' AND RotNum = 533)
 OR (GameDate = '2020-01-06' AND RotNum = 534)
 OR (GameDate = '2019-12-26' AND RotNum = 533)
 OR (GameDate = '2019-12-26' AND RotNum = 534)
 OR (GameDate = '2019-04-05' AND RotNum = 531)
 OR (GameDate = '2019-04-05' AND RotNum = 532)

