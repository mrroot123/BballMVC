Declare @UserName	varchar(10)	= 'Test'
		, @LeagueName varchar(8) = 'NBA'
		, @GameDate Date		= '01/07/2020'
		, @EndDate  Date		= '12/23/2019' -- 1/9/2020 - not referenced
		, @CurveBxScPct float	= .667
		, @CurveOppPct  float	= .667

		, @Season varchar(4) = '1920'
		, @SubSeason VarChar(10) = '1-reg'
--		, @SubSeason2 VarChar(10) = '1-reg'

SELECT 
	   AVG(x.ShotsMadeOpRegPt1)
	,  AVG(x.ShotsMadeOpRegPt2)
	,  AVG(x.ShotsMadeOpRegPt3) 

	,  AVG(x.ShotsMadeUsRegPt1)
	,  AVG(x.ShotsMadeUsRegPt2)
	,  AVG(x.ShotsMadeUsRegPt3) 
 FROM (
	SELECT TOP (300) b.* 
	 FROM BoxScores b 
		WHERE b.Exclude = 0 AND b.LeagueName = @LeagueName  
		AND b.Venue = 'Home'  -- Constant
		AND b.GameDate < @GameDate
		AND b.Season = @Season
		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
		Order by b.GameDate desc
	) x