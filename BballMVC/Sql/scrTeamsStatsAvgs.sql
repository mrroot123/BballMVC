/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

--> Team Strength by Team for Season

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = convert(Date, GetDate())
			  , @StartDate date = GetDate()
			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '2021'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
			, @VolatilityGamesBack int = 10
			, @Decs int = 2	-- Decimal places
	;

Declare @tblTeams TABLE ( Team varchar(4) )


Insert Into @tblTeams
SELECT  distinct -- 'Team',
 [TeamNameInDatabase]
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where enddate is null and LeagueName = @LeagueName

--  Select * from @tblTeams
Set @StartDate = '12/24/2020'
Select *, Round((OffPct + DefPct - 2.0) * 100 ,0) as FinalPct
 From (	-- q1
  Select tt.Team
		,(	 Select count(*)  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @StartDate) as Games
		,(	 Select Round(Avg(b.ScoreRegUs+b.ScoreRegOp),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @StartDate) as Total
		,(	 Select Round(Avg(b.ScoreRegUs),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @StartDate) as Scored
		,tsj.TSScored
		,(	 Select Round(Avg(b.ScoreRegOp),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @StartDate) as Allowed
		,tsj.TSAllowed
	--	, Round(ts.TeamStrength,1) as TeamStrength,  Round(ts.TeamStrengthScored,1) as TS_Scored,  Round(ts.TeamStrengthBxScAdjPctAllowed,1) as TS_Allowed
		, 	 Round(dbo.udfCalcVolatility (@UserName, convert(date, getdate()), @LeagueName, @Season, tt.Team, @VolatilityGamesBack), 1) as Volatility
		,tsj.ts
		
		,Round((
			Select top 1  TeamStrengthTMsAdjPctScored  From TeamStrength ts
			Where ts.LeagueName = @LeagueName  AND ts.GameDate <= @GameDate  And ts.Team = tt.Team
		), 2) as OffPct
		,Round((
			Select top 1  TeamStrengthTMsAdjPctAllowed  From TeamStrength ts
			Where ts.LeagueName = @LeagueName  AND ts.GameDate <= @GameDate  And ts.Team = tt.Team
		), 2) as DefPct

    From @tblTeams tt

	Join 
			(
				Select Team as tsTeam
					, min(GameDate) as tsStartDate
					
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
								ROW_NUMBER() OVER(PARTITION BY Team ORDER BY [GameDate] DESC)
						) qts
						Group By qts.Team
			) tsj on tsj.tsTeam = tt.Team
	) q1
	Order by FinalPct desc
		,q1.Total desc
--	 Select Round(Avg(b.ScoreRegUs),1) as Scored  From BoxScores b	 Where b.Team = @Team and b.LeagueName = @LeagueName and b.Season = @Season
