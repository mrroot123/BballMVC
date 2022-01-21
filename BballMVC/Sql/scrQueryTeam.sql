

Declare @ScriptName char(20) = 'scrQueryTeam'


Declare @Team char(4) = 'NY'
		, @LeagueName char(4) = 'NBA'
		, @Venue char(4) = 'Away'		--'Home'  --'Away'
		, @StartDate Date = '12/19/2021'
		, @Season char(4) = '2122'
		, @GB int = 10

if @StartDate > Convert(Date, Getdate())
	Set @StartDate = Convert(Date, Getdate())


Select @ScriptName as ScriptName, @Team as Team, @LeagueName as League, @Venue as Venue, @StartDate as StartDate , @Season as Season, @GB as GamesBack

Select  @Team + ' Averages -->', count(*) as 'GamesBack'  ,'Both' as Venue
	, Round(AVG(ScoreReg),1) as AvgScoreReg, Round(AVG(ScoreRegUs),1) as 'Team Avg Score', Round(AVG(ScoreRegop),1) as 'Opp Avg Score'
	From (
	Select top (@GB) 
	GameDate,RotNum,Team,Opp,Venue,OtPeriods,ScoreReg,ScoreRegUs,ScoreRegOp,Pace,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp
	From BoxScores b
	Where b.LeagueName = @LeagueName
	  and b.Team = @Team
	  and b.Season = @Season
	  and b.SubSeason = '1-Reg'
	--  and (b.Venue = @Venue or @Venue = 'Both')
	  and b.Exclude = 0
	  and b.GameDate < @StartDate
) x
Union
Select  @Team + ' Averages -->', count(*) as  'GamesBack'  ,'Away' as Venue
	, Round(AVG(ScoreReg),1) as AvgScoreReg, Round(AVG(ScoreRegUs),1) as 'Our Avg Score', Round(AVG(ScoreRegop),1) as 'Opp Avg Score'
	From (
	Select top (@GB) 
	GameDate,RotNum,Team,Opp,Venue,OtPeriods,ScoreReg,ScoreRegUs,ScoreRegOp,Pace,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp
	From BoxScores b
	Where b.LeagueName = @LeagueName
	  and b.Team = @Team
	  and b.Season = @Season
	  and b.SubSeason = '1-Reg'
	  and (b.Venue = 'Away')
	  and b.Exclude = 0
	  and b.GameDate < @StartDate

) x
Union
Select   @Team + ' Averages -->', count(*) as  'GamesBack'  ,'Home' as Venue
	, Round(AVG(ScoreReg),1) as AvgScoreReg, Round(AVG(ScoreRegUs),1) as 'Our Avg Score'
	, Round(AVG(ScoreRegop),1) as 'Opp Avg Score'
	--, Round(AVG(ScoreRegop),1) as 'Opp Avg Score'

	From (
	Select top (@GB) 
	GameDate,RotNum,Team,Opp,Venue,OtPeriods,ScoreReg,ScoreRegUs,ScoreRegOp,Pace,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp
	From BoxScores b
	Where b.LeagueName = @LeagueName
	  and b.Team = @Team
	  and b.Season = @Season
	  and b.SubSeason = '1-Reg'
	  and (b.Venue = 'Home')
	  and b.Exclude = 0
	  and b.GameDate < @StartDate
) x

Select   @Team + ' Averages -->', count(*) as  'GamesBack'  ,'Home' as Venue
	, Round(AVG(ScoreReg),1) as AvgScoreReg, Round(AVG(ScoreRegUs),1) as 'Our Avg Score', Round(AVG(ScoreRegop),1) as 'Opp Avg Score'
	From (
	Select top (@GB) 
	GameDate,RotNum,Team,Opp,Venue,OtPeriods,ScoreReg,ScoreRegUs,ScoreRegOp,Pace,ScoreQ1Us
	,ScoreQ1Us+ScoreQ2Us as ScoreH1Us,(ScoreQ1Us+ScoreQ2Us)/ScoreRegUs as PctH1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp
	From BoxScores b
	Where b.LeagueName = @LeagueName
	  and b.Team = @Team
	  and b.Season = @Season
	  and b.SubSeason = '1-Reg'
	  and (b.Venue = @Venue)
	  and b.Exclude = 0
	  and b.GameDate < @StartDate
) x


