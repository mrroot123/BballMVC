/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (50) [TeamStrengthID]
	, [TeamStrengthBxScAdjPctScored] as BSadj
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Venue]
,Round(TeamStrength, 2) as TeamStrength
,Round(TeamStrengthScored, 2) as TeamStrengthScored
,Round(TeamStrengthAllowed, 2) as TeamStrengthAllowed
,Round(TeamStrengthBxScAdjPctScored, 2) as TeamStrengthBxScAdjPctScored
,Round(TeamStrengthBxScAdjPctAllowed, 2) as TeamStrengthBxScAdjPctAllowed
,Round(TeamStrengthTMsAdjPctScored, 2) as TeamStrengthTMsAdjPctScored
,Round(TeamStrengthTMsAdjPctAllowed, 2) as TeamStrengthTMsAdjPctAllowed

      ,[Volatility]
      ,[Pace]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[TeamStrength]
  	 where abs(TeamStrengthBxScAdjPctScored) > 1.1 or abs(TeamStrengthBxScAdjPctAllowed) > 1.2
	--  GameDate = '7/26/2020'		--  < '6/28/2021' -- and team = 'Con'
--	 and LeagueName = 'wnba'
	  order by  abs(TeamStrengthBxScAdjPctScored) desc
		-- GameDate desc
