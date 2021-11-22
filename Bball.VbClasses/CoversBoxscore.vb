Option Explicit On   'Explicitly declared vars
Option Strict On     'Types must be the same or converted

Imports Bball.VbClasses.Bball.VbClasses.BballConstants
Imports HtmlParsing.Common4vb.HtmlParsing
Imports BballMVC.DTOs
Imports BballMVC.IDTOs

Namespace Bball.VbClasses
   Public Class CoversBoxscore

      Public Property ReturnCode As Integer
      Public Property ErrorMessage As String

      Public Property LoadTimeSecound As Integer
      Public Property UrlLoadTime As Double
      Public Property HtmlFileName As String

      ' Covers Rotation

      ' BuildUrl
      '  Rotation
      '  Boxscore

      ' NOTE: These props could be injected and used - make into a class or use BoxScoresDTO
      Public Property oBoxscoreParseStatsSummary As BoxscoreParseStatsSummary    '  Period scores
      '  Public Property oBoxscoreTeamTotalsParseAway As BoxscoreTeamTotalsParse    '  Away
      '  Public Property oBoxscoreTeamTotalsParseHome As BoxscoreTeamTotalsParse    '  Home

      Private oBoxscoreTeamTotalsDTO(1) As BoxscoreTeamTotalsDTO
      ' Private oBoxscoreTeamTotalsDTOHome As BoxscoreTeamTotalsDTO



      Private pGameDate As Date
      Private oParseBoxscore As ParseHtml2
      Private poLeagueDTO As ILeagueDTO
      Private poCoversDTO As CoversDTO

      Const TotalsLineFields As String = "PLAYER MIN FGM-A 3pm-a FTM-A +/- OFF DEF TOT A PF STL TO BLK PTS"

      Public Sub New(GameDate As Date, oLeagueDTO As ILeagueDTO, oCoversDTO As CoversDTO)
         pGameDate = GameDate
         poLeagueDTO = oLeagueDTO
         poCoversDTO = oCoversDTO
      End Sub

      Private Sub urlDoc()
         ' http://www.covers.com/sports/wnba/matchups
         'http://www.covers.com/Sports/WNBA/Matchups?selectedDate=2015-06-12
         'http://www.covers.com/pageLoader/pageLoader.aspx?page=/data/wnba/results/2015/boxscore895101.html


         'https://www.covers.com/pageLoader/pageLoader.aspx?page=/data/nba/results/2019-2020/boxscore1006912.html
         'https://www.covers.com/pageLoader/pageLoader.aspx?page=/data/nba/results/2019-2020/recap1006912.html

         ' new
         ' https://www.covers.com/sport/basketball/nba/boxscore/50727

         '*** basketball-reference.com ***
         'https://www.basketball-reference.com/boxscores/201911270BOS.html
         'https://www.basketball-reference.com/boxscores/pbp/201911270BOS.html   - Play By Play
      End Sub

      Public Sub GetBoxscore()
         Dim tableHtml As String
         Dim trHtml As String
         ' Dim sHtml As String
         Dim oParseTable As ParseHtml2

         oBoxscoreParseStatsSummary = New BoxscoreParseStatsSummary  ' Qtr stats

         '*** Get Html ***
         oParseBoxscore = New ParseHtml2(poCoversDTO.Url, "", "") ' Get Covers BoxScore html
         If oParseBoxscore.ReturnCode <> 0 Then
            ReturnCode = CInt(oParseBoxscore.ReturnCode)
            ErrorMessage = $"Error loading BoxScore RC: {oParseBoxscore.ReturnCode} - {poCoversDTO.GameDate} {poCoversDTO.RotNum} {poCoversDTO.TeamAway}-{poCoversDTO.TeamHome} {poCoversDTO.Url} {oParseBoxscore.ErrorMessage}"
            Exit Sub
         End If
         ZeroPtrCheck(oParseBoxscore, "ParseHtml error - newParseHtml - Url = " & poCoversDTO.Url)

         If oParseBoxscore.oWebPageGet.ReturnCode <> 0 Then
            ReturnCode = oParseBoxscore.oWebPageGet.ReturnCode
            ErrorMessage = oParseBoxscore.oWebPageGet.ErrorMsg
            Return
         End If

         '   LoadTimeSecound = oParseBoxscore.oWebPageGet.DurationSeconds  02/13/2021 use Milli seconds now
         LoadTimeSecound = CInt(oParseBoxscore.oWebPageGet.UrlLoadTime)
         UrlLoadTime = oParseBoxscore.oWebPageGet.UrlLoadTime
         If HtmlFileName > "" Then
            oParseBoxscore.WriteHtmlToDisk(HtmlFileName)
         End If

         '*** Process QTRs Summary ***
         oParseBoxscore.StringSearch("covers-MatchupIngame")
         ZeroPtrCheck(oParseBoxscore, "covers-MatchupIngame")
         tableHtml = oParseBoxscore.GetHtmlEle("table")
         processPeriods(tableHtml)
         Dim Minutes = poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod + poLeagueDTO.OverTimeMinutes * oBoxscoreParseStatsSummary.OtPeriods()

         For ixVenue As Integer = AWAY To HOME

            ' ***
            ' *** Team Totals Line - Away / Home
            ' ***
            '   <table Class="table covers-CoversMatchups-Table covers-CoversMatchups-boxscoreTable">
            oParseBoxscore.StringSearch("covers-CoversMatchups-boxscoreTable")
            ZeroPtrCheck(oParseBoxscore, "covers-CoversMatchups-boxscoreTable")
            tableHtml = oParseBoxscore.GetPrevHtmlEle("table")

            oParseTable = New ParseHtml2(tableHtml)
            oParseTable.StringSearch("<tr style=""font-weight:bold"">")
            ZeroPtrCheck(oParseTable, "<tr style=""font-weight:bold"">")
            trHtml = oParseTable.GetHtmlEle("tr")

            Dim oBoxscoreTeamTotalsParse = New BoxscoreTeamTotalsParse
            oBoxscoreTeamTotalsDTO(ixVenue) = New BoxscoreTeamTotalsDTO()
            oBoxscoreTeamTotalsParse.SetTotalsLineFields(TotalsLineFields)    ' Header constants "PLAYER POS MIN FGM-A 3pm-a FTM-A +/- OFF DEF TOT A PF STL TO BLK PTS"
            oBoxscoreTeamTotalsParse.ProcessTotalsLineRow(trHtml, oBoxscoreTeamTotalsDTO(ixVenue))
            oBoxscoreTeamTotalsDTO(ixVenue).Team = (IIf(ixVenue = AWAY, poCoversDTO.TeamAway, poCoversDTO.TeamHome)).ToString()
            oBoxscoreTeamTotalsDTO(ixVenue).Minutes = Minutes
         Next


      End Sub


      Private Sub processPeriods(PeriodsTableHtml As String)
         Dim oParseTable = New ParseHtml2(PeriodsTableHtml)
         ' Table Rows   <td> s
         '  1  Header   BLANK   1  2  3  4  Total
         '  2  Away     TmAway  #  #  #
         '  3  Home     TmHome  #  #  #
         oBoxscoreParseStatsSummary.NewBoxscoreParseStatsSummary(TeamSource_Covers, PeriodsTableHtml, pGameDate, poLeagueDTO.LeagueName, poLeagueDTO.Periods)

      End Sub


      Private Sub OLDprocessPeriods(BoxScoreUrl As String)
         Dim RecapUrl As String
         RecapUrl = Replace(BoxScoreUrl, "boxscore", "recap")

         oParseBoxscore = New ParseHtml2(RecapUrl, "", "") ' Get Covers BoxScore html
         ZeroPtrCheck(oParseBoxscore, "ParseHtml2 error - newParseHtml - Url = " & RecapUrl)

         If HtmlFileName > "" Then
            oParseBoxscore.WriteHtmlToDisk(HtmlFileName)
         End If
         ' Final Scoring Summary
         '  Table & 3 TRs
         '   Final    1  2  3  4  T
         '  Phoenix  30 22 30 18 100
         '  Minn     23 22 28 25  98
         oParseBoxscore.StringSearch("Final Scoring Summary") ' points to Home Players
         ZeroPtrCheck(oParseBoxscore, "Final Scoring Summary")
         oBoxscoreParseStatsSummary.NewBoxscoreParseStatsSummary(TeamSource_Covers, oParseBoxscore.GetHtmlEle("table"), pGameDate, poLeagueDTO.LeagueName, poLeagueDTO.Periods)



      End Sub
      Public Sub PopulateBoxScoresDTO(oBoxScoresDTO As BoxScoresDTO, Venue As String, Season As String, SubSeason As String, LoadDate As DateTime, LoadTimeSeconds As Integer, Source As String)
         Dim ixVenue As Integer
         Dim ixOpVenue As Integer


         oBoxScoresDTO.LeagueName = poLeagueDTO.LeagueName
         oBoxScoresDTO.GameDate = pGameDate
         If Venue = "Away" Then
            ixVenue = 0
            ixOpVenue = 1
            oBoxScoresDTO.RotNum = poCoversDTO.RotNum
            oBoxScoresDTO.Venue = "Away"
         Else
            ixVenue = 1
            ixOpVenue = 0
            oBoxScoresDTO.RotNum = poCoversDTO.RotNum + 1
            oBoxScoresDTO.Venue = "Home"

         End If

         oBoxScoresDTO.Team = oBoxscoreTeamTotalsDTO(ixVenue).Team
         oBoxScoresDTO.Opp = oBoxscoreTeamTotalsDTO(ixOpVenue).Team
         '
         oBoxScoresDTO.GameTime = poCoversDTO.GameTime
         oBoxScoresDTO.Season = Season

         oBoxScoresDTO.SubSeason = SubSeason
         ' Col 11
         oBoxScoresDTO.MinutesPlayed = oBoxscoreTeamTotalsDTO(ixVenue).Minutes
         oBoxScoresDTO.OtPeriods = CInt((oBoxscoreTeamTotalsDTO(ixVenue).Minutes - (poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod)) _
                                       / poLeagueDTO.OverTimeMinutes)
         '
         oBoxScoresDTO.ScoreRegUs = oBoxscoreParseStatsSummary.ScoreReg(ixVenue)
         oBoxScoresDTO.ScoreRegOp = oBoxscoreParseStatsSummary.ScoreReg(ixOpVenue)
         oBoxScoresDTO.ScoreOTUs = oBoxscoreParseStatsSummary.ScoreOT(ixVenue)
         oBoxScoresDTO.ScoreOTOp = oBoxscoreParseStatsSummary.ScoreOT(ixOpVenue)
         oBoxScoresDTO.ScoreReg = oBoxScoresDTO.ScoreRegUs + oBoxScoresDTO.ScoreRegOp
         oBoxScoresDTO.ScoreOT = oBoxScoresDTO.ScoreOTUs + oBoxScoresDTO.ScoreOTOp

         oBoxScoresDTO.ScoreQ1Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 0)
         oBoxScoresDTO.ScoreQ1Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 0)
         oBoxScoresDTO.ScoreQ2Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 1)
         oBoxScoresDTO.ScoreQ2Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 1)
         oBoxScoresDTO.ScoreQ3Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 2)
         oBoxScoresDTO.ScoreQ3Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 2)
         oBoxScoresDTO.ScoreQ4Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 3)
         oBoxScoresDTO.ScoreQ4Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 3)

         oBoxScoresDTO.ShotsActualMadeUsPt1 = oBoxscoreTeamTotalsDTO(ixVenue).PT1
         oBoxScoresDTO.ShotsActualMadeOpPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT1
         oBoxScoresDTO.ShotsActualAttemptedUsPt1 = oBoxscoreTeamTotalsDTO(ixVenue).Pt1Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt1Attempts
         oBoxScoresDTO.ShotsActualMadeUsPt2 = oBoxscoreTeamTotalsDTO(ixVenue).PT2
         oBoxScoresDTO.ShotsActualMadeOpPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT2
         oBoxScoresDTO.ShotsActualAttemptedUsPt2 = oBoxscoreTeamTotalsDTO(ixVenue).Pt2Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt2Attempts
         oBoxScoresDTO.ShotsActualMadeUsPt3 = oBoxscoreTeamTotalsDTO(ixVenue).PT3
         oBoxScoresDTO.ShotsActualMadeOpPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT3
         oBoxScoresDTO.ShotsActualAttemptedUsPt3 = oBoxscoreTeamTotalsDTO(ixVenue).Pt3Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt3Attempts

         ' Calc OT Pct
         Dim OTpct As Double = CDbl((poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod) / oBoxscoreTeamTotalsDTO(ixVenue).Minutes)

         oBoxScoresDTO.ShotsMadeUsRegPt1 = oBoxscoreTeamTotalsDTO(ixVenue).PT1 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT1 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt1 = oBoxscoreTeamTotalsDTO(ixVenue).Pt1Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt1Attempts * OTpct

         oBoxScoresDTO.ShotsMadeUsRegPt2 = oBoxscoreTeamTotalsDTO(ixVenue).PT2 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT2 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt2 = oBoxscoreTeamTotalsDTO(ixVenue).Pt2Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt2Attempts * OTpct

         oBoxScoresDTO.ShotsMadeUsRegPt3 = oBoxscoreTeamTotalsDTO(ixVenue).PT3 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT3 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt3 = oBoxscoreTeamTotalsDTO(ixVenue).Pt3Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt3Attempts * OTpct

         oBoxScoresDTO.OffRBOp = oBoxscoreTeamTotalsDTO(ixOpVenue).OffRB
         oBoxScoresDTO.OffRBUs = oBoxscoreTeamTotalsDTO(ixVenue).OffRB
         oBoxScoresDTO.AssistsUs = oBoxscoreTeamTotalsDTO(ixVenue).Assists
         oBoxScoresDTO.TurnOversUs = oBoxscoreTeamTotalsDTO(ixVenue).TurnOvers
         oBoxScoresDTO.AssistsOp = oBoxscoreTeamTotalsDTO(ixOpVenue).Assists
         oBoxScoresDTO.TurnOversOp = oBoxscoreTeamTotalsDTO(ixOpVenue).TurnOvers
         oBoxScoresDTO.LoadDate = LoadDate
         oBoxScoresDTO.LoadTimeSeconds = LoadTimeSeconds
         oBoxScoresDTO.Source = Source
         oBoxScoresDTO.Exclude = verifyBoxScoreValues(oBoxScoresDTO)
      End Sub
      Public Sub PopulateBoxScoresDTO(oBoxScoresDTO As BoxScoresDTO)
         ' , Venue As String, Season As String, SubSeason As String, LoadDate As DateTime, LoadTimeSeconds As Integer, Source As String)
         Dim ixVenue As Integer
         Dim ixOpVenue As Integer


         oBoxScoresDTO.LeagueName = poLeagueDTO.LeagueName
         oBoxScoresDTO.GameDate = pGameDate
         If oBoxScoresDTO.Venue = "Away" Then
            ixVenue = 0
            ixOpVenue = 1
            oBoxScoresDTO.RotNum = poCoversDTO.RotNum
         Else
            ixVenue = 1
            ixOpVenue = 0
            oBoxScoresDTO.RotNum = poCoversDTO.RotNum + 1
            oBoxScoresDTO.Venue = "Home"

         End If

         oBoxScoresDTO.Team = oBoxscoreTeamTotalsDTO(ixVenue).Team
         oBoxScoresDTO.Opp = oBoxscoreTeamTotalsDTO(ixOpVenue).Team
         '
         oBoxScoresDTO.GameTime = poCoversDTO.GameTime

         ' Col 11
         oBoxScoresDTO.MinutesPlayed = oBoxscoreTeamTotalsDTO(ixVenue).Minutes
         oBoxScoresDTO.OtPeriods = CInt((oBoxscoreTeamTotalsDTO(ixVenue).Minutes - (poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod)) _
                                       / poLeagueDTO.OverTimeMinutes)
         '
         oBoxScoresDTO.ScoreRegUs = oBoxscoreParseStatsSummary.ScoreReg(ixVenue)
         oBoxScoresDTO.ScoreRegOp = oBoxscoreParseStatsSummary.ScoreReg(ixOpVenue)
         oBoxScoresDTO.ScoreOTUs = oBoxscoreParseStatsSummary.ScoreOT(ixVenue)
         oBoxScoresDTO.ScoreOTOp = oBoxscoreParseStatsSummary.ScoreOT(ixOpVenue)
         oBoxScoresDTO.ScoreReg = oBoxScoresDTO.ScoreRegUs + oBoxScoresDTO.ScoreRegOp
         oBoxScoresDTO.ScoreOT = oBoxScoresDTO.ScoreOTUs + oBoxScoresDTO.ScoreOTOp

         oBoxScoresDTO.ScoreQ1Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 0)
         oBoxScoresDTO.ScoreQ1Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 0)
         oBoxScoresDTO.ScoreQ2Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 1)
         oBoxScoresDTO.ScoreQ2Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 1)
         oBoxScoresDTO.ScoreQ3Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 2)
         oBoxScoresDTO.ScoreQ3Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 2)
         oBoxScoresDTO.ScoreQ4Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 3)
         oBoxScoresDTO.ScoreQ4Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 3)

         oBoxScoresDTO.ShotsActualMadeUsPt1 = oBoxscoreTeamTotalsDTO(ixVenue).PT1
         oBoxScoresDTO.ShotsActualMadeOpPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT1
         oBoxScoresDTO.ShotsActualAttemptedUsPt1 = oBoxscoreTeamTotalsDTO(ixVenue).Pt1Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt1Attempts
         oBoxScoresDTO.ShotsActualMadeUsPt2 = oBoxscoreTeamTotalsDTO(ixVenue).PT2
         oBoxScoresDTO.ShotsActualMadeOpPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT2
         oBoxScoresDTO.ShotsActualAttemptedUsPt2 = oBoxscoreTeamTotalsDTO(ixVenue).Pt2Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt2Attempts
         oBoxScoresDTO.ShotsActualMadeUsPt3 = oBoxscoreTeamTotalsDTO(ixVenue).PT3
         oBoxScoresDTO.ShotsActualMadeOpPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT3
         oBoxScoresDTO.ShotsActualAttemptedUsPt3 = oBoxscoreTeamTotalsDTO(ixVenue).Pt3Attempts
         oBoxScoresDTO.ShotsActualAttemptedOpPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt3Attempts

         ' Calc OT Pct
         Dim OTpct As Double = CDbl((poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod) / oBoxscoreTeamTotalsDTO(ixVenue).Minutes)

         oBoxScoresDTO.ShotsMadeUsRegPt1 = oBoxscoreTeamTotalsDTO(ixVenue).PT1 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT1 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt1 = oBoxscoreTeamTotalsDTO(ixVenue).Pt1Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt1 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt1Attempts * OTpct

         oBoxScoresDTO.ShotsMadeUsRegPt2 = oBoxscoreTeamTotalsDTO(ixVenue).PT2 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT2 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt2 = oBoxscoreTeamTotalsDTO(ixVenue).Pt2Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt2 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt2Attempts * OTpct

         oBoxScoresDTO.ShotsMadeUsRegPt3 = oBoxscoreTeamTotalsDTO(ixVenue).PT3 * OTpct
         oBoxScoresDTO.ShotsMadeOpRegPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).PT3 * OTpct
         oBoxScoresDTO.ShotsAttemptedUsRegPt3 = oBoxscoreTeamTotalsDTO(ixVenue).Pt3Attempts * OTpct
         oBoxScoresDTO.ShotsAttemptedOpRegPt3 = oBoxscoreTeamTotalsDTO(ixOpVenue).Pt3Attempts * OTpct

         oBoxScoresDTO.OffRBOp = oBoxscoreTeamTotalsDTO(ixOpVenue).OffRB
         oBoxScoresDTO.OffRBUs = oBoxscoreTeamTotalsDTO(ixVenue).OffRB
         oBoxScoresDTO.AssistsUs = oBoxscoreTeamTotalsDTO(ixVenue).Assists
         oBoxScoresDTO.TurnOversUs = oBoxscoreTeamTotalsDTO(ixVenue).TurnOvers
         oBoxScoresDTO.AssistsOp = oBoxscoreTeamTotalsDTO(ixOpVenue).Assists
         oBoxScoresDTO.TurnOversOp = oBoxscoreTeamTotalsDTO(ixOpVenue).TurnOvers
         '   oBoxScoresDTO.LoadDate = LoadDate
         '   oBoxScoresDTO.LoadTimeSeconds = LoadTimeSeconds
         '  oBoxScoresDTO.Source = Source
         oBoxScoresDTO.Exclude = verifyBoxScoreValues(oBoxScoresDTO)
      End Sub

      Private Function verifyBoxScoreValues(oBoxScoresDTO As BoxScoresDTO) As Boolean
         If oBoxScoresDTO.ScoreQ1Us + oBoxScoresDTO.ScoreQ2Us + oBoxScoresDTO.ScoreQ3Us + oBoxScoresDTO.ScoreQ4Us <> oBoxScoresDTO.ScoreRegUs Then
            Return True
         End If
         If oBoxScoresDTO.ScoreQ1Op + oBoxScoresDTO.ScoreQ2Op + oBoxScoresDTO.ScoreQ3Op + oBoxScoresDTO.ScoreQ4Op <> oBoxScoresDTO.ScoreRegOp Then
            Return True
         End If

         If oBoxScoresDTO.ShotsActualMadeUsPt1 * 1 _
          + oBoxScoresDTO.ShotsActualMadeUsPt2 * 2 _
          + oBoxScoresDTO.ShotsActualMadeUsPt3 * 3 <> oBoxScoresDTO.ScoreOTUs Then
            Return True
         End If
         If oBoxScoresDTO.ShotsActualMadeOpPt1 * 1 _
          + oBoxScoresDTO.ShotsActualMadeOpPt2 * 2 _
          + oBoxScoresDTO.ShotsActualMadeOpPt3 * 3 <> oBoxScoresDTO.ScoreOTOp Then
            Return True
         End If

         Return False
      End Function

      Private Sub ZeroPtrCheck(o As ParseHtml2, SearchItem As String)
         If o.Ptr = 0 Then

            Dim msg As String = "" _
               & $" {poCoversDTO.GameDate} - {poCoversDTO.LeagueName}  RotNum: {poCoversDTO.RotNum} : {poCoversDTO.TeamAway}/ {poCoversDTO.TeamHome}"

            Throw New Exception("ParseHtml - Zero Ptr - " & SearchItem & msg)
         End If

      End Sub
      Private Function errorCheck(message As String) As Boolean
         If oParseBoxscore.Ptr = 0 Then
            ReturnCode = 1
            ErrorMessage = message
            Return True
         End If
         Return False
      End Function

      'Sub OLDGetBoxscore()

      '   oBoxscoreParseStatsSummary = New BoxscoreParseStatsSummary

      '   oParseBoxscore = New ParseHtml2(poCoversDTO.Url, "", "") ' Get Covers BoxScore html
      '   ZeroPtrCheck(oParseBoxscore, "ParseHtml error - newParseHtml - Url = " & poCoversDTO.Url)

      '   LoadTimeSecound = oParseBoxscore.oWebPageGet.DurationSeconds
      '   If HtmlFileName > "" Then
      '      oParseBoxscore.WriteHtmlToDisk(HtmlFileName)
      '   End If

      '   ' ***
      '   ' *** Away Team Totals Line
      '   ' ***
      '   Call oParseBoxscore.StringSearch("datahl2b")
      '   ZeroPtrCheck(oParseBoxscore, "datahl2b")
      '   oParseBoxscore.Ptr = oParseBoxscore.Ptr + 1

      '   ' points to Away Players
      '   Call oParseBoxscore.StringSearch("datahl2b")
      '   ZeroPtrCheck(oParseBoxscore, "datahl2b")
      '   ' points to Away Totals tr
      '   oParseBoxscore.Ptr = oParseBoxscore.Ptr - 12 ' point b4 tr

      '   oBoxscoreTeamTotalsParseAway = New BoxscoreTeamTotalsParse
      '   Call oBoxscoreTeamTotalsParseAway.SetTotalsLineFields(TotalsLineFields)    ' Header constants "PLAYER POS MIN FGM-A 3pm-a FTM-A +/- OFF DEF TOT ast PF STL TO BLK PTS"
      '   Dim trHtml As String = oParseBoxscore.GetHtmlEle("tr")
      '   Call oBoxscoreTeamTotalsParseAway.ProcessTotalsLineRow(trHtml)
      '   oBoxscoreTeamTotalsParseAway.oBoxscoreTeamTotalsDTO.Team = poCoversDTO.TeamAway

      '   ' ***
      '   ' *** Home Team Totals Line
      '   ' ***
      '   Call oParseBoxscore.StringSearch("datahl2b") ' points to Home Players
      '   oParseBoxscore.Ptr = oParseBoxscore.Ptr + 1
      '   Call oParseBoxscore.StringSearch("datahl2b") ' points to Home Totals tr
      '   oParseBoxscore.Ptr = oParseBoxscore.Ptr - 12 ' point b4 tr

      '   oBoxscoreTeamTotalsParseHome = New BoxscoreTeamTotalsParse
      '   Call oBoxscoreTeamTotalsParseHome.SetTotalsLineFields(TotalsLineFields)
      '   Call oBoxscoreTeamTotalsParseHome.ProcessTotalsLineRow(oParseBoxscore.GetHtmlEle("tr"))
      '   oBoxscoreTeamTotalsParseHome.oBoxscoreTeamTotalsDTO.Team = poCoversDTO.TeamHome

      '   processPeriods(poCoversDTO.Url)

      'End Sub
      'Public Sub OLDPopulateBoxScoresDTO(oBoxScoresDTO As BoxScoresDTO, Venue As String, Season As String, SubSeason As String, LoadDate As DateTime, LoadTimeSeconds As Integer, Source As String)
      '   Dim oBoxscoreTeamTotalsDTO As BoxscoreTeamTotalsDTO
      '   Dim Op As BoxscoreTeamTotalsDTO
      '   Dim ixVenue As Integer
      '   Dim ixOpVenue As Integer

      '   oBoxScoresDTO.Exclude = False
      '   oBoxScoresDTO.LeagueName = poLeagueDTO.LeagueName
      '   oBoxScoresDTO.GameDate = pGameDate
      '   If Venue = "Away" Then
      '      ixVenue = 0
      '      ixOpVenue = 1
      '      oBoxScoresDTO.RotNum = poCoversDTO.RotNum
      '      oBoxScoresDTO.Venue = "Away"
      '      'oBoxscoreTeamTotalsDTO = oBoxscoreTeamTotalsParseAway.oBoxscoreTeamTotalsDTO
      '      'Op = oBoxscoreTeamTotalsParseHome.oBoxscoreTeamTotalsDTO
      '      oBoxscoreTeamTotalsDTO = oBoxscoreTeamTotalsDTO(ixVenue)
      '      Op = oBoxscoreTeamTotalsDTOHome
      '   Else
      '      ixVenue = 1
      '      ixOpVenue = 0
      '      oBoxScoresDTO.RotNum = poCoversDTO.RotNum + 1
      '      oBoxScoresDTO.Venue = "Home"
      '      ' oBoxscoreTeamTotalsDTO = oBoxscoreTeamTotalsParseHome.oBoxscoreTeamTotalsDTO
      '      'Op = oBoxscoreTeamTotalsParseAway.oBoxscoreTeamTotalsDTO
      '      oBoxscoreTeamTotalsDTO = oBoxscoreTeamTotalsDTOHome
      '      Op = oBoxscoreTeamTotalsDTOAway

      '   End If

      '   oBoxScoresDTO.Team = oBoxscoreTeamTotalsDTO.Team
      '   oBoxScoresDTO.Opp = Op.Team
      '   '
      '   oBoxScoresDTO.GameTime = poCoversDTO.GameTime
      '   oBoxScoresDTO.Season = Season

      '   oBoxScoresDTO.SubSeason = SubSeason
      '   ' Col 11
      '   oBoxScoresDTO.MinutesPlayed = oBoxscoreTeamTotalsDTO.Minutes
      '   oBoxScoresDTO.OtPeriods = CInt((oBoxscoreTeamTotalsDTO.Minutes - (poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod)) _
      '                                 / poLeagueDTO.OverTimeMinutes)
      '   '
      '   oBoxScoresDTO.ScoreRegUs = oBoxscoreParseStatsSummary.ScoreReg(ixVenue)
      '   oBoxScoresDTO.ScoreRegOp = oBoxscoreParseStatsSummary.ScoreReg(ixOpVenue)
      '   oBoxScoresDTO.ScoreOTUs = oBoxscoreParseStatsSummary.ScoreOT(ixVenue)
      '   oBoxScoresDTO.ScoreOTOp = oBoxscoreParseStatsSummary.ScoreOT(ixOpVenue)
      '   oBoxScoresDTO.ScoreReg = oBoxScoresDTO.ScoreRegUs + oBoxScoresDTO.ScoreRegOp
      '   oBoxScoresDTO.ScoreOT = oBoxScoresDTO.ScoreOTUs + oBoxScoresDTO.ScoreOTOp

      '   oBoxScoresDTO.ScoreQ1Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 0)
      '   oBoxScoresDTO.ScoreQ1Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 0)
      '   oBoxScoresDTO.ScoreQ2Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 1)
      '   oBoxScoresDTO.ScoreQ2Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 1)
      '   oBoxScoresDTO.ScoreQ3Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 2)
      '   oBoxScoresDTO.ScoreQ3Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 2)
      '   oBoxScoresDTO.ScoreQ4Us = oBoxscoreParseStatsSummary.PeriodScore(ixVenue, 3)
      '   oBoxScoresDTO.ScoreQ4Op = oBoxscoreParseStatsSummary.PeriodScore(ixOpVenue, 3)

      '   oBoxScoresDTO.ShotsActualMadeUsPt1 = oBoxscoreTeamTotalsDTO.PT1
      '   oBoxScoresDTO.ShotsActualMadeOpPt1 = Op.PT1
      '   oBoxScoresDTO.ShotsActualAttemptedUsPt1 = oBoxscoreTeamTotalsDTO.Pt1Attempts
      '   oBoxScoresDTO.ShotsActualAttemptedOpPt1 = Op.Pt1Attempts
      '   oBoxScoresDTO.ShotsActualMadeUsPt2 = oBoxscoreTeamTotalsDTO.PT2
      '   oBoxScoresDTO.ShotsActualMadeOpPt2 = Op.PT2
      '   oBoxScoresDTO.ShotsActualAttemptedUsPt2 = oBoxscoreTeamTotalsDTO.Pt2Attempts
      '   oBoxScoresDTO.ShotsActualAttemptedOpPt2 = Op.Pt2Attempts
      '   oBoxScoresDTO.ShotsActualMadeUsPt3 = oBoxscoreTeamTotalsDTO.PT3
      '   oBoxScoresDTO.ShotsActualMadeOpPt3 = Op.PT3
      '   oBoxScoresDTO.ShotsActualAttemptedUsPt3 = oBoxscoreTeamTotalsDTO.Pt3Attempts
      '   oBoxScoresDTO.ShotsActualAttemptedOpPt3 = Op.Pt3Attempts

      '   ' Calc OT Pct
      '   Dim OTpct As Double = CDbl((poLeagueDTO.Periods * poLeagueDTO.MinutesPerPeriod) / oBoxscoreTeamTotalsDTO.Minutes)

      '   oBoxScoresDTO.ShotsMadeUsRegPt1 = oBoxscoreTeamTotalsDTO.PT1 * OTpct
      '   oBoxScoresDTO.ShotsMadeOpRegPt1 = Op.PT1 * OTpct
      '   oBoxScoresDTO.ShotsAttemptedUsRegPt1 = oBoxscoreTeamTotalsDTO.Pt1Attempts * OTpct
      '   oBoxScoresDTO.ShotsAttemptedOpRegPt1 = Op.Pt1Attempts * OTpct

      '   oBoxScoresDTO.ShotsMadeUsRegPt2 = oBoxscoreTeamTotalsDTO.PT2 * OTpct
      '   oBoxScoresDTO.ShotsMadeOpRegPt2 = Op.PT2 * OTpct
      '   oBoxScoresDTO.ShotsAttemptedUsRegPt2 = oBoxscoreTeamTotalsDTO.Pt2Attempts * OTpct
      '   oBoxScoresDTO.ShotsAttemptedOpRegPt2 = Op.Pt2Attempts * OTpct

      '   oBoxScoresDTO.ShotsMadeUsRegPt3 = oBoxscoreTeamTotalsDTO.PT3 * OTpct
      '   oBoxScoresDTO.ShotsMadeOpRegPt3 = Op.PT3 * OTpct
      '   oBoxScoresDTO.ShotsAttemptedUsRegPt3 = oBoxscoreTeamTotalsDTO.Pt3Attempts * OTpct
      '   oBoxScoresDTO.ShotsAttemptedOpRegPt3 = Op.Pt3Attempts * OTpct

      '   oBoxScoresDTO.OffRBOp = Op.OffRB
      '   oBoxScoresDTO.OffRBUs = oBoxscoreTeamTotalsDTO.OffRB
      '   oBoxScoresDTO.AssistsUs = oBoxscoreTeamTotalsDTO.Assists
      '   oBoxScoresDTO.TurnOversUs = oBoxscoreTeamTotalsDTO.TurnOvers
      '   oBoxScoresDTO.AssistsOp = Op.Assists
      '   oBoxScoresDTO.TurnOversOp = Op.TurnOvers
      '   oBoxScoresDTO.LoadDate = LoadDate
      '   oBoxScoresDTO.LoadTimeSeconds = LoadTimeSeconds
      '   oBoxScoresDTO.Source = Source


      'End Sub


   End Class
End Namespace