Select top (@GB) 
	GameDate,RotNum,Team,Opp,Venue,OtPeriods,ScoreReg,ScoreRegUs,ScoreRegOp,Pace,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp
	From BoxScores b
	Where b.LeagueName = @LeagueName
	  and b.Team = @Team
	  and b.Season = @Season
	  and b.SubSeason = '1-Reg'
	  and (b.Venue = @Venue or @Venue = 'Both')
	  and b.Exclude = 0	  
	  and b.GameDate < @StartDate

/****** Script for SelectTopNRows command from SSMS  ******/
--Declare @LeagueName char(4) = 'NBA'
--		, @Team char(4) = 'WAS' 
--		, @Venue char(4) =  'Home' -- 'Away'	 --
/****** Script for SelectTopNRows command from SSMS  ******/
Declare 
		  @TeamAway char(4) = 'WAS' 
		, @TeamHome char(4) = 'PHO' 

SELECT @LeagueName as LeagueName
	 ,@TeamAway as Team, 'Away' as Venue
    ,Round( Avg([OurTotalLine]),1)		as AvgOurTotalLine
    ,Round( Avg([TotalLine]),1)			as AvgTotalLine
    ,Round( Avg([LineDiffResultReg]),1)  as AvgLineDiffResultReg
    ,Round( Avg([ScoreReg]),1)			as AvgScoreReg
	 ,  Round( Avg([ScoreRegAway]),1)   as AvgScoreUs
	 ,  Round( Avg([ScoreRegHome]),1)   as AvgScoreOpp
  From ( Select top 10 * 
			FROM TodaysMatchupsResults where LeagueName = @LeagueName  and  TeamAway = @TeamAway 
			Order by GameDate desc	) x
			
Union
SELECT @LeagueName as LeagueName
	 ,@TeamHome as Team, 'Home' as Venue
    ,Round( Avg([OurTotalLine]),1)		as AvgOurTotalLine
    ,Round( Avg([TotalLine]),1)			as AvgTotalLine
    ,Round( Avg([LineDiffResultReg]),1)  as AvgLineDiffResultReg
    ,Round( Avg([ScoreReg]),1)			as AvgScoreReg
	 ,  Round( Avg([ScoreRegHome]),1)   as AvgScoreUs
	 ,  Round( Avg([ScoreRegAway]),1)   as AvgScoreOpp
  From ( Select top 10 * 
			FROM TodaysMatchupsResults where LeagueName = @LeagueName  and  TeamHome = @TeamHome 
			Order by GameDate desc	) x
			
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) 
      [GameDate]
      ,[SubSeason]
      ,[RotNum]
      ,[TeamAway]
      ,[TeamHome]
      ,[OurTotalLine]
      ,[TotalLine]
      ,[OpenTotalLine]
      ,[PlayDiff]
		    ,[ScoreReg]
      ,[ScoreOT]
      ,[ScoreRegHome]
      ,[ScoreRegAway]
      ,[OpenPlayDiff]
      ,[Play]
      ,[PlayResult]
      ,[UnderWin]
      ,[UnderLoss]
      ,[OverWin]
      ,[OverLoss]
      ,[TotalDirection]
      ,[TotalDirectionReg]
      ,[LineDiffResultReg]
      ,[OtPeriods]
  
      ,[VolatilityAway]
      ,[VolatilityHome]
      ,[VolatilityGame]
      ,[BxScLinePct]
      ,[TmStrAdjPct]
      ,[GB1]
      ,[GB2]
      ,[GB3]
      ,[WeightGB1]
      ,[WeightGB2]
      ,[WeightGB3]
      ,[AwayGB1]
      ,[AwayGB2]
      ,[AwayGB3]
      ,[HomeGB1]
      ,[HomeGB2]
      ,[HomeGB3]
      ,[TS]
  FROM [db_a791d7_leaguescores].[dbo].[TodaysMatchupsResults]
   where LeagueName = @LeagueName
	  and  @Team = Case When @Venue = 'Home' Then TeamHome  Else  TeamAway  end

	Order by GameDate desc