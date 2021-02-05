use [00TTI_LeagueScores]

Declare @Decs int = 2, @LeagueName Varchar(10) = 'NBA'

Select Team 

,Round(Avg(TeamStrength), @Decs) as TS
,Round(Avg(TeamStrengthScored), @Decs) as TSScored
,Round(Avg(TeamStrengthTMsAdjPctScored), @Decs) as TSTMsAdjPctScored
,Round(Avg(TeamStrengthBxScAdjPctScored), @Decs) as TSBxScAdjPctScored

,Round(Avg(TeamStrengthAllowed), @Decs) as TSAllowed
,Round(Avg(TeamStrengthBxScAdjPctAllowed), @Decs) as TSBxScAdjPctAllowed

,Round(Avg(TeamStrengthTMsAdjPctAllowed), @Decs) as TSTMsAdjPctAllowed
  From (
		SELECT TOP 1	WITH TIES 
			*
		  FROM TeamStrength
		  where  LeagueName = @LeagueName
		  Order by 
			ROW_NUMBER() OVER(PARTITION BY Team+venue ORDER BY [GameDate] DESC)
	) q1
	Group By q1.Team
	Order by Avg(TeamStrengthScored) desc
