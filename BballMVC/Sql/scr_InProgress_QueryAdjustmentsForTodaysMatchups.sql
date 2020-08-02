

declare  @GameDate Date, @LeagueName varchar(10) = 'NBA';
Set @GameDate = convert(Date, getdate());


		SELECT 
				 a.[Team]
				, a.[AdjustmentAmount]
				,Right(Convert(varchar, a.[AdjustmentAmount]), 5) + '  ' + a.AdjustmentType + ' - ' + Convert(varchar, a.[Description]) + ' - ' + IsNull(a.Player, '') as AdjDesc
				,a.[Player]
				,a.[Description]

		  FROM [00TTI_LeagueScores].[dbo].[Adjustments] a
		 Where a.LeagueName = @LeagueName AND a.AdjustmentAmount <> 0
		   AND @GameDate Between a.StartDate AND IsNull(a.EndDate, @GameDate)
		 Order by a.Team