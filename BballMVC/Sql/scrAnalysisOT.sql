/****** Script for SelectTopNRows command from SSMS  ******/
Declare @Var float = 1.6;

SELECT x.Season, count(*) as Games
      ,Round(Avg([ScoreReg]), 2) as Reg
      ,Round(AVG( [ScoreOT]), 2) as Final
		,Round(AVG( [ScoreOT])-Avg([ScoreReg]), 2) as OTamt
		,Round(AVG( ScoreOT-ScoreReg), 2) as OTamt2
		, Sum(x.OverReg) as OverReg
		, Sum(x.UnderReg) as UnderReg

		, round((Sum(x.OverReg) * 100.0) / (  Sum(x.OverReg) +  Sum(x.UnderReg)), 4) as OverRegPct

		, Sum(x.OverFinal) as OverFinal
		, Sum(x.UnderFinal) as UnderFinal
  FROM (
	Select 1 as Season -- b.Season
	 ,[ScoreReg], ScoreOT
	, Case When ScoreReg + @Var > r.TotalLine then 1 else 0 END as 'OverReg'
	, Case When ScoreReg + @Var  < r.TotalLine then 1 else 0 END as 'UnderReg'
	, Case When ScoreOT   > r.TotalLine then 1 else 0 END as 'OverFinal'
	, Case When ScoreOT  < r.TotalLine then 1 else 0 END as 'UnderFinal'
    From [00TTI_LeagueScores].[dbo].[BoxScores] b
	  Join Rotation r on r.GameDate = b.GameDate and r.RotNum = b.RotNum
		where b.LeagueName= 'WNBA' and b.Venue = 'away'
		--
		) x
		Group by x.Season
		order by x.Season desc