			   SElect 
					[Date] as GameDate, [Order] as RotNum, H_A as Venue, (ScReg + ScRegOpp) as ScoreReg, ScReg as ScoreRegUs, ScRegOpp as ScoreRegOp, *
				  FROM [00TTI_LeagueScores_V1].[dbo].[BoxScores] 
