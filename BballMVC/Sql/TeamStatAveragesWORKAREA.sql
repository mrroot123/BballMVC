
use [00TTI_LeagueScores]
--print dbo.udfOppositeVenue('away')
--print dbo.udfGetVenueReal(1.0, -1.0, 'Hxome')

Declare @UserName		varchar(10) = 'Test';
Declare @GameDate Datetime = GetDate();
Declare @LeagueName varchar(8) = 'NBA';
Declare @Team varchar(8) = 'IND';
Declare @Venue varchar(8) = 'Home'
 , @LastMinPt1 float = 1.05
;
Declare @LgAvgHomePt1 float = 21.01
		, @LgAvgHomePt2 float = 32.02
		, @LgAvgHomePt3 float =  9.03
		, @LgAvgAwayPt1 float = 20.01
		, @LgAvgAwayPt2 float = 30.02
		, @LgAvgAwayPt3 float =  8.03
;

Declare @GamesBack1 int =   5
		, @GamesBack2 int =   8
		, @GamesBack3 int =  12
;
Declare @Curve float = 0.0
		, @Curve_Pct float
		, @Curve_Factor float
		;
Set @Curve_Pct = @Curve / (@Curve + 1)

print dbo.udfOppositeVenue(8)
			
--Calce Curve_Factor			
--	Curve_Pct = Curve / (Curve + 1)		
-- TmTL = (TOTAL_Line - Side_Line * VenueSign) / 2  - VenueSign = 1 Home | (-1) Away

--	' 1 + (((TmTL / ScReg) - 1) * Curve_Pct)		
--Curve 	2		
--C_Pct	0.666666667		
--TmTL	200		TmTL = (TOTAL_Line - Side_Line) / 2
--ScReg	210		
--C_Factor	0.968253968		

-- Adjustments
-- 1 - OT
-- 2 - Last Min
-- 3 - Curve
-- 4 - Opp Tm Strength - not applied yet
Truncate Table TeamStatsAverages

INSERT INTO TeamStatsAverages (
	 [UserName],			[LeagueName],			[GameDate],	[Team],	[Venue]
	,[GamesBack],			[StartGameDate]
	,[AverageMadeUsPt1], [AverageMadeUsPt2],	[AverageMadeUsPt3]
	,[AverageMadeOppPt1],[AverageMadeOppPt2],	[AverageMadeOppPt3]
	)
--
	Select @UserName			,@LeagueName			,@GameDate	,@Team	,@Venue
			,Max(GamesBack)			,GetDate()
			,Avg(AverageMadeUsPt1)	,	0.0	,0.0
			,0.0	,0.0	,0.0
		From (
		Select TOP (@GamesBack1)	@GamesBack1 as GamesBack
		
		,	b.GameDate, b.Team, b.Venue, b.Opp
		--				 OT already Out		|				Take out Last Min										|		--	' 1 + (((TmTL / ScReg) - 1) * Curve_Pct)	
			, (
				 (b.ShotsActualMadeUsRegPt1 - IsNull(bL5.Q4Last1MinPt1Us, @LastMinPt1) + @LastMinPt1) * ( 1 + (( (r.TotalLineTeam  / b.ScoreRegTeam ) - 1) * @Curve_Pct) )
				) * 1	AS AverageMadeUsPt1

			, (
				 (b.ShotsActualMadeUsPt1 - IsNull(bL5.Q4Last1MinPt1Us, @LastMinPt1) + @LastMinPt1)
				 *  cast((b.ScoreRegTeam / b.ScoreOTTeam) as float)
				 * ( 1 + (( (r.TotalLineTeam  / b.ScoreRegTeam ) - 1) * @Curve_Pct) )
				) * 1	AS MadeUsAdjPt1ALT

			, b.ShotsActualMadeUsRegPt1
			
			, bL5.Q4Last1MinPt1Us, tm.TotalLine, tm.SideLine, r.TotalLineTeam as TLteam, b.ScoreRegTeam as TeamScReg,  @Curve_Pct as CurPct
			, Cast(( 1 + (( (r.TotalLineTeam  / b.ScoreRegTeam ) - 1) * @Curve_Pct) ) as float) as CurvePctFac
			, cast((  Cast( b.ScoreRegTeam as float)   /   b.ScoreOTTeam   ) as float) as otFac, b.ScoreRegTeam, b.ScoreOTTeam

		--	,  bl5.*		 -- bl5.team, bl5.Venue
		

		--, b.*
		From BoxScores b
			JOIN TodaysMatchups tm on tm.GameDate = b.GameDate and tm.RotNum = dbo.udfAwayRotNum(b.RotNum)
			JOIN Rotation r ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
		 Left JOIN BoxScoresLast5Min bL5 ON bL5.GameDate = b.GameDate AND  bL5.RotNum = b.RotNum
		Where b.LeagueName = @LeagueName
		 AND	b.Team =	 @Team
		 AND  b.Venue = @Venue
		 Order BY b.GameDate DESC


--	
) x

Select * FROM TeamStatsAverages