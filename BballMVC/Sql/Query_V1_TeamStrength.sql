use [00TTI_LeagueScores]


Declare	-- All IP Parms
		  @LeagueName varchar(10) = 'NBA'	-- 0 IP Parm
		, @GameDate Date	= '12/18/2019'		-- 1 IP
		, @Team varchar(10) = 'IND'			-- 2 IP
		, @Venue varchar(10) = 'Home'			-- 3 
		, @GameType varchar(10) = '1-Reg'	-- 4
		, @TmStrAdjPct  float = .70			-- 6
		, @BxScAdjPct float = .30
		, @AvgLgScoreHome float = 111.21		-- 8  	108.3566667
		, @AvgLgScoreAway float	= 108.3566667 -- 9
		, @varLgAvgGamesBack int = 1


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
			--	 JOIN BoxScores b2	ON b2.LeagueName = b.LeagueName 	AND b2.GameDate = b.GameDate 	AND b2.Team = b.Opp
				 JOIN Rotation r		ON r.GameDate = b.GameDate AND r.RotNum = b.RotNum
				 --WHERE b.LeagueName = 'NBA' 
					--AND b.Date <= '1/1/2020'	-- VERIFY should it be <=???
					--AND b.Team = 'ATL'   
					--AND b.H_A = 'Home'  
					--AND (b.GameType = '1-Reg'  OR b.GameType = '1-Reg' )
				 WHERE b.LeagueName = @LeagueName 
					AND b.GameDate < @GameDate		-- @GameDate is Today, So get Dates < Today
					AND b.Team = @Team   
					AND b.Venue = @Venue  
					AND (b.SubSeason = @GameType OR b.SubSeason = '1-Reg' )
				 ORDER By b.GameDate DESC 

/*
				SELECT TOP (@varLgAvgGamesBack)
					  b2.TmStrPtsScored  as TmStrPtsOppScored
					, b2.TmStrPtsAllowed as TmStrPtsOppAllowed
					, b.Opp
					, b.ScReg		as ScRegUs
					, b.ScRegOpp	as ScRegOp
					, b.SideLine
					, b.TotalLine  
					, (b.TotalLine - b.SideLine) / 2 as TmTLUs
					, (b.TotalLine + b.SideLine) / 2 as TmTLOp
					, Case When  b.H_A = 'Away' Then @AvgLgScoreAway Else @AvgLgScoreHome end 	AS LgAvgScVenueUs
					, Case When  b.H_A = 'Home' Then @AvgLgScoreAway Else @AvgLgScoreHome end 	AS LgAvgScVenueOp 
				 FROM BoxScores b
				 INNER JOIN BoxScores b2	ON b2.LeagueName = b.LeagueName 
							AND b2.Date = b.Date 
							AND b2.Team = b.Opp
				 --WHERE b.LeagueName = 'NBA' 
					--AND b.Date <= '1/1/2020'	-- VERIFY should it be <=???
					--AND b.Team = 'ATL'   
					--AND b.H_A = 'Home'  
					--AND (b.GameType = '1-Reg'  OR b.GameType = '1-Reg' )
				 WHERE b.LeagueName = @LeagueName 
					AND b.Date < @GameDate		-- @GameDate is Today, So get Dates < Today
					AND b.Team = @Team   
					AND b.H_A = @Venue  
					AND (b.GameType = @GameType OR b.GameType = '1-Reg' )
				 ORDER By b.Date DESC */


			) q1
	) q2