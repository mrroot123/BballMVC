

Select cOUNT(*) AS  Plays
	, Sum(UnderWin+OverWin) as Wins, Sum(UnderLoss+OverLoss) as Losses
	, Round( (Sum(UnderWin+OverWin) * 100.0) / Sum(UnderLoss+OverLoss+UnderWin+OverWin),2) as WinPct
	, Sum(UnderWin) as UnderWin, Sum(UnderLoss) as UnderLoss
	, Sum(OverWin) as OverWin, Sum(OverLoss) as OverLoss
	, Sum( LineDiffResultReg) as LineDiffResultRegSum ,  AVG( LineDiffResultReg) as LineDiffResultRegSumAvg
 from TodaysMatchupsResults
  Where PlayResult is not null
  and Season = '2122'
