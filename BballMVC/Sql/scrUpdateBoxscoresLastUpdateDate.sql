/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]
SELECT *
  FROM [00TTI_LeagueScores].[dbo].[ParmTable]
  WHERE  ParmName = 'BoxscoresLastUpdateDate'

  Update [ParmTable]
   Set ParmValue = convert(Varchar,  convert( Date, GetDate()))
	 WHERE  ParmName = 'BoxscoresLastUpdateDate'

SELECT *
  FROM [00TTI_LeagueScores].[dbo].[ParmTable]
  WHERE  ParmName = 'BoxscoresLastUpdateDate'
