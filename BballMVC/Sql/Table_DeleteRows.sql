/****** Script for SelectTopNRows command from SSMS  ******/


  use [00TTI_LeagueScores]

  Select 
	  (SElect Count(*) From BoxScores)  as 'BoxScores Rows'						, (SElect Max(b.GameDate) From BoxScores b)  as 'BxSc Max GameDate'  
	, (SElect Count(*) From BoxScoresLast5Min)  as 'BoxScoresLast5Min Rows'	, (SElect Max(GameDate) From BoxScoresLast5Min)  as 'L5Min Max GameDate'  
	, (SElect Count(*) From Rotation)  as 'Rotation Rows'							, (SElect Max(GameDate) From Rotation)  as 'Rotation Max GameDate'  
	, (SElect Count(*) From DailySummary)  as 'DailySummary Rows'				, (SElect Max(GameDate) From DailySummary)  as 'Daily Max GameDate'  


Declare @DeleteDate Date = dbo.udfYesterday()
	Delete from BoxScores			where GameDate >= @DeleteDate
	Delete from BoxScoresLast5Min where GameDate >= @DeleteDate
	Delete from Rotation				where GameDate >= @DeleteDate
	Delete from DailySummary		where GameDate >= @DeleteDate
