/****** Script for SelectTopNRows command from SSMS  ******/
Declare @S1 char(4) = '2021'
		, @S2 char(4) = '1920'
		, @S3 char(4) = '1819'
		, @S4 char(4) = '1718'
		, @S5 char(4) = '1617'
Select 'BoxScores' as 'Table'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = 'NBA' and Season = @S1  Group by Season) as '2021'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = 'NBA' and Season = @S2  Group by Season) as '1920'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = 'NBA' and Season = @S3  Group by Season) as '1819'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = 'NBA' and Season = @S4  Group by Season) as '1718'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = 'NBA' and Season = @S5  Group by Season) as '1617'

UNION
Select 'Rotation' as 'Table'
	,(select   count(*) / 2  from Rotation  Where LeagueName = 'NBA' and Season = @S1  Group by Season) as '2021'
	,(select   count(*) / 2  from Rotation  Where LeagueName = 'NBA' and Season = @S2  Group by Season) as '1920'
	,(select   count(*) / 2  from Rotation  Where LeagueName = 'NBA' and Season = @S3  Group by Season) as '1819'
	,(select   count(*) / 2  from Rotation  Where LeagueName = 'NBA' and Season = @S4  Group by Season) as '1718'
	,(select   count(*) / 2  from Rotation  Where LeagueName = 'NBA' and Season = @S5  Group by Season) as '1617'

