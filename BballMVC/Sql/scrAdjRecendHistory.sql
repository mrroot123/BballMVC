use [00TTI_LeagueScores]

		Declare @GamesBack int = 45
				,  @GameDate Date = '1/1/2019', @LeagueName varchar(10) = 'NBA'
				, @AdjOtWithSide float = 1.4
				, @Diff float = 0.0
				, @ctrDiff float = 0.0
				, @Adj float = 0.0
				, @AdjPct float = .2
				, @OurTotalLine float , @TotalLine float , @ScoreRegWotAdj float 

	WHILE @GameDate < '05/01/2019'
	BEGIN
		Select q2.OurTotalLine, q2.TotalLine, q2.ScoreRegWotAdj
			, Round(Abs(q2.TotalLine - q2.ScoreRegWotAdj) - Abs(q2.OurTotalLine - q2.ScoreRegWotAdj), 2) as Diff
			
		  From (
			Select 
				Round(AVG( q1.OurTotalLine), 2) as OurTotalLine
				,Round(AVG( q1.TotalLine), 2) as TotalLine
				,Round(AVG( q1.ScoreRegWotAdj), 2) as ScoreRegWotAdj
			 From (
				SELECT Top (@GamesBack) OurTotalLine, TotalLine, ScoreReg + @AdjOtWithSide as ScoreRegWotAdj
					From TodaysMatchupsResults mr
					Where mr.LeagueName = @LeagueName
					  AND mr.GameDate < @GameDate
					  and mr.ScoreReg > 0 and mr.TotalLine > 0 and OurTotalLine > 0
					  order by mr.GameDate desc
					) q1
				) q2

		Select @OurTotalLine = q2.OurTotalLine, @TotalLine = q2.TotalLine, @ScoreRegWotAdj = q2.ScoreRegWotAdj
			,@Diff = Round(Abs(q2.TotalLine - q2.ScoreRegWotAdj) - Abs(q2.OurTotalLine + @adj - q2.ScoreRegWotAdj), 2) 
			
		  From (
			Select 
				Round(AVG( q1.OurTotalLine), 2) as OurTotalLine
				,Round(AVG( q1.TotalLine), 2) as TotalLine
				,Round(AVG( q1.ScoreRegWotAdj), 2) as ScoreRegWotAdj
			 From (
				SELECT Top (@GamesBack) OurTotalLine, TotalLine, ScoreReg + @AdjOtWithSide as ScoreRegWotAdj
					From TodaysMatchupsResults mr
					Where mr.LeagueName = @LeagueName
					  AND mr.GameDate < @GameDate
					  and mr.ScoreReg > 0 and mr.TotalLine > 0 and OurTotalLine > 0
					  order by mr.GameDate desc
					) q1
				) q2

	Select @Diff

		Set @ctrDiff = @ctrDiff + @Diff
		Set @Adj = (@TotalLine - @OurTotalLine) * @AdjPct

		Set @GameDate = DATEADD(D, 1, @GameDate)
	END

	Select Round(@ctrDiff / 120, 2) as DiffAvg , @ctrDiff as ctrDiff