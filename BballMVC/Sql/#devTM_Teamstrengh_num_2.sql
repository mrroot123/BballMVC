
	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()
			, @RotNum int	
			, @Team varchar(10) 
			, @Venue varchar(4)
			, @Season varchar(4) = '2021'

			, @GB3 int = 7
			, @VolatilityGamesBack int = 10
			, @TeamStrengthGamesBack int = 7
			, @TMoppAdjPct float = .7
			, @BxScLinePct float = .5
			, @LgAvgScoreAway float = 112.0
			, @LgAvgScoreHome float = 112.0
			, @BothHome_Away bit = 1
			, @Display bit = 1

BEGIN -- #2 - 2.1-NA  2.2-Generate TeamStrength
		Declare @Away varchar(4) = 'Away'

		IF @Display = 1	Select '#2' as Section, dbo.GetTime(11)	 as SectionTime

	-- *****************************************************************************************
	-- *** #2.2 - Rotation Loop for each Game of GameDate - Generate TeamStrength             ***
	-- ***	TeamStrength will have Team's Current TS stats as of that Date                  ***
	-- *****************************************************************************************
		Delete From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate

	-- Yesterday's BoxScores were loaded, so calc TeamStrength as of Yesterday

		Declare @Volatility float, @LgAvgTeamScored float, @LgAvgTeamAllowed float

		Set @RotNum = 0;
		While @RotNum < 1000		-- Generate TeamStatsAverages
		BEGIN
		---- Get next Rotation row by RotNum - Away or Home
			Select Top 1  @GameDate = r.GameDate,	@Team = r.Team,  @RotNum = r.RotNum, @Venue = r.Venue
				From Rotation r
				Where r.LeagueName = @LeagueName AND  r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
				Order by r.RotNum

			If @@ROWCOUNT = 0
				BREAK;

			If @Venue = @Away
				BEGIN
					Set @LgAvgTeamScored  = @LgAvgScoreAway	-- Lg Avg a team scores Away
					Set @LgAvgTeamAllowed = @LgAvgScoreHome	-- Lg Avg a team Allows Away
				END
			Else
				BEGIN
					Set @LgAvgTeamScored  = @LgAvgScoreHome	-- Lg Avg a team scores Home
					Set @LgAvgTeamAllowed = @LgAvgScoreAway	-- Lg Avg a team Allows Home
				END

			If  @BothHome_Away = 1		-- 02/22/2021
				 Set @Venue = 'Both';
						  
			Select @Volatility = dbo.udfCalcVolatility (@UserName, @GameDate, @LeagueName, @Season, @Team, @VolatilityGamesBack)

		-- Create & Populate Team Strenght VAR Table with AvgTmStrPtsScored / AvgTmStrPtsAllowed for TEAM being processed
			Declare  @TmStr TABLE (AvgTmStrPtsScored float, AvgTmStrPtsAllowed float, ActualGamesBack int)
	 		Delete  @TmStr
			-- Populate @TmStr from uspQueryCalcTeamStrength query O/P
			Insert into @TmStr
				EXEC uspQueryCalcTeamStrength
					  @UserName	-- 0
					, @GameDate			-- 1 
					, @LeagueName -- 2 
					, @Team 		-- 3 
					, @Venue 	-- 4 
					, @Season
					, @TMoppAdjPct  		-- 6
					, @BxScLinePct		-- 7	30% of of the ActualScore will be curved back to line ex: Actual: 30 Line: 20 - 30% of 10 = 3. Actual goes from 30 to 27
					, @LgAvgScoreAway 	-- 8  	
					, @LgAvgScoreHome  -- 9
					, @TeamStrengthGamesBack	-- 10 -- 02/10/2021

			-- TeamStrengthBxScAdjPctScored  -- < 1 - Hi Scoring < 1  ||| > 1 Lo Scoring
			-- TeamStrengthBxScAdjPctAllowed -- < 1 - Bad Defence < 1 ||| > 1 Lo Good Defence
			--		Ref in 3.2.3 Calc#4 - Insert TeamStatsAverages
			Insert into TeamStrength
			(
				LeagueName,  GameDate,     RotNum,  Team,  Venue					-- 1/5
				, TeamStrength,  TeamStrengthScored,  TeamStrengthAllowed		-- 2/3
				, TeamStrengthBxScAdjPctScored, TeamStrengthBxScAdjPctAllowed	-- 3/2 - Ref in 3.2.3 Calc#4 - Insert TeamStatsAverages
				, TeamStrengthTMsAdjPctScored, TeamStrengthTMsAdjPctAllowed		-- 4/2 - NOT Referenced in any calculations
				, Volatility,	TS																-- 5/2
				, GB, ActualGB	-- 6/2
			)
			Select 
			    @LeagueName, @GameDate, @RotNum, @Team, @Venue		-- 1/5
				 , ts.AvgTmStrPtsScored+ts.AvgTmStrPtsAllowed, ts.AvgTmStrPtsScored,  ts.AvgTmStrPtsAllowed	--> from @TmStr 2/3
				 , @LgAvgTeamScored / ts.AvgTmStrPtsScored, @LgAvgTeamAllowed / ts.AvgTmStrPtsAllowed	-- 3/2
				 , ts.AvgTmStrPtsScored / @LgAvgTeamScored, ts.AvgTmStrPtsAllowed/ @LgAvgTeamAllowed	-- 4/2 - Recipricals of Grp 3 above
				 ,	@Volatility,	GETDATE()																		-- 5/2
				 , @GB3, ts.ActualGamesBack	-- 6/2
				From @TmStr ts
			
	--	Select '292 2.2' as Line#, * from @TmStr;  Print 245;	Return;
		END	-- Rotation Loop
	 	-- Select * From TeamStrength Where LeagueName = @LeagueName AND GameDate = @GameDate;  Select '294 2.2' as Line#; 	return;
END -- 2 - 2.1-uspInsertTodaysMatchupsResults  2.2-Generate TeamStrength
