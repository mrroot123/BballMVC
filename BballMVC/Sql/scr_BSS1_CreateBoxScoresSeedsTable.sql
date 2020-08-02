Use [00TTI_LeagueScores]

BEGIN -- 1) Declares
Declare @LeagueName varchar(4) = 'WNBA', @Season varchar(4) = '20', @UserName varchar(25) = 'Test'

	Declare @Pt1 as float = 1.00	-- Constants Point Values as float
			, @Pt2 as float = 2.00
			--, @Pt3 as float = 3.00
			--, @Over  as char(8) = 'Over'
			--, @Under as char(8) = 'Under'
			, @Away as char(4) = 'Away'
			, @Home as char(4) = 'Home'
			, @REG_1 as char(5) = '1-Reg'

	-- 3) Parms
	Declare
			  @Team varchar(10)
			, @Venue varchar(4)
			, @SubSeason VarChar(10) 
			--, @TeamAway varchar(8) 
			--, @TeamHome varchar(8)
			--, @RotNum int
			, @ixVenue as int
	;

		-- *************************************************
	-- ***   Get League Averages from DailySummary   ***
	-- *************************************************
	Declare @LgAvgShotsMadeAwayPt1 float, @LgAvgShotsMadeAwayPt2 float, @LgAvgShotsMadeAwayPt3 float
			, @LgAvgShotsMadeHomePt1 float, @LgAvgShotsMadeHomePt2 float, @LgAvgShotsMadeHomePt3 float
			, @LgAvgScoreAway float, @LgAvgScoreHome float
			, @LgAvgTeamScored float, @LgAvgTeamAllowed float
		
			, @LgAvgLastMinPt1 float = 0.95
			, @LgAvgLastMinPt2 float = 0.61
			, @LgAvgLastMinPt3 float = 0.21

	Declare @PrevSeason varchar(4) = (Select top 1 Season
												  FROM SeasonInfo si
												  Where si.LeagueName = @LeagueName and si.Season < @Season
												  order by si.Season Desc
												 )
	-- Get End Date of Last season 1-Reg
	Declare @PrevRegSeasonEndDate Date = (   Select TOP 1 EndDate			
												 FROM [00TTI_LeagueScores].[dbo].[SeasonInfo] si			
											  where LeagueName = @LeagueName		
												AND si.Season =	@PrevSeason	
												and si.SubSeason < '2'		
											  order by StartDate desc			
									)

	-- UserLeagueParms		
	Declare @BxScLinePct float, @BxScTmStrPct float

	Select @BxScLinePct = BxScLinePct, @BxScTmStrPct = BxScTmStrPct 
		From UserLeagueParms Where UserName = @UserName AND LeagueName = @LeagueName

	Declare @varTeamAvgGB int = (Select	Convert(INT, p.ParmValue)  From ParmTable p  Where p.ParmName = 'varTeamAvgGamesBack')

	Select @LeagueName as League, @Season as Season, @PrevSeason as PrevSeason, @PrevRegSeasonEndDate as GameDate
			, @BxScLinePct as BxScLinePct, @BxScTmStrPct as BxScTmStrPct,  @varTeamAvgGB as  varTeamAvgGB 


	Declare  @TeamTable TABLE (Team varchar(4));
	Insert Into @TeamTable (Team)
		SELECT  distinct  [TeamNameInDatabase]
		  FROM [00TTI_LeagueScores].[dbo].[Team]
		  where enddate is null and LeagueName = @LeagueName
		  Order By [TeamNameInDatabase]
-- Select * from @TeamTable; return

	Declare @Today DateTime = GetDate();
END	-- 1) Declares

	Delete From BoxScoresSeeds
		WHERE UserName = @UserName
        AND LeagueName = @LeagueName
        AND Season = @Season

