Use [00TTI_LeagueScores]

Declare @GamesBack int = 300
;

Declare @LgAvgShotsMadeAwayPt1 float, @LgAvgShotsMadeAwayPt2 float, @LgAvgShotsMadeAwayPt3 float
		, @LgAvgShotsMadeHomePt1 float, @LgAvgShotsMadeHomePt2 float, @LgAvgShotsMadeHomePt3 float
		, @OTpct float
		, @LeagueName nvarchar(10), @GameDate date, @Season varchar(4), @SubSeason varchar(20)
;

SET @LeagueName = 'NBA';
SET @GameDate = Convert(Date, GetDate());

SELECT @Season = Season, @SubSeason = SubSeason
	FROM SeasonInfo
	WHERE LeagueName = @LeagueName AND @GameDate BETWEEN StartDate and EndDate
			
SELECT @OTpct = AVG(x.ScoreReg / x.ScoreOT) 
	FROM (
	SELECT TOP (@GamesBack) b.* 
	 FROM BoxScores b 
		WHERE b.LeagueName = @LeagueName  
		AND b.Venue = 'Home'  -- Constant
		AND b.Season = @Season
		AND b.GameDate < @GameDate
		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
	 Order by b.GameDate desc
	) x
Print (@OTpct)

SELECT 
	  @LgAvgShotsMadeAwayPt1 = AVG(x.ShotsMadeOpRegPt1) * @OTpct 
	, @LgAvgShotsMadeAwayPt2 = AVG(x.ShotsMadeOpRegPt2) * @OTpct 
	, @LgAvgShotsMadeAwayPt3 = AVG(x.ShotsMadeOpRegPt3) * @OTpct 

	, @LgAvgShotsMadeHomePt1 = AVG(x.ShotsMadeUsRegPt1) * @OTpct 
	, @LgAvgShotsMadeHomePt2 = AVG(x.ShotsMadeUsRegPt2) * @OTpct 
	, @LgAvgShotsMadeHomePt3 = AVG(x.ShotsMadeUsRegPt3) * @OTpct 
 FROM (
	SELECT TOP (@GamesBack) b.* 
	 FROM BoxScores b 
		WHERE b.Exclude = 0 AND b.LeagueName = @LeagueName  
		AND b.Venue = 'Home'  -- Constant
		AND b.GameDate < @GameDate
		AND b.Season = @Season
		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
		Order by b.GameDate desc
	) x

Select 'Lg Avg Away', @LgAvgShotsMadeAwayPt1 , @LgAvgShotsMadeAwayPt2 , @LgAvgShotsMadeAwayPt3 
	   , 'Lg Avg Home', @LgAvgShotsMadeHomePt1 , @LgAvgShotsMadeHomePt2 , @LgAvgShotsMadeHomePt3 



SELECT  Count(*) as Games
	, Min(x.GameDate) as StartDate
	, Max(x.GameDate) as EndDate
	, Round(AVG(x.ScoreReg), 2) as LgAvgReg
	, Round(AVG(x.ScoreRegOp), 2) as LgAvgRegAway
	, Round(AVG(x.ScoreRegUs), 2) as LgAvgRegHome
	, Round(AVG(x.ScoreOT), 2) as LgAveOT

	, Round(AVG(x.ShotsMadeOpRegPt1) * @OTpct, 2) as AvgShotsMadeAwayPt1
	, Round(AVG(x.ShotsMadeOpRegPt2) * @OTpct, 2) as AvgShotsMadeAwayPt2
	, Round(AVG(x.ShotsMadeOpRegPt3) * @OTpct, 2) as AvgShotsMadeAwayPt3

	, Round(AVG(x.ShotsMadeUsRegPt1) * @OTpct, 2) as AvgShotsMadeHomePt1
	, Round(AVG(x.ShotsMadeUsRegPt2) * @OTpct, 2) as AvgShotsMadeHomePt2
	, Round(AVG(x.ShotsMadeUsRegPt3) * @OTpct, 2) as AvgShotsMadeHomePt3
	FROM (
	SELECT TOP (@GamesBack) b.* 
	 FROM BoxScores b 
		WHERE b.LeagueName = @LeagueName  
		AND b.Venue = 'Home'  -- Constant
		AND b.GameDate < @GameDate
		AND b.Season = @Season
		AND ( b.SubSeason = @SubSeason OR  b.SubSeason = '1-Reg' )
		Order by b.GameDate desc
	) x



/*
 FROM V1_BoxScores  
WHERE LeagueName = 'NBA'  
	AND H_A = 'Away'  
	AND [Date] > '1/1/2019'
	AND  GameType = '1-Reg'
	Order by [Date] desc


	SELECT TOP 300 * 
	 FROM V1_BoxScores  
WHERE LeagueName = 'NBA'  
	AND H_A = 'Away'  
	AND [Date] < '1/1/2019'
	AND  GameType = '1-Reg'
	Order by [Date] desc


		, (avg(ScReg + ScRegOpp) / avg(ScOT + ScOTOpp)) AS OTfactor
	,    avg(FGM2PT) AS Avg2PT
	, avg(FGM2PTopp) AS Avg2PTOpp
	,    avg(FGM3PT) AS Avg3PT
	, avg(FGM3PTopp) AS Avg3PTOpp
	,     avg(FTM) AS AvgFTM
	, avg(FTMopp) AS AvgFTMOpp
	,    avg(FGA2PT) AS Avg2PTa
	, avg(FGA2PTopp) AS Avg2PTaOpp
	,    avg(FGA3PT) AS Avg3PTa
	, avg(FGA3PTopp) AS Avg3PTaOpp
	,     avg(FTA) AS AvgFTa
	, avg(FTAopp) AS AvgFTaOpp   
	, Min(Date) AS StartDate  
	, Max(Date) AS EndDate  
	, avg(ScReg + ScRegOpp) as AvgScore  
	, avg(ScOT + ScOTOpp) as AvgFinal 
	*/