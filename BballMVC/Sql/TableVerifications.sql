
  use [00TTI_LeagueScores]

  Select
  (SElect Count(*) From BoxScores where Source <> 'Seeded')  as 'BoxScores Rows'
	, (SElect Count(*) From BoxScoresLast5Min)  as 'BoxScoresLast5Min Rows'
	, (SElect Count(*) From Rotation)  as 'Rotation Rows'

	Select '' as x
		, b.GameDate AS b_GameDate, b.RotNum as b_RotNum
		,L5.GameDate AS L5_GameDate, L5.RotNum as L5_RotNum
		,ts.GameDate AS TS_GameDate, ts.RotNum as TS_RotNum
		, r.GameDate AS r_GameDate, r.RotNum AS r_RotNum
	  From (	Select * From BoxScores  where Source <> 'Seeded') b
	   FULL OUTER JOIN BoxScoresLast5Min L5 ON L5.GameDate = b.GameDate AND L5.RotNum = b.RotNum	   
	   FULL OUTER JOIN (select * from TeamStrength where GameDate > '10/1/2018') ts ON ts.GameDate = b.GameDate AND ts.RotNum = b.RotNum	   
		FULL OUTER JOIN ( Select * from Rotation Where GameDate < CONVERT(date, getdate()) 
		) r				 ON  r.GameDate = b.GameDate AND  r.RotNum = b.RotNum
		Where b.GameDate is null 
		  OR L5.GameDate is null
		  OR  r.GameDate is null
		  OR  ts.GameDate is null

