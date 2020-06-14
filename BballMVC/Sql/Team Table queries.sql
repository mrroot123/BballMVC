/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [TeamID]
--      ,[LeagueID]
--      ,[LeagueName]
--      ,[TeamSource]
--      ,[TeamNameInDatabase]
--      ,[TeamName]
--      ,[StartDate]
--  FROM [00TTI_LeagueScores].[dbo].[Team] t
--  where t.TeamNameInDatabase = 'BR'

  Select Top 1 *
    From Team t
	 Where t.StartDate <= '11/5/2012'
	   AND t.TeamSource = 'Covers'
		AND t.TeamName = 'BK'

  Select Top 1 *
    From Team t
	 Where t.StartDate <= '11/5/2012'
	   AND t.TeamSource = 'BasketballReference'
		AND t.TeamNameInDatabase = 'BR'

  Select Top 1 t.TeamNameInDatabase
    From Team t
	 Where t.StartDate <= '11/5/2011'
	   AND t.TeamSource = 'Covers'
		AND t.TeamName = 'BK'
	Order by T.StartDate Desc

  Select Top 1 *
    From Team t
	 Where t.StartDate <= '11/11/2019'
	   AND t.TeamSource = 'BasketballReference'
		AND t.TeamNameInDatabase
		 =  (		  Select Top 1 t2.TeamNameInDatabase
				 From Team t2
				 Where t2.StartDate <= '11/5/2012'
					AND t2.TeamSource = 'Covers'
					AND t2.TeamName = 'BK'
				Order by T2.StartDate Desc
			)
		Order by T.StartDate Desc

