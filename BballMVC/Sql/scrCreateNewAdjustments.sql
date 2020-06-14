USE [00TTI_LeagueScores]
GO


Select *
 From Adjustments_NEW a
Where a.StartDate = '3/11/2020'
Group by a.StartDate

Select a.StartDate, Sum(a.AdjustmentAmount) as Amt
 From Adjustments_NEW a
Where a.StartDate > '3/1/2020'
Group by a.StartDate

return
/*
9	Adjustments			2008-01-02	2020-03-11	57066
9n	Adjustments_NEW	2020-01-01	2020-01-04	106


*/

-- Exec [dbo].[uspQueryAdjustments] '12/1/2018', 'NBA'
Declare @StartDate Date = '1/1/2020', @LeagueName varchar(10) = 'NBA', @GameDate Date;

Truncate Table Adjustments_NEW

Set @GameDate = (Select min(GameDate) From Rotation)
-- Select @GameDate; return;
Declare @yr int = 0
WHILE @GameDate <  '3/12/2020'  --'7/1/2009'		-- 
BEGIN
	if @yr <> yEAR(@gameDate)
	BEGIN
		Set @yr = yEAR(@gameDate)
		Select @yr, CONVERT(TIME, GETDATE())
	END

	INSERT INTO Adjustments_NEW
           ([LeagueName]
           ,[StartDate]
           ,[EndDate]
           ,[Team]
           ,[AdjustmentType]
           ,[AdjustmentAmount]
           ,[Player]
           ,[Description]
           ,[TS])

		SELECT  
				 a.[LeagueName]
				,@GameDate
				,@GameDate
				--, CASE
				--	WHEN a.EndDate Is Null THEN NULL
				--	ELSE @GameDate
				--  END
				,a.[Team]
				,a.AdjustmentType
				,a.[AdjustmentAmount]
				,a.[Player]
				,a.[Description]
				,a.[TS]
		  FROM [00TTI_LeagueScores].[dbo].[Adjustments] a
		  JOIN Rotation r ON r.LeagueName = a.LeagueName  AND r.GameDate = @GameDate AND ( r.Team = a.Team)
		 Where a.LeagueName = r.LeagueName
		   AND @GameDate Between a.StartDate AND IsNull(a.EndDate, @GameDate)
			AND a.AdjustmentAmount <> 0
		Order By Team
-- Declare @GameDate date = '1/1/2010'
	Set @GameDate = (Select TOP 1 r.GameDate From Rotation r Where r.GameDate > @GameDate Order By r.GameDate )
--	Select @GameDate
END

Select Count(*) From  Adjustments_NEW -- Order by StartDate, Team - Select * From  Adjustments_NEW where enddate is null