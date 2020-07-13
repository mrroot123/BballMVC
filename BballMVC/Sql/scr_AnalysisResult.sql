@EndDate
@EndTime
@GameDefaultOTamt
@LeagueName  

@StartDate 
@StartTime
			INSERT INTO [dbo].[AnalysisResults]
					(
					  [TS], RunID   ,[RunDurationMinutes], Games, Plays					-- 1/5
					 ,[LeagueName]  ,[StartDate]   ,[EndDate],DefaultOTamt	-- 2/4
					  ,[GB1]				,[GB2]		,[GB3]							-- 3/3
					  ,[WeightGB1]    ,[WeightGB2],[WeightGB3]					-- 4/3
					  ,[Threshold]    ,[BxScLinePct] ,[BxScTmStrPct]  ,[TmStrAdjPct]	--5/4
					  ,[BothHome_Away] ,[Wins] ,[Losses]  ,   WLPct				-- 6/4
					  ,[Unders]           ,[Overs]									-- 7/2
					  ,[UnderWins]           ,[UnderLosses],   UnderPct		-- 8/3
					  ,[OverWins]            ,[OverLosses],	OverPct			-- 9/3
					  ,[Description]	--10/1
					  , AvgScoreReg, AvgScoreRegwOT, AvgTotalLine				-- 11/3
					  , AvgOurTotalLine, AvgLineDiffResultReg						-- 12/2
					 )
			Select 
				GETDATE(), @RunID,  DateDiff(MINUTE,@StartTime,@EndTime),   Games, Plays	-- 1/5
				,@LeagueName, @StartDate, @EndDate	,(@GameDefaultOTamt / 2)		-- 2/4
				,u.[GB1]      ,u.[GB2]      ,u.[GB3]										-- 3/3
				,u.[WeightGB1]      ,u.[WeightGB2]      ,u.[WeightGB3]				-- 4/3
				,u.[Threshold]      ,u.[BxScLinePct]      ,u.[BxScTmStrPct]      ,u.[TmStrAdjPct]	-- 5/4
				,u.[BothHome_Away]	-- 6.1
				, (overWins+UnderWins) as Wins, (overLosses+UnderLosses) as Losses	-- 6/2-3
				, dbo.udfDivide( OverWins+UnderWins, OverWins+UnderWins + overLosses+UnderLosses) * 100.0 as WLPct -- 6.4
				, Unders, Overs	--7/2
				, UnderWins,	UnderLosses, dbo.udfDivide( UnderWins, UnderLosses+UnderWins) * 100.0 as UnderPct -- 8/3
				, OverWins, OverLosses, dbo.udfDivide( OverWins, OverLosses+OverWins) * 100.0 as OverPct	-- 9/3
				, '' as 'Description'	-- 10/1
				, AvgScoreReg, AvgScoreRegwOT, AvgTotalLine	-- 11/3
				, AvgOurTotalLine, AvgLineDiffResultReg		-- 12/2
			From [UserLeagueParms] u
			 Join (
				Select 
	 				count(*) as Games
				  , Sum(
						CASE When tmr.Play > ' ' THEN 1
						ELSE 0
						END
						) as Plays
				  ,avg(ScoreReg) as AvgScoreReg
				  ,avg(ScoreReg) + @GameDefaultOTamt as 'AvgScoreRegwOT'
				  ,avg(TotalLine) as AvgTotalLine
				  ,avg(OurTotalLine) as AvgOurTotalLine
				  ,avg([LineDiffResultReg]) as AvgLineDiffResultReg

					, Sum(tmr.UnderWin) + Sum(tmr.UnderLoss) as Unders		
					, Sum(tmr.OverWin) + Sum(tmr.OverLoss) as Overs
					, Sum(tmr.UnderWin) as UnderWins		, Sum(tmr.UnderLoss) as UnderLosses
					, Sum(tmr.OverWin) as OverWins		, Sum(tmr.OverLoss) as OverLosses

				 From [TodaysMatchupsResults] tmr 
				  Where tmr.LeagueName = @LeagueName  
				   AND  tmr.GameDate Between @StartDate and @EndDate
					--AND tmr.Play > ' '
				 ) mr on 1 = 1
				Where u.UserName = 'Test'
