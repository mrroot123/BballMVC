
UPDATE  TodaysPlays SET Result = null

UPDATE 
    TodaysPlays
SET --  ,[Result]   ,[OT]  ,[FinalScore] ,[ResultAmount] 
    TodaysPlays.Result = dbo.udfCalcOverUnderResult (tp.PlayDirection, b.ScoreOT, tp.Line)

	 , TodaysPlays.OT = dbo.udfCalcTodaysPlaysOT(b.ScoreReg, b.ScoreOT, tp.Line)
	 , TodaysPlays.FinalScore = b.ScoreOT
	 , TodaysPlays.ResultAmount = dbo.udfCalcTodaysPlaysResultAmount( dbo.udfCalcOverUnderResult (tp.PlayDirection, b.ScoreOT, tp.Line), tp.PlayAmount, tp.Juice)

FROM 
    TodaysPlays tp
    JOIN BoxScores b ON b.GameDate = tp.GameDate and b.RotNum = tp.RotNum
WHERE tp.Result is null and tp.GameDate < GetDate()
   
Select *    FROM [00TTI_LeagueScores].[dbo].[TodaysPlays] where Result is not  null
/*
						When b.ScoreOT > TodaysPlays.Line	Then -1	-- Over Loss
						When b.ScoreOT < TodaysPlays.Line	Then  1	-- Under Win
						Else 0
*/