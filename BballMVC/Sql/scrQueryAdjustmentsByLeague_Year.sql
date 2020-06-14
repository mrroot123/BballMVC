/****** Script for SelectTopNRows command from SSMS  ******/
Select 
	[LeagueName]  ,yr , Count(*) Adjs
	From (
		SELECT 
		 [LeagueName]
				,Year(StartDate) as yr

		  FROM [00TTI_LeagueScores].[dbo].Adjustments
  ) q1
  Group by  [LeagueName]  ,yr
  Order by  [LeagueName]  ,yr