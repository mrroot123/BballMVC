use [00TTI_LeagueScores]
--
--- Results pasted in Analysis.xlsx 
--
Declare @LeagueName varchar(10) = 'NBA', @Season varchar(4), @GameDate Date
Declare @VolAway float, @VolHome float,  @TmStrAway float, @TmStrHome float
	, @PtMade1 float, @PtAtmp1 float
	, @PtMade2 float, @PtAtmp2 float
	, @PtMade3 float, @PtAtmp3 float

	, @PtAllowed1 float, @PtAtmpAllowed1 float
	, @PtAllowed2 float, @PtAtmpAllowed2 float
	, @PtAllowed3 float, @PtAtmpAllowed3 float

	, @Wins int	, @Losses int	
	, @UnderWins int	, @UnderLosses int
	, @OverWins int	, @OverLosses int
	, @Venue varchar(4)
	, @GB int


Declare @TeamStats TABLE (
Team Varchar(4), Venue varchar(4),Vol float, TmStr float
	, PtMade1 float, PtAtmp1 float
	, PtMade2 float, PtAtmp2 float
	, PtMade3 float, PtAtmp3 float

	, PtAllowed1 float, PtAtmpAllowed1 float
	, PtAllowed2 float, PtAtmpAllowed2 float
	, PtAllowed3 float, PtAtmpAllowed3 float
	, Wins int	, Losses int	

	, UnderWins int, UnderLosses int
	, OverWins int	, OverLosses int
)

Set @Season = '2021'		
Set @GameDate  = Getdate()
Set @Venue = 'Both'

Declare @Teams TABLE (Team Varchar(4))
Insert INTO @Teams
Exec uspQueryTeams  @LeagueName, @GameDate
--Select * From @Teams; return;

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
BEGIN		-- Loop for each Team
---- Get next @Team
	Select Top 1  @Team = Team
		From @Teams
		Where Team > @Team
		Order by Team
	If @@ROWCOUNT = 0
		BREAK;

	-- Get LATEST GameDate and MAX GB
	Declare @LastGameDate date
	Select Top 1 @LastGameDate = GameDate, @GB = GB
		From TeamStatsAverages
		Where LeagueName = @LeagueName and GameDate <= @GameDate 
		  and (Venue = @Venue or @Venue = 'Both')
		Order by GameDate desc, GB Desc

	Declare @Ctr int = 0
	Set @Venue = 'Both'
	declare @VenueLoops int = 2
	If  @Venue = 'Both'
		Set @VenueLoops = 1

	WHILE @Ctr < @VenueLoops
	BEGIN		-- Loop for each Team VENUE - once for BOTH
	-- TmStr Stats
		Select top 1 
			@VolAway = Round(Volatility,1) ,@TmStrAway = Round(TeamStrength,1)
		  from TeamStrength ts
			Where GameDate <= @LastGameDate AND Team = @Team and (ts.Venue = @Venue or @Venue = 'Both')
			order by GameDate desc
	-- TSA Stats
	  SELECT TOP (1)
			@PtMade1 = Round(AverageMadeUsPt1,1) ,@PtAtmp1 = Round(AverageAtmpUsPt1,1)
		 ,	@PtMade2 = Round(AverageMadeUsPt2,1) ,@PtAtmp2 = Round(AverageAtmpUsPt2,1)
		 ,	@PtMade3 = Round(AverageMadeUsPt3,1) ,@PtAtmp3 = Round(AverageAtmpUsPt3,1)
			
		 ,	@PtAllowed1 = Round(AverageMadeOpPt1,1) ,@PtAtmpAllowed1 = Round(AverageAtmpOpPt1,1)
		 ,	@PtAllowed2 = Round(AverageMadeOpPt2,1) ,@PtAtmpAllowed2 = Round(AverageAtmpOpPt2,1)
		 ,	@PtAllowed3 = Round(AverageMadeOpPt3,1) ,@PtAtmpAllowed3 = Round(AverageAtmpOpPt3,1)
		  FROM TeamStatsAverages
		  Where LeagueName = @LeagueName AND GameDate <= @LastGameDate 
		   AND GB = @GB
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
		  Where Season = @Season and LeagueName = @LeagueName
			and ( ((@Venue = 'Away' AND TeamAway = @Team) or (@Venue = 'Home')) or @Venue = 'Both')
			 AND TeamHome = @Team

		
		Insert Into @TeamStats
		Select @Team as Team, @Venue as Venue, @VolAway  ,@TmStrAway 
			,@PtMade1 as PtMade1 ,@PtAtmp1 as PtAtmp1
			,@PtMade2 as PtMade2 ,@PtAtmp2 as PtAtmp2
			,@PtMade3 as PtMade3 ,@PtAtmp3 as PtAtmp3

			,@PtAllowed1 as PtAllowed1 ,@PtAtmpAllowed1 as PtAtmpAllowed1
			,@PtAllowed2 as PtAllowed2 ,@PtAtmpAllowed2 as PtAtmpAllowed2
			,@PtAllowed3 as PtAllowed3 ,@PtAtmpAllowed3 as PtAtmpAllowed3

			, @Wins , @Losses 
			, @UnderWins , @UnderLosses 
			, @OverWins 	, @OverLosses 

		Set @Venue = 'Home'
		Set @Ctr = @Ctr + 1
	END
		
END

Declare @TeamStrengthGamesBack int, @GB3 int
Select top 1 
	@TeamStrengthGamesBack = TeamStrengthGamesBack, @GB3 = GB3
  From UserLeagueParms
	Where StartDate <= GetDate()
  Order by StartDate Desc
	
Select @LeagueName as LeagueName, @Season as Season, @GameDate as GameDate

--Select 'Top 30', Sum(q1.Wins) as W, Sum(q1.Losses) as L
--	From (
--	Select Top 30 * From @TeamStats
--	order by vol
--	) q1


--Select 'Bot 30', Sum(q1.Wins) as W, Sum(q1.Losses) as L
--	From (
--	Select Top 30 * From @TeamStats
--	order by vol Desc
--	) q1

Select t.Wins as Winss, t.Losses, 
	 t.PtMade1    +  t.PtMade2 *2    + t.PtMade3 * 3    as PtsScored
 ,	 t.PtAllowed1 +  t.PtAllowed2 *2 + t.PtAllowed3 * 3 as PtsAllowed
 , * From @TeamStats t
 order by wins desc