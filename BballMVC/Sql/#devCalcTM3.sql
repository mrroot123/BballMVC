
use [00TTI_LeagueScores]

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()

			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
	;

BEGIN -- #3 - temp if to Bypass TeamStatsAverages
	IF @Display = 1	Select '#3' as Section, dbo.GetTime(11) as SectionTime
	Set @GB = 0;
	While 1 = 1		
	-- 3.1) Loop 4 times for 3 GB values & GB10
		-- Loop for each Team in Rotation for
	BEGIN	-- Delete any PREVIOUS TeamStatsAverages rows for LeagueName, GameDate and GB for this GB iteration
		Select Top 1 @GB = g.GB
			From @GBTable g
			Where g.GB > @GB
			Order by g.GB

		If @@ROWCOUNT = 0
			BREAK;
		Delete From TeamStatsAverages Where LeagueName = @LeagueName AND GameDate = @GameDate and GB = @GB -- TSA
	END -- GB loop
	-- *************************************************************************************************
	-- *** #3.2 - Rotation Loop for each Game of GameDate & Venue - Generate TeamStatsAverages from BoxScores ***
	-- *************************************************************************************************
	
	BEGIN TRANSACTION
	While 1 = 1		-- Generate TeamStatsAverages
	BEGIN -- 3.2.1) Loop Rotation 
	-- Get Away RotNum & TeamAway
		Select Top 1 	-- Get Rotation
			@TeamAway = r.Team,  @TeamHome = rh.Team,  @RotNum = r.RotNum
			From Rotation r
			JOIN Rotation rh	on rh.GameDate = r.GameDate  AND  rh.RotNum = r.RotNum + 1		-- rh = Rotation Home row
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;

	--		Select @GameDate, @RotNum, @TeamAway, @TeamHome; return;

		Set @GB = 0;
		While 1 = 1		-- Loop 3 times for each GB value & GB10
		BEGIN	-- 3.2.2) Loop 3 times for each GB value & GB10
			Select Top 1 @GB = g.GB
				From @GBTable g
				Where g.GB > @GB
				Order by g.GB
			If @@ROWCOUNT = 0
				BREAK;


			Set @Team  = @TeamAway
			Set @Venue = @Away

			Set @ixVenue = 0
			While @ixVenue < 2	-- loop 2 times 
			BEGIN	-- 3.2.3) Loop Venue
				Declare @OppRotNum int
				If @Venue = @Away
					Set @OppRotNum = @RotNum + 1
				else
					Set @OppRotNum = @RotNum - 1
