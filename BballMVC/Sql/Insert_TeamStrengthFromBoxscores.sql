
TRUNCATE TABLE  [TeamStrength]

INSERT INTO [TeamStrength]
	 ( [Exclude],[LeagueName]  ,[GameDate]      ,[RotNum]      ,[Team]   ,[Opp]      ,[Venue]      ,[TeamStrength]      ,[TeamStrengthScored]      ,[TeamStrengthAllowed])

SELECT -- TOP (1) 
		0 , [LeagueName]      ,[Date]        ,[Order]     ,[Team]      ,[Opp]     ,H_A         ,[TeamStrength]      ,[TmStrPtsScored]      ,[TmStrPtsAllowed]
  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores]

  Select * From TeamStrength