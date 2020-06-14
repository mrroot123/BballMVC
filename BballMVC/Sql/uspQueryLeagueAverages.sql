
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspQueryCalcTeamStrength]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspQueryCalcTeamStrength]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            01/06/2020
-- Description:            Calc Team Strength for a Team by GameDate & Venue
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
CREATE PROCEDURE [dbo].[uspQueryCalcTeamStrength] 
(       
		  @GameDate Date	= '12/18/2019'		-- 1 
		, @LeagueName varchar(10) = 'NBA'	-- 2 
		, @Team varchar(10) = 'IND'			-- 3 
		, @Venue varchar(10) = 'Home'			-- 4 
		, @GameType varchar(10) = '1-Reg'	-- 5
		, @TmStrAdjPct  float = .70			-- 6
		, @BxScAdjPct float = .30				-- 7
		, @AvgLgScoreHome float = 111.21		-- 8  	
		, @AvgLgScoreAway float	= 108.35667 -- 9
		, @varLgAvgGamesBack int = 1			-- 10  
)
AS
SET NOCOUNT ON;
              
BEGIN  
	SELECT
		Avg(q2.TmStrPtsScored) as AvgTmStrPtsScored
	,	Avg(q2.TmStrPtsAllowed) as AvgTmStrPtsAllowed
	
	FROM
	(
		SELECT 

		--   TmTL Aw/Hm + {  (ScReg     - TmTL)    *   .67       } * 

		   ( q1.ScRegUs + ((TmTLUs - q1.ScRegUs) * @BxScAdjPct) )   *  (  ( ((q1.LgAvgScVenueOp / q1.TmStrPtsOppAllowed) - 1.00) * @TmStrAdjPct ) + 1.00)	 as TmStrPtsScored   -- Our Offence
		,  ( q1.ScRegOp + ((TmTLOp - q1.ScRegOp) * @BxScAdjPct) )   *  (  ( ((q1.LgAvgScVenueUs / q1.TmStrPtsOppScored ) - 1.00) * @TmStrAdjPct ) + 1.00)	 as TmStrPtsAllowed  -- Our Defence

			, *
			From
			(

				SELECT TOP (@varLgAvgGamesBack)
					  ts.TeamStrengthScored  as TmStrPtsOppScored
					, ts.TeamStrengthAllowed as TmStrPtsOppAllowed
					, b.GameDate
					, b.Opp
					, b.ScoreRegUs		as ScRegUs
					, b.ScoreRegOp	as ScRegOp
					, r.SideLine
					, r.TotalLine  
					, r.TotalLineTeam as TmTLUs
					,  r.TotalLineOpp as TmTLOp
					, Case When  b.Venue = 'Away' Then @AvgLgScoreAway Else @AvgLgScoreHome end 	AS LgAvgScVenueUs
					, Case When  b.Venue = 'Home' Then @AvgLgScoreAway Else @AvgLgScoreHome end 	AS LgAvgScVenueOp 
				 FROM BoxScores b
				 JOIN TeamStrength ts	ON ts.LeagueName = b.LeagueName 	AND ts.GameDate = b.GameDate 	AND ts.Team = b.Opp
				 JOIN Rotation r		ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
				 WHERE b.LeagueName = @LeagueName 
					AND b.GameDate < @GameDate		-- @GameDate is Today, So get Dates < Today
					AND b.Team = @Team   
					AND b.Venue = @Venue  
					AND (b.SubSeason = @GameType OR b.SubSeason = '1-Reg' )
				 ORDER By b.GameDate DESC 

			) q1
	) q2
END
GO
