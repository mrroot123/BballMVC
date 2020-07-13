use [00TTI_LeagueScores]

Declare @LeagueName varchar(10) = 'NBA', @GameDate Date = '11/1/2019';

Declare @MinDate Date, @MaxDate as Date
		, @Season VarChar(10), @SubSeason VarChar(10), @Bypass bit
Declare @SubSeasonDays int 

DECLARE @x int

 Select top 1 
	@Season = Season, @SubSeason = SubSeason, @Bypass = Bypass
	   FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
    Where LeagueName = @LeagueName AND StartDate <=  @GameDate
	Order by StartDate Desc
--If @Bypass = 1
--	Return 0;
	
 Select 	@Season as Season, @SubSeason as SubSeason, @Bypass as Bypass
 Select @MinDate = min(StartDate),  @MaxDate = max(EndDate)
	   FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
    Where LeagueName = @LeagueName AND Season = @Season
	   AND SubSeason = @SubSeason


Set @x = datediff(d, @MinDate, @GameDate)

Set @SubSeasonDays = (Datediff(d, @MinDate, @MaxDate) + 2) / 4
Select @SubSeasonDays, @MinDate, @MaxDate

select ( datediff(d, @MinDate, @GameDate) / @SubSeasonDays) + 1 as Per

Update rotation
	Set SubSeasonPeriod = dbo.udfCalcSubSeasonPeriod(GameDate, LeagueName)
	Where SubSeasonPeriod is Null
