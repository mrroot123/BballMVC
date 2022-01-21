/****** Script for SelectTopNRows command from SSMS  ******/
--use [00TTI_LeagueScores_10_03]
use [00TTI_LeagueScores]

Declare @S1 char(4) = '2021'
		, @S2 char(4) = '1920'
		, @S3 char(4) = '1819'
		, @S4 char(4) = '1718'
		, @S5 char(4) = '1617'
		, @LeagueName char(4) = 'NBA'
Select @@SERVERNAME, @@SERVICENAME

Select 'Rotation' as 'Table'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2021'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from Rotation  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2021'
	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '1920'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from Rotation  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '2020'

	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '1819'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from Rotation  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '2019'

	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '1718'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from Rotation  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '2018'

	,(select   count(*) / 2  from Rotation  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '1617'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from Rotation  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '2017'

UNION
Select 'Boxscores' as 'Table'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2021'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from BoxScores  Where LeagueName = @LeagueName and Season = @S1  Group by Season) as '2021'
	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '1920'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from BoxScores  Where LeagueName = @LeagueName and Season = @S2  Group by Season) as '2020'

	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '1819'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from BoxScores  Where LeagueName = @LeagueName and Season = @S3  Group by Season) as '2019'

	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '1718'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from BoxScores  Where LeagueName = @LeagueName and Season = @S4  Group by Season) as '2018'

	,(select   count(*) / 2  from BoxScores  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '1617'
	,(select   Convert(char(10), Min(GameDate)) + ' - ' +  Convert(char(10), Max(GameDate))  from BoxScores  Where LeagueName = @LeagueName and Season = @S5  Group by Season) as '2017'

