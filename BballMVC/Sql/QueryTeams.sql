/****** Script for SelectTopNRows command from SSMS  ******/
Declare @LeagueName varchar(10) = 'NBA';
Declare @tblTeams TABLE ( Team varchar(4) )


Insert Into @tblTeams

SELECT  distinct -- 'Team',
 [TeamNameInDatabase]
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where enddate is null and LeagueName = @LeagueName

  Select * from @tblTeams
