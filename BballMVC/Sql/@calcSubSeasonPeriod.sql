/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) *
  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
    Where LeagueName = 'WNBA' AND Season = '19'

Declare @MinDate Date, @MaxDate as Date
	, @GameDate Date, @Season varchar(10) = '1-Reg'



	 Select @MinDate = min(StartDate)
	   FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
    Where LeagueName = 'WNBA' AND Season = '19'
	   AND SubSeason = '1-reg'


	 Select @MaxDate = max(EndDate)
	   FROM [00TTI_LeagueScores].[dbo].[SeasonInfo]
    Where LeagueName = 'WNBA' AND Season = '19'
	   AND SubSeason = '1-reg'
Set @GameDate = '9/08/2019'
Declare @SubSeasonDays int = (Datediff(d, @MinDate, @MaxDate) + 2) / 4
	, @x int
Select @SubSeasonDays, @MinDate, @MaxDate
Select dateadd(d, @SubSeasonDays, @MinDate) as Q2
		, dateadd(d, @SubSeasonDays*2, @MinDate) as Q3
		, dateadd(d, @SubSeasonDays*3, @MinDate) as Q4

Set @x = datediff(d, @MinDate, @GameDate)

select (@x/ @SubSeasonDays) + 1 as Per
