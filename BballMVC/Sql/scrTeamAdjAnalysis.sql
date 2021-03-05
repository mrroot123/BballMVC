use [00TTI_LeagueScores]

	Declare
			  @UserName varchar(25) = 'Test', @LeagueName varchar(10) = 'NBA', @GameDate date = GetDate()

			,  @Team varchar(10) = 'atl'
			, @StartDate date
	;


/*
Team Avg Scored, Tm Avg TL, Tm AgvOur TL

*/
Declare @AvgScoreReg as float, @AvgTotalLine as float, @AvgOurTotalLine as float
, @OTadj float = 1.2, @GB int = 7

Declare @tblTeams Table (Team Varchar(8))

Declare @tblTeamAvgs Table 
	(Team Varchar(8), StartDate Date, AvgScoreReg float, AvgTotalLine float, AvgOurTotalLine float)

Insert into @tblTeams
		Select  distinct 
		  Team from Rotation r
		  Where GameDate > '2/1/2021'
		  Order by Team

		 -- Select * from @tblTeams
Set @Team = ''
While 1=1
BEGIN
	Select top 1 @Team = Team
	From @tblTeams
		Where Team > @Team
		order by Team
	If @@ROWCOUNT = 0
		break
	
	Select @AvgScoreReg = Avg(ScoreReg), @AvgTotalLine = Avg(TotalLine ), @AvgOurTotalLine = Avg(OurTotalLine )
	 ,@StartDate =  Min(GameDate)  
	From
	(
		Select Top (@GB)  tmr.ScoreReg, tmr.TotalLine, tmr.OurTotalLine, tmr.GameDate
		  From TodaysMatchupsResults tmr
			 Where tmr.LeagueName = @LeagueName
				AND  tmr.GameDate < @GameDate
				AND  (tmr.TeamAway = @Team or tmr.TeamHome = @Team)
				AND  tmr.ScoreReg is not null
				AND  tmr.TotalLine is not null
				AND  tmr.TotalLine is not null
			Order by tmr.GameDate desc
	) q1

	--	Select @Team, @StartDate as StartDate, @AvgScoreReg as AvgScoreReg, Round(@AvgTotalLine,1) as AvgTotalLine 
	--, Round(@AvgOurTotalLine,1) as AvgOurTotalLine 

	Insert into @tblTeamAvgs
	Select @Team, @StartDate as StartDate, @AvgScoreReg+@OTadj as AvgScoreWot, Round(@AvgTotalLine,1) as AvgTotalLine 
	, Round(@AvgOurTotalLine,1) as AvgOurTotalLine 

--	print @Team
END
Declare @TeamAdjPct float = .25
	

Select *
	,q1.SCdiff, q1.TLdiff
,	Case
		When q1.SCdiff < 0	Then q1.SCdiff - TLdiff
		else q1.SCdiff + TLdiff
	End as TeamAdj

  From
  (
	Select 
		Round((t.AvgOurTotalLine - t.AvgTotalLine) * @TeamAdjPct, 1) as Our_v_TL


	,	Round((t.AvgOurTotalLine - t.AvgTotalLine) * @TeamAdjPct +
		(t.AvgOurTotalLine - t.AvgScoreReg) * @TeamAdjPct, 1) as TeamAdj

	,	Round((t.AvgOurTotalLine - t.AvgScoreReg) * @TeamAdjPct * (-1) , 1) as SCdiff

	, Round(		-- TL-Sc  Our-Sc
				( (ABS( t.AvgTotalLine-t.AvgScoreReg)   -   ABS( t.AvgOurTotalLine-t.AvgScoreReg)) * @TeamAdjPct * (-1) )
				,1)   as TLdiff
	 , * from @tblTeamAvgs t
	) q1


	/*
	Declare @Team varchar(8) = 'was'
		Select Top 10  tmr.ScoreReg, tmr.TotalLine, tmr.OurTotalLine, tmr.GameDate
		  From TodaysMatchupsResults tmr
			 Where tmr.LeagueName = 'nba'
				AND  tmr.GameDate < '2/27/2021'
				AND  (tmr.TeamAway = @Team or tmr.TeamHome = @Team)
				AND  tmr.ScoreReg is not null
				AND  tmr.TotalLine is not null
			Order by tmr.GameDate desc

/****** Script for SelectTopNRows command from SSMS  ******/
	*/

SELECT
 min(GameDate) as Start,  max(GameDate) as EndDate,
  count(*) as Games
 , avg([LineDiffResultReg]) as LineDiffResultReg

  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
   where GameDate between '2/1/2021' and '2/9/2021'
	  and TotalLine is not null
	  	  and TotalLine > 0
union
SELECT
 min(GameDate) as Start,  max(GameDate) as EndDate,
  count(*) as Games
 , avg([LineDiffResultReg]) as LineDiffResultReg

  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
   where GameDate between '2/10/2021' and '2/19/2021'
	  and TotalLine is not null
	  	  and TotalLine > 0
union
SELECT
 min(GameDate) as Start,  max(GameDate) as EndDate,
  count(*) as Games
 , avg([LineDiffResultReg]) as LineDiffResultReg

  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
   where GameDate between '2/19/2021' and '2/28/2021'
	  and TotalLine is not null
	  	  and TotalLine > 0

