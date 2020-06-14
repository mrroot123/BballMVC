Use [00TTI_LeagueScores]

/*
4	BoxScores	2018-09-27	2020-03-11	5758
4n	BoxScores_NEW	2009-10-01	2019-12-20	31098

Ren BoxScores_OLD
Cre BoxScores

4	BoxScores		2018-09-27	2020-03-11	5758
4n	BoxScores_NEW	2009-10-01	2019-12-20	31098

Insert into BoxScores <== BoxScores_NEW - ALL 2009-06-06	2019-12-09
Insert into BoxScores <== BoxScores_OLD - Where GameDate > 2019-12-09
*/

Truncate Table [BoxScores] 

----- BoxScores_NEW (ALL) ------
INSERT INTO [dbo].[BoxScores]   (
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
  FROM [00TTI_LeagueScores].[dbo].BoxScores_NEW
 


----- BoxScores_OLD - Where GameDate > 2019-12-09 ------
INSERT INTO [dbo].[BoxScores]   (
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
  FROM [00TTI_LeagueScores].[dbo].[BoxScores_OLD]
   Where GameDate > '2019-12-09'
 


	Select count(*) as Rows
		, Min(GameDate) as StartDate
		, Max(GameDate) as EndDate
	 From [BoxScores] 