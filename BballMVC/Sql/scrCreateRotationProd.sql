Use [00TTI_LeagueScores]

/*
--2	Rotation			2018-10-16	2020-03-11	4570
--2n	Rotation_NEW	2009-06-06	2019-12-09	23802
Ren Rotation_OLD
Cre Rotation

--2n	Rotation_NEW	2009-06-06	2019-12-09	23802
--2	Rotation_OLD	2018-10-16	2020-03-11	4570

Insert into Rotation <== Rotation_NEW - ALL 2009-06-06	2019-12-09
Insert into Rotation <== Rotation_OLD - Where GameDate > 2019-12-09
*/

Truncate Table [Rotation] 

----- Rotation_NEW (ALL) ------
INSERT INTO [dbo].[Rotation]   (
	 [LeagueName]
	,[GameDate]
	,[RotNum]
	,[Venue]
	,[Team]
	,[Opp]
	,[GameTime]
	,[TV]
	,[SideLine]
	,[TotalLine]
	,[TotalLineTeam]
	,[TotalLineOpp]
	,[OpenTotalLine]
	,[BoxScoreSource]
	,[BoxScoreUrl]
	,[CreateDate]
	,[UpdateDate]
)
SELECT -- top 1
	 [LeagueName]
	,[GameDate]
	,[RotNum]
	,[Venue]
	,[Team]
	,[Opp]
	,[GameTime]
	,[TV]
	,[SideLine]
	,[TotalLine]
	,[TotalLineTeam]
	,[TotalLineOpp]
	,[OpenTotalLine]
	,[BoxScoreSource]
	,[BoxScoreUrl]
	,[CreateDate]
	,[UpdateDate]
  FROM [00TTI_LeagueScores].[dbo].Rotation_NEW
 


----- Rotation_OLD - Where GameDate > 2019-12-09 ------
INSERT INTO [dbo].[Rotation]   (
	 [LeagueName]
	,[GameDate]
	,[RotNum]
	,[Venue]
	,[Team]
	,[Opp]
	,[GameTime]
	,[TV]
	,[SideLine]
	,[TotalLine]
	,[TotalLineTeam]
	,[TotalLineOpp]
	,[OpenTotalLine]
	,[BoxScoreSource]
	,[BoxScoreUrl]
	,[CreateDate]
	,[UpdateDate]
)
SELECT -- top 1
	 [LeagueName]
	,[GameDate]
	,[RotNum]
	,[Venue]
	,[Team]
	,[Opp]
	,[GameTime]
	,[TV]
	,[SideLine]
	,[TotalLine]
	,[TotalLineTeam]
	,[TotalLineOpp]
	,[OpenTotalLine]
	,[BoxScoreSource]
	,[BoxScoreUrl]
	,[CreateDate]
	,[UpdateDate]
  FROM [00TTI_LeagueScores].[dbo].[Rotation_OLD]
   Where GameDate > '2019-12-09'
 


	Select count(*) as Rows
		, Min(GameDate) as StartDate
		, Max(GameDate) as EndDate
	 From [Rotation] 