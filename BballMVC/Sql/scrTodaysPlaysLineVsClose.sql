/****** Script for SelectTopNRows command from SSMS  ******/

 Select avg(OpenLineDiff) as AvgOpenLineDiff, avg(CloseLineDiff) as AvgCloseLineDiff, avg(Juice) as AvgJuice From (
	SELECT tp.[GameDate]
    
			,tp.[RotNum]
   
			,tp.[TeamAway]
			,tp.[TeamHome]    
			,tp.[PlayDirection]
			,tp.[Line] as PlayedLine

			,  dbo.GetOpeningLine (tp.GameDate, tp.RotNum, 'Tot', 'Game') as OpenLine
			, r.TotalLine as CloseLine
			, case When tp.PlayDirection = 'Under' THEN  tp.[Line] -  dbo.GetOpeningLine (tp.GameDate, tp.RotNum, 'Tot', 'Game')
					Else    dbo.GetOpeningLine (tp.GameDate, tp.RotNum, 'Tot', 'Game') - tp.[Line]  
			  End as OpenLineDiff
			, case When tp.PlayDirection = 'Under' THEN  tp.[Line] - r.TotalLine
					Else   r.TotalLine - tp.[Line]  
			  End as CloseLineDiff

			, tp.Juice
	  FROM TodaysPlays tp
	  Join Rotation r ON r.GameDate = tp.GameDate and r.RotNum = tp.RotNum
	 -- order by tp.GameDate, tp.RotNum
  ) q1

-- Select * FROM TodaysPlays tp where GameDate = '2/2/2021'