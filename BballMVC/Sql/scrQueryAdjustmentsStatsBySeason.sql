/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores_10_03]
--use [00TTI_LeagueScores_HISTORY]

Declare @S1 char(4) = '2021'
		, @S2 char(4) = '1920'
		, @S3 char(4) = '1819'
		, @S4 char(4) = '1718'
		, @S5 char(4) = '1617'
		, @LeagueName char(4) = 'NBA'
Select @@SERVERNAME, @@SERVICENAME


Select 'Adjustments_Bak' as 'Table'
	,(select   count(*) / 2  from [dbo].[Adjustments_Bak]  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S1  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from [dbo].[Adjustments_Bak]  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S2  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from [dbo].[Adjustments_Bak]  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from [dbo].[Adjustments_Bak]  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S4  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1718'
	,(select   count(*) / 2  from [dbo].[Adjustments_Bak]  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S5  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1617'
	,(Select count(*) as NotUdated From Adjustments_Bak Where StartDate <> EndDate)  as NotUdated 
UNION
Select 'AdjustmentsAll' as 'Table'
	,(select   count(*) / 2  from AdjustmentsAll  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S1  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from AdjustmentsAll  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S2  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from AdjustmentsAll  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from AdjustmentsAll  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S4  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1718'
	,(select   count(*) / 2  from AdjustmentsAll  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S5  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1617'
	,(Select count(*) as NotUdated From AdjustmentsAll Where StartDate <> EndDate)  as NotUdated 

UNION
Select 'Adjustments' as 'Table'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S1  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S2  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S4  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1718'
	,(select   count(*) / 2  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S5  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1617'
	,(Select count(*) as NotUdated From Adjustments Where StartDate <> EndDate)  as NotUdated 

UNION
Select 'Adjustments_NEW' as 'Table'
	,(select   count(*) / 2  from Adjustments_NEW  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S1  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '2021'
	,(select   count(*) / 2  from Adjustments_NEW  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S2  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1920'
	,(select   count(*) / 2  from Adjustments_NEW  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1819'
	,(select   count(*) / 2  from Adjustments_NEW  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S4  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1718'
	,(select   count(*) / 2  from Adjustments_NEW  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S5  Group by dbo.udfGetSeason (StartDate, 'NBA')) as '1617'
	,(Select count(*) as NotUdated From Adjustments_NEW Where StartDate <> EndDate)  as NotUdated 

select   min(StartDate) as StartDate,  max(StartDate) as EndDate  from Adjustments  Where LeagueName = @LeagueName and dbo.udfGetSeason (StartDate, 'NBA') = @S3 