if @Display = 1 Select 'INSERT INTO TeamStatsAverages', GetDate()
				INSERT INTO TeamStatsAverages		-- Each Venue - from BoxScores TSA
				(
					
					-- 1/6
					 [UserName],			[LeagueName],			[GameDate],  RotNum ,	[Team],	[Venue]
					-- 2/4
					,[GB],[ActualGB],			[StartGameDate], [EndGameDate]
					-- 3/6
					,[AverageMadeUs],	[AverageMadeOp]
					, AverageAdjustedScoreRegUs	,AverageAdjustedScoreRegOp	-- 9/17/2017 added 2 cols - PlanB
					, CalcScoredDiffUs	, CalcScoredDiffOp
					-- 4/6
					,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
					,[AverageMadeOpPt1], [AverageMadeOpPt2],	[AverageMadeOpPt3]
					
					-- 5/6
					,[AverageAtmpUsPt1], [AverageAtmpUsPt2],	[AverageAtmpUsPt3]
					,[AverageAtmpOpPt1], [AverageAtmpOpPt2],	[AverageAtmpOpPt3]
					-- 6/4
					,[PtsScoredPctPt1]  
					,[PtsScoredPctPt2]   
					,[PtsScoredPctPt3]
					, TS
				)
				-- Final Query into Insert into TeamStatsAverages
						
					Select 
						-- 1/6
						  @UserName as UserName			,@LeagueName			,@GameDate	, @RotNum + @ixVenue	, @Team as Team
						, Case 
						   When @BothHome_Away = 1 THEN 'Both'
							Else @Venue
						  END as Venue
						-- 2/4 
						,@GB as GB					,q2.ActualGB				,q2.StartGameDate		,q2.EndGameDate
						-- 3/6
						,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) as AverageMadeUs
						,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) as AverageMadeOp
						,q2.AverageAdjustedScoreRegUs	,q2.AverageAdjustedScoreRegOp		-- 9/17/2017 added 2 cols - PlanB
						,(q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3) - q2.AverageAdjustedScoreRegUs as CalcScoredDiffUs
						,(q2.AverageMadeOpPt1 + q2.AverageMadeOpPt2 * @pt2 + q2.AverageMadeOpPt3 * @pt3) - q2.AverageAdjustedScoreRegOp as CalcScoredDiffOp

						-- 4/6
						,q2.AverageMadeUsPt1 	,q2.AverageMadeUsPt2 	,q2.AverageMadeUsPt3 
						,q2.AverageMadeOpPt1  	,q2.AverageMadeOpPt2  	,q2.AverageMadeOpPt3
						
						-- 5/6
						,q2.AverageAtmpUsPt1 	,q2.AverageAtmpUsPt2 	,q2.AverageAtmpUsPt3 
						,q2.AverageAtmpOpPt1  	,q2.AverageAtmpOpPt2  	,q2.AverageAtmpOpPt3
						-- 6/4
						,(q2.AverageMadeUsPt1 * @Pt1) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt2 * @Pt2) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						,(q2.AverageMadeUsPt3 * @Pt3) / (q2.AverageMadeUsPt1 + q2.AverageMadeUsPt2 * @pt2 + q2.AverageMadeUsPt3 * @pt3)
						, GETDATE()
						  	
				From (	-- q2
					Select  @UserName as UserName, @LeagueName as LeagueName, @GameDate as GameDate, @RotNum + @ixVenue as RotNum	--, @Team as Team, @Venue as Venue
						,@GB as GB , Count(*) as ActualGB			,Min(GameDate) AS StartGameDate, Max(GameDate) AS EndGameDate
						,Avg(AdjustedMadeUsPt1)	as AverageMadeUsPt1,  Avg(AdjustedMadeUsPt2) as AverageMadeUsPt2,  Avg(AdjustedMadeUsPt3)	as AverageMadeUsPt3 
						,Avg(AdjustedMadeOpPt1)	as AverageMadeOpPt1,  Avg(AdjustedMadeOpPt2) as AverageMadeOpPt2,  Avg(AdjustedMadeOpPt3)	as AverageMadeOpPt3  	

						,Avg(AdjustedScoreRegUs) as AverageAdjustedScoreRegUs,	Avg(AdjustedScoreRegOp) as AverageAdjustedScoreRegOp	-- 9/17/2017 added - PlanB

						,Avg(ShotsAttemptedUsRegPt1) as AverageAtmpUsPt1, Avg(ShotsAttemptedUsRegPt2) as AverageAtmpUsPt2, Avg(ShotsAttemptedUsRegPt3) as AverageAtmpUsPt3
						,Avg(ShotsAttemptedOpRegPt1) as AverageAtmpOpPt1, Avg(ShotsAttemptedOpRegPt2) as AverageAtmpOpPt2, Avg(ShotsAttemptedOpRegPt3) as AverageAtmpOpPt3
					From ( -- q1

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp

-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)
-- Variables  Us - Team - Allowed
--            Op - Opp  - Scored	
-- Xls Cols   B      F                            F                 F                   F                            D                B                                                                    E                                            B   F  
-- Variables  vv     v                            v                 v                   v                           vvvv              vv                                                                vvvvvvv                                         vv  v 
--	 OT already Out		|	<<<		2) Take out Last Min	                            2 >>> | <<< 3) BxSc Curve2LiVenue = @Venuene Pct - @BxScLinePct                        3 >>> | <<< 4) Opp Tm Strength
--[	Shots Made	    Less  Last Min                                   + Default LastMin ] | [ 1   + (( (TmTL             / ScReg	     ) -  1 ) * @BxScLinePct)	]                                       3 >>> | <<< 4
--	 Seeded row calc		|	>>>		2) Last Min is NULL so non factor                2 >>> | <<< 3) r.TotalLineTeam seeded w b.ScoreRegUs																						 3 >>> | <<< 4) Opp Tm Strength - ts.TeamStrengthBxScAdjPctAllowed  seeded w 1.0
, (b.ShotsMadeUsRegPt1 - IsNull(bL5.Q4Last1MinUsPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt1
, (b.ShotsMadeUsRegPt2 - IsNull(bL5.Q4Last1MinUsPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt2
, (b.ShotsMadeUsRegPt3 - IsNull(bL5.Q4Last1MinUsPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedMadeUsPt3

, (b.ShotsMadeOpRegPt1 - IsNull(bL5.Q4Last1MinOpPt1, @LgAvgLastMinPt1) + @LgAvgLastMinPt1) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt1
, (b.ShotsMadeOpRegPt2 - IsNull(bL5.Q4Last1MinOpPt2, @LgAvgLastMinPt2) + @LgAvgLastMinPt2) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt2
, (b.ShotsMadeOpRegPt3 - IsNull(bL5.Q4Last1MinOpPt3, @LgAvgLastMinPt3) + @LgAvgLastMinPt3) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(rOPP.TotalLineTeam,  b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct)	AS AdjustedMadeOpPt3

, (b.ScoreRegUs - IsNull(bL5.Q4Last1MinUsPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	AS AdjustedScoreRegUs	-- 9/17/2020 PlanB
, (b.ScoreRegOp - IsNull(bL5.Q4Last1MinOpPts, @LgAvgLastMinPts) + @LgAvgLastMinPts) * ( 1.0 + (( (dbo.udfDefaultNullOrZero(r.TotalLineTeam,     b.ScoreRegOp)  / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0) - 1.0)  * @BxScTmStrPct)	AS AdjustedScoreRegOp	-- Add 2 cols Planb

, b.ShotsAttemptedUsRegPt1, b.ShotsAttemptedUsRegPt2, b.ShotsAttemptedUsRegPt3
, b.ShotsAttemptedOpRegPt1, b.ShotsAttemptedOpRegPt2, b.ShotsAttemptedOpRegPt3
						From BoxScores b
							Left JOIN Rotation r		ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							Left JOIN Rotation rOPP ON r.GameDate = b.GameDate AND r.RotNum =  r.RotNum + (r.RotNum % 2) * 2 - 1  		-- Opposite RotNum
							-- kd 05/17/2020 make TeamStrength LEFT JOIN for NF rows on SEEDed BxSx rows
							Left Join TeamStrength ts					ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5Min bL5	ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName = @LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
							AND  (b.Venue = @Venue OR @BothHome_Away = 1)
							AND  (b.Season = @Season OR @BoxscoresSpanSeasons = 1)
							AND  (b.SubSeason = @SubSeason OR b.SubSeason = @REG_1)	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC, RotNum
					) 	q1
					-- q1
				) 	q2

				Set @ixVenue = @ixVenue + 1
				Set @Team  = @TeamHome
				Set @Venue = @Home

			END	-- 3.2.3) Venue Loop
 	
		END	-- 3.2.2) GB loop

		Set @RotNum = @RotNum + 1;		-- RotNum = to Away Row - Point to Home Row (EVEN) and do > on next iteration select

	END	-- 3.2.1) Generate TeamStatsAverages - Rotation Loop	
	COMMIT
END -- temp bypass

