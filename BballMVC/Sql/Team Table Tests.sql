use [00TTI_LeagueScores]

 Declare        @StartDate		Date	= '1/1/2012'
       , @LeagueName varchar(8)		= 'NBA'
       , @TeamSourceFrom varchar(30)= 'Covers'
       , @TeamSourceTo	varchar(30)	= 'NBA'
       , @TeamName		varchar(30)	= 'ATL'
       , @TeamNameInDataBase	varchar(30)	= 'ATL'

SELECT *
  FROM [00TTI_LeagueScores].[dbo].[Team]
   where ([TeamSource] = @TeamSourceFrom or  [TeamSource] = @TeamSourceTo )
		 and [TeamNameInDatabase] = @TeamNameInDataBase
   order by [TeamSource]

  Select Top 1 t.TeamNameInDatabase, *
				 From Team t
				 Where t.LeagueName <= @LeagueName
					AND t.StartDate <= @StartDate
					AND t.TeamSource = @TeamSourceFrom
					AND t.TeamName = @TeamName
				 Order by T.StartDate Desc
					
			  Select Top 1 t.TeamName, *
				 From Team t
				 Where t.LeagueName = @LeagueName
				   AND t.StartDate <= @StartDate
					AND t.TeamSource = @TeamSourceTo
					AND t.TeamNameInDatabase
					 =  (	Select Top 1 t2.TeamNameInDatabase
							 From Team t2
							 Where t2.LeagueName = @LeagueName
								AND t2.StartDate <= @StartDate
								AND t2.TeamSource = @TeamSourceFrom
								AND t2.TeamName = @TeamName
							 Order by t2.StartDate Desc
							)
					Order by t.StartDate Desc