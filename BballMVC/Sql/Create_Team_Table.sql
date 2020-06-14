/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

Declare 	@LeagueID Int
	,@LeagueName varchar(4)
	,@TeamSource varchar(30)
	,@TeamID_NBA varchar(30)
	,@TeamID_BasketballReference varchar(30)
	,@TeamID_Covers varchar(30)
	,@TeamNameInDatabase varchar(30)
	,@TeamName varchar(10)
	,@StartDate Date
	,@RowId int = 0

	TRUNCATE TABLE Team;

WHILE (1 = 1) 
BEGIN  
	Set @RowId  = @RowId + 1
  -- Get next customerId
  SELECT TOP 1 
  	 @LeagueID = t.LeagueID
	,@LeagueName = t.LeagueName
	,@TeamID_NBA = t.TeamID_NBA
	,@TeamID_BasketballReference = t.TeamID_BasketballReference
	,@TeamID_Covers = t.TeamID_Covers
	,@TeamNameInDatabase = t.TeamID_Database
	,@StartDate = t.StartDate
	FROM Teams t
	WHERE t.TeamsID > @RowID
	order by t.TeamsID

  -- Exit loop if no more Rows
  IF @@ROWCOUNT = 0 BREAK;

	Print(@RowId)

	-- 1) NBA
	Set @TeamSource = 'NBA'
	Set @TeamName = @TeamID_NBA

	INSERT INTO Team (
		o.[LeagueID]
		,o.[LeagueName]
		,o.[TeamSource]
		,o.[TeamNameInDatabase]
		,o.[TeamName]
		,o.[StartDate]
		)
	VALUES (
		 @LeagueID
		,@LeagueName
		,@TeamSource
		,@TeamNameInDatabase
		,@TeamName
		,@StartDate
		);    

	-- 2)	BasketballReference
	Set @TeamSource = 'BasketballReference'
	Set @TeamName = @TeamID_BasketballReference

	INSERT INTO Team (
		o.[LeagueID]
		,o.[LeagueName]
		,o.[TeamSource]
		,o.[TeamNameInDatabase]
		,o.[TeamName]
		,o.[StartDate]
		)
	VALUES (
		 @LeagueID
		,@LeagueName
		,@TeamSource
		,@TeamNameInDatabase
		,@TeamName
		,@StartDate
		);    

	-- 3)	Covers
	Set @TeamSource = 'Covers'
	Set @TeamName = @TeamID_Covers

	INSERT INTO Team (
		o.[LeagueID]
		,o.[LeagueName]
		,o.[TeamSource]
		,o.[TeamNameInDatabase]
		,o.[TeamName]
		,o.[StartDate]
		)
	VALUES (
		 @LeagueID
		,@LeagueName
		,@TeamSource
		,@TeamNameInDatabase
		,@TeamName
		,@StartDate
		);    


END