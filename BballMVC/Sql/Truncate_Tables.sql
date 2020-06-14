/****** Script for SelectTopNRows command from SSMS  ****** /

Truncate
Sead
Run .net LoadBoxscores

*/

  use [00TTI_LeagueScores]

  Select
  (SElect Count(*) From BoxScores)  as 'BoxScores Rows'
	, (SElect Count(*) From BoxScoresLast5Min)  as 'BoxScoresLast5Min Rows'
	, (SElect Count(*) From Rotation)  as 'Rotation Rows'
	, (SElect Count(*) From DailySummary)  as 'DailySummary Rows'
	, (SElect Count(*) From TeamStrength)  as 'TeamStrength Rows'

  Truncate Table  [BoxScoresLast5Min]
  truncate Table BoxScores
  truncate Table Rotation
  truncate Table DailySummary
--  truncate Table TeamStrength