-- Loop for each Team in League
	-- Loop for Venues (Away & Home

	Set @Team = '';
	While 1 = 1		-- LOOP
	BEGIN
	-- Get Away RotNum & TeamAway
		Select Top 1 	@Team = tt.Team
			From @TeamTable tt
			Where tt.Team > @Team
			Order by tt.Team
		
		If @@ROWCOUNT = 0
			BREAK;
		
		Set @Venue = @Away
		Set @ixVenue = 0
		WHILE @ixVenue < 2
		BEGIN
			Declare @d date = CONVERT(date, getdate());
			Declare @MadePctP1 float, @MadePctP2 float, @MadePctP3 float, @AllowedPctP1 float, @AllowedPctP2 float, @AllowedPctP3 float
			DECLARE @Pcts TABLE (MadePctP1 float, MadePctP2 float, MadePctP3 float, AllowedPctP1 float, AllowedPctP2 float, AllowedPctP3 float)
			Insert into @Pcts  
			EXEC [dbo].[uspCalcPtPct] @d, @LeagueName, @Team , @Venue
			Select TOP 1
				 @MadePctP1 = MadePctP1, @MadePctP2 = MadePctP2, @MadePctP3 = MadePctP3
				 , @AllowedPctP1 = AllowedPctP1, @AllowedPctP2 = AllowedPctP2, @AllowedPctP3 = AllowedPctP3 
			  From @Pcts

		-- 1 row for both Away & Home stats
		-- OpMade = Allowed
			INSERT INTO BoxScoresSeeds		-- Each Venue - from BoxScores
			(
		-- 1 / 8
				[UserName],[LeagueName]  ,[Season] ,[GamesBack]  ,[Team] , Venue	-- 6 
			,[AdjustmentAmountMade],[AdjustmentAmountAllowed]							-- 2
		-- 2 / 8
			,[LastYearMadeTmStr]	
			,[LastYearShotsMadePt1]				,[LastYearShotsMadePt2]				,[LastYearShotsMadePt3]				-- 11-13
			,[LastYearAllowedTmStr]	
			,[LastYearShotsAllowedPt1]			,[LastYearShotsAllowedPt2]			,[LastYearShotsAllowedPt3]				-- 11-13
		-- 3 / 6

			,[ThisYearShotsMadePt1]				,[ThisYearShotsMadePt2]				,[ThisYearShotsMadePt3]				-- 11-13
			,[ThisYearShotsAllowedPt1]			,[ThisYearShotsAllowedPt2]			,[ThisYearShotsAllowedPt3]				-- 11-13
		-- 4 / 6
			,[PctMadePt1]							,[PctMadePt2]							,[PctMadePt3]			
			,[PctAllowedPt1]						,[PctAllowedPt2]						,[PctAllowedPt3]			
		-- 5 / 2
			,[CreateDate]				,[UpdateDate]															-- 25-26
			)
			Select
				-- 1 / 8
					 @UserName			,@LeagueName, @Season,	@varTeamAvgGB, @Team , @Venue
					, 0 , 0																									-- 7-8
				-- 2 / 8 Last Year
					,Avg(MadePt1) + Avg(MadePt2) *2 + Avg(MadePt3) * 3  as LastYearTmStr 				
					,Avg(MadePt1) as AvgMadePt1 	,Avg(MadePt2) as AvgMadePt2 	,Avg(MadePt3) as AvgMadePt3 				

					,Avg(AllowedPt1) + Avg(AllowedPt2)*2 + Avg(AllowedPt3)*3  as LastYearAllowedTmStr 
					,Avg(AllowedPt1) as AvgAllowedPt1 	,Avg(AllowedPt2) as AvgAllowedPt2 	,Avg(AllowedPt3) as AvgAllowedPt3 
				-- 3 / 6 This Year
					,0 ,0 ,0 ,0 ,0 ,0 
				-- 4 / 6
					,@MadePctP1 ,		@MadePctP2 ,	 @MadePctP3 
					, @AllowedPctP1, @AllowedPctP2, @AllowedPctP3

				-- 5 / 2
					,@Today	, @Today																						-- 25-26
				From ( 

					Select TOP (@varTeamAvgGB)	b.GameDate, b.Team, b.Venue
-- Adjustments
-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - S
-- Variables  Us - Team - Allowed
--            Op - Opp  - Scored	
-- Xls Cols   B      F                            F                 F                   F                            D                B                                                                    E                                            B   F  
-- Variables  vv     v                            v                 v                   v                           vvvv              vv                                                                vvvvvvv                                         vv  v 
--	 OT already Out		|	<<<		2) Take out Last Min	                            2 >>> | <<< 3) BxSc Curve2Line Pct - @BxScLinePct                        3 >>> | <<< 4) Opp Tm Strength
--[	Shots Made	    Less  Last Min                                   + Default LastMin ] | [ 1   + (( (TmTL             / ScReg	     ) -  1 ) * @BxScLinePct)	]
--	 Seeded row calc		|	>>>		2) Last Min is NULL so non factor                2 >>> | <<< 3) r.TotalLineTeam seeded w b.ScoreRegUs                     3 >>> | <<< 4) Opp Tm Strength - ts.TeamStrengthBxScAdjPctAllowed  seeded w 1.0
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS MadePt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS MadePt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS MadePt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AllowedPt3

					From BoxScores b
						JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
						Left Join TeamStrength ts ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
						Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
					Where b.LeagueName = @LeagueName
						AND	b.GameDate <	 @PrevRegSeasonEndDate
						AND	b.Team =	@Team
						AND  b.Venue = @Venue
						AND  b.Season = @PrevSeason
						AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
						AND  b.Exclude = 0
						Order BY b.GameDate DESC
				) x
				JOIN @Pcts p ON 1=1
			Set @Venue = @Home
			Set @ixVenue = @ixVenue + 1
		End	-- Venue Loop
	END	-- Team Loop	

	Select * from BoxScoresSeeds

