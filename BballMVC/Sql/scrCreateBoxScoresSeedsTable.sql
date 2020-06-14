Use [00TTI_LeagueScores]

Declare @LeagueName varchar(4) = 'NBA', @Season varchar(4) = '1920', @UserName varchar(25) = 'Test'

	Declare @Pt1 as float = 1.00	-- Constants Point Values as float
			, @Pt2 as float = 2.00
			, @Pt3 as float = 3.00
			, @Over  as char(8) = 'Over'
			, @Under as char(8) = 'Under'
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
	Declare @GameDate Date = (   Select TOP 1 EndDate			
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

	Select @LeagueName as League, @Season as Season, @PrevSeason as PrevSeason, @GameDate as GameDate
			, @BxScLinePct as BxScLinePct, @BxScTmStrPct as BxScTmStrPct,  @varTeamAvgGB as  varTeamAvgGB 


	Declare  @TeamTable TABLE (Team varchar(4));
	Insert Into @TeamTable (Team)
		SELECT  distinct  [TeamNameInDatabase]
		  FROM [00TTI_LeagueScores].[dbo].[Team]
		  where enddate is null and LeagueName = @LeagueName
		  Order By [TeamNameInDatabase]
-- Select * from @TeamTable

	Declare @Today DateTime = GetDate();

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
			While @ixVenue < 2	-- loop 2 times 
			BEGIN	-- Venue Loop

				INSERT INTO BoxScoresSeeds		-- Each Venue - from BoxScores
				(
				  [UserName],[LeagueName]  ,[Season] ,[GamesBack]  ,[Team] ,[Venue]	-- 1-6
				,[AdjustmentAmountMade],[AdjustmentAmountAllowed]							-- 7-8
				,[ScoreMade]
				,[ScoreAllowed]																		-- 10		

				,[ShotsMadePt1]				,[ShotsMadePt2]				,[ShotsMadePt3]				-- 11-13
				,[ShotsAllowedPt1]			,[ShotsAllowedPt2]			,[ShotsAllowedPt3]			-- 14-16

				,[ScoreAdjustedMade]
				,[ScoreAdjustedAllowed]																				-- 18

				,[ShotsAdjustedMadePt1]		,[ShotsAdjustedMadePt2]		,[ShotsAdjustedMadePt3]		-- 19-21
				,[ShotsAdjustedAllowedPt1]	,[ShotsAdjustedAllowedPt2]	,[ShotsAdjustedAllowedPt3]	-- 22-24
				,[CreateDate]				,[UpdateDate]															-- 25-26
				)
				Select @UserName			,@LeagueName, @Season,	@varTeamAvgGB, @Team , @Venue				-- 1-6
						, 0 , 0																									-- 7-8
						,Avg(AverageMadeUsPt1) + Avg(AverageMadeUsPt2) * 2 + Avg(AverageMadeUsPt3) * 3	-- 9
						,Avg(AverageMadeOpPt1) + Avg(AverageMadeOpPt2) * 2 + Avg(AverageMadeOpPt3) * 3	-- 10
						,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)				-- 11-13
						,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)				-- 14-16

						,Avg(AverageMadeUsPt1) + Avg(AverageMadeUsPt2) * 2 + Avg(AverageMadeUsPt3) * 3	-- 17
						,Avg(AverageMadeOpPt1) + Avg(AverageMadeOpPt2) * 2 + Avg(AverageMadeOpPt3) * 3	-- 18
						,Avg(AverageMadeUsPt1) 	,Avg(AverageMadeUsPt2)	,Avg(AverageMadeUsPt3)				-- 19-21
						,Avg(AverageMadeOpPt1) 	,Avg(AverageMadeOpPt2)	,Avg(AverageMadeOpPt3)				-- 22-24
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
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineTeam  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AverageMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (r.TotalLineOpp   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AverageMadeOpPt3

						From BoxScores b
							JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Left Join TeamStrength ts ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5MinEmpty bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  b.Venue = @Venue
							AND  b.Season = @PrevSeason
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC
					) x

				Set @ixVenue = @ixVenue + 1
				Set @Venue = @Home

			END	-- Venue Loop
	END	-- Team Loop	



