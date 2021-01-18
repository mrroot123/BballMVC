/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()
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
	;

Declare @tblTeams TABLE ( Team varchar(4) )


Insert Into @tblTeams
SELECT  distinct -- 'Team',
 [TeamNameInDatabase]
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where enddate is null and LeagueName = @LeagueName

--  Select * from @tblTeams
Set @GameDate = '12/24/2020'
Select *
 From (
  Select tt.Team
		,(	 Select count(*)  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @GameDate) as Games
		,(	 Select Round(Avg(b.ScoreRegUs+b.ScoreRegOp),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @GameDate) as Total
		,(	 Select Round(Avg(b.ScoreRegUs),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @GameDate) as Scored
		,(	 Select Round(Avg(b.ScoreRegOp),1) as Scored  From BoxScores b	 Where b.Team = tt.Team and b.LeagueName = @LeagueName and b.Season = @Season AND GameDate > @GameDate) as Allowed
	--	, Round(ts.TeamStrength,1) as TeamStrength,  Round(ts.TeamStrengthScored,1) as TS_Scored,  Round(ts.TeamStrengthBxScAdjPctAllowed,1) as TS_Allowed
		, 	 Round(dbo.udfCalcVolatility (@UserName, @GameDate, @LeagueName, @Season, tt.Team, @VolatilityGamesBack), 1) as Volatility

    From @tblTeams tt
--	 Left Join TeamStrength ts					ON ts.GameDate = @GameDate  AND  ts.LeagueName = @LeagueName  AND  ts.Team = tt.Team
	) q1
	Order by 
		q1.Total desc
--	 Select Round(Avg(b.ScoreRegUs),1) as Scored  From BoxScores b	 Where b.Team = @Team and b.LeagueName = @LeagueName and b.Season = @Season
