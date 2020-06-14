/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct 
     [LeagueName]
      ,[TeamSource]
      ,[TeamNameInDatabase]
   --   ,[TeamName]
 --     ,[StartDate]
  FROM [00TTI_LeagueScores].[dbo].[Team]
   where TeamSource = 'Covers'
	and LeagueName = 'nba'
	order by [TeamNameInDatabase]        
	
	  			  Select Top 1 t.TeamName
				 From Team t
				 Where t.LeagueName <= 'NBA'
					AND t.StartDate <= getdate()
					AND t.TeamSource = 'BasketballReference'
					AND t.TeamNameInDatabase = 'ATL'
				 Order by T.StartDate Desc
   