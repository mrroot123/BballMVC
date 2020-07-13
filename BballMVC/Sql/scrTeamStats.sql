use [00TTI_LeagueScores]

Declare @LeagueName varchar(10) = 'NBA', @Season varchar(4) = '1920'
		, @GameDate Date = Getdate()
Declare @VolAway float, @VolHome float,  @TmStrAway float, @TmStrHome float
	, @PtMade1 float, @PtAtmp1 float
	, @PtMade2 float, @PtAtmp2 float
	, @PtMade3 float, @PtAtmp3 float
	, @Wins int	, @Losses int	
	, @UnderWins int	, @UnderLosses int
	, @OverWins int	, @OverLosses int

, @Venue varchar(4)


Declare @TeamStats TABLE (
Team Varchar(4), Venue varchar(4),Vol float, TmStr float
	, PtMade1 float, PtAtmp1 float
	, PtMade2 float, PtAtmp2 float
	, PtMade3 float, PtAtmp3 float
	, Wins int	, Losses int	

	, UnderWins int, UnderLosses int
	, OverWins int	, OverLosses int
)

Declare @Teams TABLE (Team Varchar(4))
Insert INTO @Teams
Exec uspQueryTeams 'NBA'

--Select t.Team 
--	From @Teams t
--	Join (

--		Select top 1 
--		 Volatility
--	  from TeamStrength ts
--	  Where Team = t.Team and ts.Venue = 'Away'
--	  order by GameDate desc
--	  ) x on x.team = t.Team

Declare @Team varchar(4);
Set @Team = '';
While 1 = 1
BEGIN
---- Get next Rotation row by RotNum - Away or Home
	Select Top 1  @Team = Team
		From @Teams
		Where Team > @Team
		Order by Team

	If @@ROWCOUNT = 0
		BREAK;
	Declare @Ctr int = 0
	Set @Venue = 'Away'
	WHILE @Ctr < 2
	BEGIN
		Select top 1 @VolAway = Round(Volatility,1) ,@TmStrAway = Round(TeamStrength,1)
		  from TeamStrength ts
			Where GameDate <= @GameDate AND Team = @Team and ts.Venue = @Venue
			order by GameDate desc

	  SELECT TOP (1)
			@PtMade1 = Round(AverageMadeUsPt1,1) ,@PtAtmp1 = Round(AverageAtmpUsPt1,1)
		 ,	@PtMade2 = Round(AverageMadeUsPt2,1) ,@PtAtmp2 = Round(AverageAtmpUsPt2,1)
		 ,	@PtMade3 = Round(AverageMadeUsPt3,1) ,@PtAtmp3 = Round(AverageAtmpUsPt3,1)
		  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
		  Where  GameDate <= @GameDate AND  LeagueName = @LeagueName AND Venue = @Venue AND GB = 10
			AND Team = @Team
		  order by GameDate Desc

	  SELECT 
      @Wins = sum(UnderWin+overWin)
      ,@Losses = sum(UnderLoss+overLoss) 

      ,@UnderWins = sum([UnderWin]) 
      ,@UnderLosses = sum([UnderLoss]) 
      ,@OverWins = sum([OverWin]) 
      ,@OverLosses = sum([OverLoss]) 
		  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
		  Where Season = @Season 
			and ((@Venue = 'Away' AND TeamAway = @Team) or (@Venue = 'Home' AND TeamHome = @Team))

		
		Insert Into @TeamStats
		Select @Team as Team, @Venue as Venue, @VolAway  ,@TmStrAway 
			,@PtMade1 as PtMade1 ,@PtAtmp1 as PtAtmp1
			,@PtMade2 as PtMade2 ,@PtAtmp2 as PtAtmp2
			,@PtMade3 as PtMade3 ,@PtAtmp3 as PtAtmp3
			, @Wins , @Losses 
			, @UnderWins , @UnderLosses 
			, @OverWins 	, @OverLosses 

		Set @Venue = 'Home'
		Set @Ctr = @Ctr + 1
	END
		
END


Select 'Top 30', Sum(q1.Wins) as W, Sum(q1.Losses) as L
	From (
	Select Top 30 * From @TeamStats
	order by vol
	) q1


Select 'Bot 30', Sum(q1.Wins) as W, Sum(q1.Losses) as L
	From (
	Select Top 30 * From @TeamStats
	order by vol Desc
	) q1

Select  * From @TeamStats
 order by vol