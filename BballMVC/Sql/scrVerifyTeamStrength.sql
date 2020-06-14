/****** Script for SelectTopNRows command from SSMS  ******/
	Declare
			  @LeagueName varchar(10) = 'NBA'
			,  @Team varchar(10) = 'bos'
			, @Venue varchar(4) = 'away'
			, @Season varchar(4) = '1920'
			, @SubSeason VarChar(10) = '1-reg'
			, @TeamAway varchar(8)	= 'atl'
			, @TeamHome varchar(8) = 'bos'
			, @RotNum int	
			, @ixVenue as int
			, @GameTime varchar(5)
			, @GameDate date = '3/6/2020'
	;

SELECT TOP 1 [TeamStrengthID]
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Venue]
      ,[TeamStrength]
      ,[TeamStrengthScored]
      ,[TeamStrengthAllowed]
      ,[TeamStrengthBxScAdjPctScored]
      ,[TeamStrengthBxScAdjPctAllowed]
      ,[TeamStrengthTMsAdjPctScored]
      ,[TeamStrengthTMsAdjPctAllowed]
  FROM [00TTI_LeagueScores].[dbo].[TeamStrength] ts
  where  ts.LeagueName = @LeagueName
	 AND ts.GameDate < @GameDate
    AND ts.Team = @Team
    AND ts.Venue = @Venue
  order by GameDate desc

  
SELECT TOP 1000 [TeamStrengthID]
      ,[LeagueName]
      ,[GameDate]
      ,[RotNum]
      ,[Team]
      ,[Venue]
      ,[TeamStrength]
      ,[TeamStrengthScored]
      ,[TeamStrengthAllowed]
      ,[TeamStrengthBxScAdjPctScored]
      ,[TeamStrengthBxScAdjPctAllowed]
      ,[TeamStrengthTMsAdjPctScored]
      ,[TeamStrengthTMsAdjPctAllowed]
  FROM [00TTI_LeagueScores].[dbo].[TeamStrength] ts
  where  ts.LeagueName = @LeagueName
--	 AND ts.GameDate < @GameDate
    AND ts.Team = @Team
    AND ts.Venue = @Venue
  order by GameDate  desc