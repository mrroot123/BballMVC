Declare @AdjPct as float = .67

Declare @AvgScore float
		, @AvgScoreHome float
		, @AvgScoreAway float

	 Select -- 'LeagueAvgs'
		  @AvgScore		 = Avg(ScReg + ScRegOpp)    
		, @AvgScoreHome = Avg(ScReg )
		, @AvgScoreAway = Avg(ScRegOpp ) 
--		, Min([Date]) as StartDate   
	  From 
	  (
		Select TOP 300 ScReg
			, ScRegOpp
			, [Date]   From V1_BoxScores         
			Where LeagueName = 'NBA'          
			  AND  Date < '12/20/2019'
			  AND  H_A = 'Home' 
			  AND  GameType = '1-Reg'         
			ORDER By Date DESC        
		) x

SELECT
		Avg(q2.TmStrPtsScored) as AvgTmStrPtsScored
	,	Avg(q2.TmStrPtsAllowed) as AvgTmStrPtsAllowed
	
	FROM
	(
		SELECT 
			  q1.TmTL	 + ((q1.ScReg    - q1.TmTL) * @AdjPct) * (q1.Lg_Avg_Sc_Our_Venue / q1.TmStrPtsAllowedOpp) as TmStrPtsScored
			, q1.TmTLOpp + ((q1.ScRegOpp - q1.TmTL) * @AdjPct) * (q1.Lg_Avg_Sc_Opp_Venue / q1.TmStrPtsScoredOpp)  as TmStrPtsAllowed
			, *
			From
			(
				SELECT top 10 
					  b2.TmStrPtsScored as TmStrPtsScoredOpp, b2.TmStrPtsAllowed as TmStrPtsAllowedOpp
					, b.Date
					, b.Opp
					, b.ScReg
					, b.ScRegOpp
					, b.SideLine
					, b.TotalLine  
					, (b.TotalLine - b.SideLine) / 2 as TmTL
					, (b.TotalLine + b.SideLine) / 2 as TmTLOpp
					, ((b.TotalLine - b.SideLine) / 2) + ((b.ScReg - ((b.TotalLine - b.SideLine) / 2)) * @AdjPct)  as TmStrPtsScoredx
					, Case When  b.H_A = 'Away' Then @AvgScoreAway Else @AvgScoreHome end 	AS Lg_Avg_Sc_Our_Venue 
					, Case When  b.H_A = 'Home' Then @AvgScoreAway Else @AvgScoreHome end 	AS Lg_Avg_Sc_Opp_Venue 
				 FROM V1_BoxScores b
				 INNER JOIN V1_BoxScores b2	ON b2.LeagueName = b.LeagueName AND b2.Date = b.Date AND b2.Team = b.Opp
				 WHERE b.LeagueName = 'NBA' 
					AND b.Date < '12/20/2019'  
					AND b.Team = 'IND'   
					AND b.H_A = 'Home'  
					AND b.GameType = '1-Reg' 
				 ORDER By b.Date DESC 
			) q1
	) q2