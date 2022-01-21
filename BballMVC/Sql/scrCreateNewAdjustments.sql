USE [00TTI_LeagueScores_10_03]
GO

/*
Select *
 From Adjustments_NEW a
Where a.StartDate = '3/11/2020'
Group by a.StartDate

Select a.StartDate, Sum(a.AdjustmentAmount) as Amt
 From Adjustments_NEW a
Where a.StartDate > '3/1/2020'
Group by a.StartDate

return
/ *
9	Adjustments			2008-01-02	2020-03-11	57066
9n	Adjustments_NEW	2020-01-01	2020-01-04	106


*/
/* ****************
	Convert Adjustments to Single Adjustments to Adjustments_New
   ****************
*/ 
-- Exec [dbo].[uspQueryAdjustments] '12/1/2018', 'NBA'
Declare @StartDate Date = '10/15/2015'
		, @EndDate Date = '6/13/2022'
		, @LeagueName varchar(10) = 'NBA', @GameDate Date;

Set @StartDate = (Select min(StartDate) from Adjustments)
Set @EndDate = (Select max(StartDate) from Adjustments)

Select  CONVERT(TIME, GETDATE()) as StartTime, @StartDate as StartDate, @EndDate as EndDate, @LeagueName as LeagueName
Truncate Table Adjustments_NEW

Set @GameDate = @StartDate;	-- (Select min(GameDate) From Rotation)
-- Select @GameDate; return;
Declare @yr int = 0, @season char(4) =''
WHILE @GameDate < @EndDate  --'7/1/2009'		-- 
BEGIN
--	if @yr <> yEAR(@gameDate)
	if @Season <> dbo.udfGetSeason(@GameDate, @LeagueName)
	BEGIN
		Set @Season = dbo.udfGetSeason(@GameDate, @LeagueName)
		Select @Season, CONVERT(TIME, GETDATE())
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
		  FROM [dbo].[Adjustments] a
		  JOIN Rotation r ON r.LeagueName = a.LeagueName  AND r.GameDate = @GameDate AND ( r.Team = a.Team) -- If no Rotation Row, then no game that day
		 Where a.LeagueName = r.LeagueName
		   AND @GameDate Between a.StartDate AND IsNull(a.EndDate, @GameDate)
			AND a.AdjustmentAmount <> 0
		Order By Team
-- Declare @GameDate date = '1/1/2010'
	Set @GameDate = (Select TOP 1 r.GameDate From Rotation r Where r.GameDate > @GameDate Order By r.GameDate )
--	Select @GameDate
END

Select  CONVERT(TIME, GETDATE()), Count(*) Adjustments_NEW_Rows From  Adjustments_NEW -- Order by StartDate, Team - Select * From  Adjustments_NEW where enddate is null