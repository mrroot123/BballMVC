Use [00TTI_LeagueScores]

Truncate Table [Rotation_NEW] 

----- Away ------
INSERT INTO [dbo].[Rotation_NEW]   (
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
	,[Order]
	, 'Away'
	,[Away_Team]
	,[Home_Team]
	,[Time]
	,[TV]
	,[SideLine] * -1
	,[TotalLine]
	,( TotalLine + SideLine) / 2
	,( TotalLine - SideLine) / 2
	,[OpenTotalLine]
	, ''
	, ''
	,[GameDate]
	,[GameDate]
  FROM [00TTI_LeagueScores].[dbo].Schedule s
	Where s.Season <> '1819'


	---- Home ----
INSERT INTO [dbo].[Rotation_NEW]   (
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
SELECT  --top 1
	[LeagueName]
	,[GameDate]
	,[Order] + 1
	, 'Home'
	,[Home_Team]
	,[Away_Team]
	,[Time]
	,[TV]
	,[SideLine]
	,[TotalLine]
	,( TotalLine - SideLine) / 2
	,( TotalLine + SideLine) / 2
	,[OpenTotalLine]
	, ''
	, ''
	,[GameDate]
	,[GameDate]
  FROM [00TTI_LeagueScores].[dbo].Schedule s
	Where s.Season <> '1819'

	Select count(*) From [Rotation_NEW] 