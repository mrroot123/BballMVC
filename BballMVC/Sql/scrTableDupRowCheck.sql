/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 'TodaysMatchups', GameDate, RotNum, Count(*) From TodaysMatchups	 Group by GameDate, RotNum Having count(*) > 1 Order by GameDate, RotNum
SELECT 'Rotation', GameDate, RotNum,   Count(*) From Rotation			 Group by GameDate, RotNum Having count(*) > 1	Order by GameDate, RotNum
SELECT 'Boxscores', GameDate, RotNum,   Count(*) From Boxscores		 Group by GameDate, RotNum Having count(*) > 1	Order by GameDate, RotNum
--SELECT GameDate, RotNum, Count(*) From TodaysMatchups	 Group by GameDate, RotNum Having count(*) > 1
