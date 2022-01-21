/****** Script for SelectTopNRows command from SSMS  ******/
--use [00TTI_LeagueScores_10_03]
use [00TTI_LeagueScores]

Declare @S1 char(4) = '2122'
		, @S2 char(4) = '2021'
		, @S3 char(4) = '1920'
		, @S4 char(4) = '1819'
		, @S5 char(4) = '1718'
		, @LeagueName char(4) = 'NBA'
Select @@SERVERNAME, @@SERVICENAME
Select 'BoxScores' as 'Table'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2122'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '2021'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '1920'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '1819'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '1718'

UNION
Select 'BoxScoresLast5Min' as 'Table'
	,(select   count(*) / 2  from BoxScoresLast5Min  Where LeagueName = @LeagueName and dbo.udfGetSeason (GameDate, 'NBA') = @S1  Group by dbo.udfGetSeason (GameDate, 'NBA')) as '2122'
	,(select   count(*) / 2  from BoxScoresLast5Min  Where LeagueName = @LeagueName and dbo.udfGetSeason (GameDate, 'NBA') = @S2  Group by dbo.udfGetSeason (GameDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from BoxScoresLast5Min  Where LeagueName = @LeagueName and dbo.udfGetSeason (GameDate, 'NBA') = @S3  Group by dbo.udfGetSeason (GameDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from BoxScoresLast5Min  Where LeagueName = @LeagueName and dbo.udfGetSeason (GameDate, 'NBA') = @S4  Group by dbo.udfGetSeason (GameDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from BoxScoresLast5Min  Where LeagueName = @LeagueName and dbo.udfGetSeason (GameDate, 'NBA') = @S5  Group by dbo.udfGetSeason (GameDate, 'NBA')) as '1718'

UNION
Select 'Rotation' as 'Table'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2122'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '2021'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '1920'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '1819'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '1718'
UNION
Select 'Adjustments' as 'Table'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S1  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2122'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S2  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S4  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S5  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1718'
order by 1
