use [00TTI_LeagueScores]

Declare 
		  @GameDate Date	= '12/21/2019'		-- 1 
		, @LeagueName varchar(10) = 'NBA'	-- 2 
		, @UserName varchar(10) = 'Test'


Declare
		  @Team varchar(10) 		
		, @Opp varchar(10) 		
		, @Venue varchar(10) 
		, @SubSeason varchar(10)
		, @TmStrAdjPct  float 
		, @BxScAdjPct float 
		, @LgAvgScoreHome float  <-- GET VALUES FOR
		, @LgAvgScoreAway float
		, @varLgAvgGamesBack int 
		, @RotNum int

Declare @DailyParms TABLE
(
  Season varchar(4), SubSeason varchar(10), varLgAvgGamesBack int, varTeamAvgGamesBack int, BxScAdjPct float, TmStrAdjPct float, LgAvgScoreAway float, LgAvgScoreHome float
)
Insert Into @DailyParms
SELECT  * FROM    udfDailyParms(@GameDate, @LeagueName, @UserName) 

SELECT * FROM @DailyParms; RETURN;

Select @SubSeason = SubSeason, @TmStrAdjPct = TmStrAdjPct, @BxScAdjPct = BxScAdjPct
  From @DailyParms



-- **********************************************************************************
-- *** Rotation Loop for each Game of GameDate - Generate Daily TeamStrength rows ***
-- **********************************************************************************
Set @RotNum = 0;
While @RotNum < 1000		-- Generate TeamStatsAverages
BEGIN	-- Rotation Loop

	Select Top 1 	@Team = r.Team, @Opp = r.Opp, @RotNum = r.RotNum, @Venue = r.Venue
		From Rotation r
		Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeageName since Rotnum using Greater Than to make unique
		Order by r.RotNum
	If @@ROWCOUNT = 0
		BREAK;
	
	Select @GameDate, @RotNum, @Team

	DECLARE @TeamStrengthParms table (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float)
	INSERT INTO @TeamStrengthParms (AvgTmStrPtsScored,	AvgTmStrPtsAllowed)
	EXEC uspQueryCalcTeamStrength		  @GameDate , @LeagueName, @Team, @Venue, @SubSeason, @TmStrAdjPct, @BxScAdjPct, @LgAvgScoreHome, @LgAvgScoreAway, @varLgAvgGamesBack
	SELECT * FROM @TeamStrengthParms 

	Insert Into TeamStrength (
		 [Exclude]
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Opp]
      ,[Venue]
      ,[TeamStrength]
      ,[TeamStrengthScored]
      ,[TeamStrengthAllowed]
	)
	Select 
		  0
		, @LeagueName
		, @GameDate
		, @RotNum
		, @Team
		, @Opp
		, @Venue
		, tsp.AvgTmStrPtsAllowed + tsp.AvgTmStrPtsScored
		, tsp.AvgTmStrPtsScored
		, tsp.AvgTmStrPtsAllowed
	From @TeamStrengthParms tsp	

END	-- Rotation Loop