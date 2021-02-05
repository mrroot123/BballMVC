-- Run in SqlExpress2012 ???
use [00TTI_LeagueScores_10_03]

Declare @q1 bit = 0
		, @Q2 bit = 01
		, @Q3 bit = 0



IF @q1 = 1
BEGIN
Declare @GrpSz int = 2
Select 
    'Q1' as Query, q1.LeagueName
	, q1.Grp
	, ((q1.Grp * @GrpSz) + @GrpSz-1) as Pts
	, Count(*) as Games
	, sum(OT) as OT
--	, sum(OTxxx) as OTxxx
	, round(((sum(OT) * 100) / convert( float, count(*))),2) as Pct

  From (
		Select  --top 50
		  (Convert(int,	Abs(b.SideLine)) / @GrpSz) as Grp
		  , b.SideLine as SidePrice
--		  , (case when minutesPlayed > 4 8 then 1 else 0 end) as OTxxx
		  , (case when b.ScReg+b.ScRegOpp < b.ScOT+b.ScOTOpp then 1 else 0 end) as OT
			,*
		From V1_BoxScores b
		 where H_A = 'Away'
	) q1
	Group By q1.LeagueName, q1.Grp
	Order By q1.LeagueName, q1.Grp
END

IF @Q2 = 1
BEGIN
select --
-- q1.* / *
	q1.LeagueName--, q1.Season
	, Count(*) as OT_Games
	, Sum(Case 	when q1.ScoreReg < q1.TotalLine AND q1.ScoreOT > q1.TotalLine then 1 	else 0   end) as  OTed
	, Sum(Case 	when q1.ScoreReg = q1.TotalLine OR  q1.ScoreOT = q1.TotalLine then 1 	else 0   end) as  Half_OT
--	, Sum(Case 	when q1.ScoreOt < q1.TotalLine  then 1 	else 0   end) as  Under
	, Sum(Case 	when q1.ScoreReg > q1.TotalLine  then 1 	else 0   end)  as  OverInReg
	, Sum(Case 	when q1.ScoreReg < q1.TotalLine  then 1 	else 0   end)  as  UnderInReg
 -- */
 From(
		SELECT --		top 30 
		  b.LeagueName--, b.Season

		 ,b.TotalLine
		 , b.ScReg, b.ScRegOpp 
		 , b.ScReg + b.ScRegOpp as ScoreReg
		 , b.ScOT, b.ScOTOpp 
		 , b.ScOT + b.ScOTOpp as ScoreOT
	--	, *
		  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores] b
			where  b.ScReg+b.ScRegOpp < b.ScOT+b.ScOTOpp
			--minutesPlayed > 48 
) q1
group by LeagueName--, Season
Order by LeagueName--, Season
END

IF @Q3 = 1
BEGIN
SELECT 
	LeagueName
	,  b.uo_Game
	, count(*) as Games

	, Sum(Case 
	when b.ScoreReg < b.TotalLine AND b.ScoreOT > b.TotalLine then 1 
	else 0 
  end) as  OTed
, Sum(Case 
	when b.ScoreReg = b.TotalLine OR  b.ScoreOT = b.TotalLine then 1 
	else 0 
  end) as  Half_OT
, Sum(Case 
	when b.ScoreOt < b.TotalLine  then 1 
	else 0 
  end) as  Under
, Sum(Case 
	when b.ScoreReg > b.TotalLine  then 1 
	else 0 
  end)  as  OvrInReg

from(
Select
	b.LeagueName
	, b.uo_Game
	, ScReg+b.ScRegOpp as ScoreReg
	, ScOT+b.ScOTOpp as ScoreOT
	, b.TotalLine

  -- select count(*)
  FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores] b
	where b.H_A = 'Home'
	) b
  group by b.LeagueName, b.uo_Game
  order by b.LeagueName, b.uo_Game
END