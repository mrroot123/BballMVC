
--- 10/08/2021	Bball DROP All Non Prod Tables


-- Use [db_a791d7_leaguescores]
Use [00TTI_LeagueScores]

If NOT @@SERVICENAME = 'BBALLPROD'
	Throw 51000, 'Script can only run in BBALLPROD' ,1

DROP TABLE _UpdatedObjects

DROP TABLE AnalysisResults

DROP TABLE BoxScores2

DROP TABLE BoxScoresSeeds

DROP TABLE Plays

DROP TABLE TeamStrength_ALL

DROP TABLE x

DROP TABLE xPlays

DROP TABLE BoxScoresAdjusted
