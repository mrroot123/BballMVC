/****** Script for SelectTopNRows command from SSMS  ******/
Declare @Var float = -2.0;

Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0

Select @Var as var, *
	, Round(
			( (q2.Overs / Convert(float,((q2.Unders + q2.Overs))) ) * 100)
			, 2) as OverPct
	From (
	Select Count( *) as BxScores
		, Sum(q1.Unders) as Unders
		, Sum(q1.[Overs]) as Overs
		, Sum(q1.Pushes) as Pushes
		From (
			SELECT 
				--TOP (1000) 
					 r.TotalLine 
					, b.ScoreOT
					, CASE WHEN @Var + r.TotalLine < b.ScoreOT THEN 1
						ELSE 0
					  END as [Unders]      
					, CASE WHEN @Var + r.TotalLine > b.ScoreOT THEN 1
						ELSE 0
					  END as [Overs]
					, CASE WHEN @Var + r.TotalLine = b.ScoreOT THEN 1
						ELSE 0
					  END as Pushes
			  FROM [00TTI_LeagueScores].[dbo].[BoxScores_NEW] b
			  JOIN Rotation_NEW r ON r.GameDate = b.GameDate and r.RotNum = b.RotNum
				Where b.LeagueName = 'NBA' AND b.Venue = 'Away' AND b.Exclude = 0
		) q1
	) q2

	Set @var = @var + 1.0
