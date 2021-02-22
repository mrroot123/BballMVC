Declare @GB int = 3
	, @LeagueName Varchar(8) = 'NBA'
	, @GameDate date = '2/21/2021'
	, @Team varchar(4) = 'BOS'
	, @Season varchar(4) = '2021'
	, @BxScLinePct float = .2, @BxScTmStrPct float = .5

						Select TOP (@GB)	@GB as GB,	b.GameDate, b.RotNum, b.Team, b.Venue, b.Opp

-- 1) OT already Out
-- 2) Last Min
-- 3) BxSc Curve2Line Pct - @BxScLinePct) - Curve Actual Score toward Tm TL - 1 + ((( TLtm / TmSc ) - 1) * @BxScLinePct - (1, 2, 3pters --> Calculated or Line) 
-- 4) Opp Tm Strength - S
-- Variables  Us - Team - Allowed
--            Op - Opp  - Scored	
-- Xls Cols   B      F                            F                 F                   F                            D                B                                                                    E                                            B   F  
-- Variables  vv     v                            v                 v                   v                           vvvv              vv                                                                vvvvvvv                                         vv  v 
--	 OT already Out		|	<<<		2) Take out Last Min	                            2 >>> | <<< 3) BxSc Curve2LiVenue = @Venuene Pct - @BxScLinePct                        3 >>> | <<< 4) Opp Tm Strength
--[	Shots Made	    Less  Last Min                                   + Default LastMin ] | [ 1   + (( (TmTL             / ScReg	     ) -  1 ) * @BxScLinePct)	]
--	 Seeded row calc		|	>>>		2) Last Min is NULL so non factor                2 >>> | <<< 3) r.TotalLineTeam seeded w b.ScoreRegUs                     3 >>> | <<< 4) Opp Tm Strength - ts.TeamStrengthBxScAdjPctAllowed  seeded w 1.0
, b.ShotsMadeUsRegPt1, r.TotalLineTeam,  b.ScoreRegUs,  ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) )
, '===', ts.TeamStrengthBxScAdjPctAllowed, @BxScTmStrPct, ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * 0), '===='
, '===', ts.TeamStrengthBxScAdjPctScored, @BxScTmStrPct, ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0) - 1.0) * @BxScTmStrPct), '===='

, (b.ShotsMadeUsRegPt1  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct))	AS AverageMadeUsPt1
, (b.ShotsMadeUsRegPt2  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct)	) AS AverageMadeUsPt2
, (b.ShotsMadeUsRegPt3  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegUs)  / b.ScoreRegUs ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctAllowed, 1.0) - 1.0) * @BxScTmStrPct))	AS AverageMadeUsPt3
, (b.ShotsMadeOpRegPt1  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct))	AS AverageMadeOpPt1
, (b.ShotsMadeOpRegPt2  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct))	AS AverageMadeOpPt2
, (b.ShotsMadeOpRegPt3  * ( 1.0 + (( (IsNull(r.TotalLineTeam,  b.ScoreRegOp)   / b.ScoreRegOp ) - 1.0) * @BxScLinePct) ) * ( 1.0 + (IsNull(ts.TeamStrengthBxScAdjPctScored, 1.0)  - 1.0) * @BxScTmStrPct))	AS AverageMadeOpPt3

, b.ShotsAttemptedUsRegPt1, b.ShotsAttemptedUsRegPt2, b.ShotsAttemptedUsRegPt3
, b.ShotsAttemptedOpRegPt1, b.ShotsAttemptedOpRegPt2, b.ShotsAttemptedOpRegPt3
						From BoxScores b
							Left JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
							-- kd 05/17/2020 make TeamStrength LEFT JOIN for NF rows on SEEDed BxSx rows
							Left Join TeamStrength ts					ON ts.GameDate = b.GameDate  AND  ts.LeagueName = b.LeagueName  AND  ts.Team = b.Opp
							Left JOIN BoxScoresLast5Min bL5	ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		
						Where b.LeagueName =@LeagueName
							AND	b.GameDate <	 @GameDate
							AND	b.Team =	@Team
					--		AND  (b.Venue = @Venue OR @BothHome_Away = 1)
							AND  b.Season = @Season
							AND  ( b.SubSeason = '1-Reg')	--  '1-Reg'
							AND  b.Exclude = 0
							Order BY b.GameDate DESC