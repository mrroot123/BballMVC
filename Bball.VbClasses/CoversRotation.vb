Option Explicit On   'Explicitly declared vars
Option Strict On     'Types must be the same or converted

Imports HtmlParsing.Common4vb.HtmlParsing
Imports HtmlParsing.HtmlParsing.Functions.VBFunctions
Imports BballMVC.DTOs
'Imports Bball.DAL
'Imports Bball.VbClassesInterfaces.Bball.VbClassesInterfaces
Imports Bball.DataBaseFunctions

Namespace Bball.VbClasses
   Public Class CoversRotation
      '  v1    Original
      '  v2.1  11/08/2019
      '  v2.2  11/09/2019
      '  v2.3  12/12/2019

      ' Covers Rotation

      ' BuildUrl
      '  Rotation
      '  Boxscore

      Public Property ReturnCode As Integer   ' -1 = error  1 = warning
      Public Property Message As String


      Private _ocRotation As New SortedList(Of String, CoversDTO)

      Private pGameDate As Date
      Private poLeagueDTO As LeagueDTO    'v2.2
      Private oParseRotation As ParseHtml2
      Private pCoversRotationHtml As String

      ' v2.2
      Enum GameStatus
         Canceled = -1
         NotStarted = 0
         InProgress
         Final
      End Enum

      Const CoversUrl As String = "https://www.covers.com"

      Public Sub New(ocRotation As SortedList(Of String, CoversDTO), GameDate As Date, oLeagueDTO As LeagueDTO, CoversRotationHtml As String)
         _ocRotation = ocRotation
         pGameDate = GameDate
         poLeagueDTO = oLeagueDTO ' v2.2
         pCoversRotationHtml = CoversRotationHtml
      End Sub

      Public Sub New(ocRotation As SortedList(Of String, CoversDTO), GameDate As Date, oLeagueDTO As LeagueDTO)
         _ocRotation = ocRotation
         pGameDate = GameDate
         poLeagueDTO = oLeagueDTO ' v2.2
         pCoversRotationHtml = getCoversRotationHtml(pGameDate, poLeagueDTO.LeagueName, CoversUrl)
      End Sub

      ' http://www.covers.com/sports/wnba/matchups
      'http://www.covers.com/Sports/WNBA/Matchups?selectedDate=2015-06-12
      'http://www.covers.com/pageLoader/pageLoader.aspx?page=/data/wnba/results/2015/boxscore895101.html

      Public Sub GetRotation()
         Dim oCoversDTO As CoversDTO
         Dim s As String


         oParseRotation = New ParseHtml2(pCoversRotationHtml)


         oParseRotation.StringSearch("data-game-date=""" & Format(pGameDate, "yyyy-MM-dd"))

         If oParseRotation.Ptr = 0 Then
            ReturnCode = 1
            Message = "No games scheduled for " & Format(pGameDate, "yyyy-MM-dd")
            Exit Sub
         End If
         oParseRotation.Ptr = 1

         ' not used
         '"cmg_matchup_line_score"
         ' Get tr - Period #s
         ' Get tr - away tmName & period scores - get TD - tm name
         ' Get tr - home tmName & period scores

         oParseRotation.StringSearch("cmg_game_container")
         '   oParseRotation.StringSearch ("cmg_matchup_line_score""") - not used
         Do While oParseRotation.Ptr > 0
            Dim savPtr As Long


            savPtr = oParseRotation.Ptr
            oCoversDTO = New CoversDTO
            oCoversDTO.LeagueName = poLeagueDTO.LeagueName
            Try
               '<div Class="cmg_matchup_game_box cmg_game_data"
               '    data-home-team-nickname-search="Clippers"
               '    data-away-team-nickname-search="Bucks"
               '    data-home-team-city-search="Los Angeles"
               '    data-away-team-city-search="Milwaukee"
               '    data-away-team-fullname-search="Milwaukee"
               '    data-home-team-fullname-search="L.A. Clippers"
               '        data-away-team-shortname-search="MIL"
               '        data-home-team-shortname-search="LAC"
               '    data-away-conference="Eastern Conference"
               '    data-home-conference="Western Conference"
               '    data-conference="Interleague"
               '    data-competition-type="Regular Season"
               '    data-top-twenty-five="false"
               '        data-game-date="2019-11-06 22:00:00"
               '        data-sdi-event-id="/sport/basketball/competition:1006798"
               '        data-game-total="228"
               '        data-game-odd="6.5"
               '    data-handicap-difference="8.5"
               '        data-link="/Sports/NBA/Matchups/1006798"
               '    data-last-update="2019-11-07T01:50:32.0000000"
               '    data-following="false"
               '        data-index="8" ???
               '        data-event-id="1006798"
               '        data-away-score="129"
               '        data-home-score="124">
               Dim oParseGame As New ParseHtml2(oParseRotation.GetHtmlEle("div")) ' This div Class="cmg_matchup_game_box cmg_game_data"
               getAttributes(oCoversDTO)

               '   has attributes above
               oParseGame.StringSearch("cmg_matchup_list_column_2")
               ' v2.2
               Call oParseGame.SetElement()
               Dim oParseColumn2 As New ParseHtml2(oParseGame.InnerHtml)
               '''' Call oParseColumn2.newParseHtml2(oParseGame.InnerHtml) ' This div Class="cmg_matchup_list_column_2"
               ' pGameDate Date
               '     > Tomorrow
               '     = Today
               '     < Past
               If pGameDate > DateTime.Today Then                                                ' Future game
                  oCoversDTO.GameStatus = GameStatus.NotStarted
               ElseIf pGameDate < DateTime.Today Then                                            ' Yesterday's Finals
                  oCoversDTO.GameStatus = GameStatus.Final
               ElseIf oParseColumn2.FindStringInHtml("Final") > 0 Then ' Today Final
                  oCoversDTO.GameStatus = GameStatus.Final
               ElseIf oParseColumn2.FindStringInHtml("cmg_team_opening_odds") > 0 Then ' Today Not Started
                  oCoversDTO.GameStatus = GameStatus.NotStarted
               ElseIf oParseColumn2.FindStringInHtml("cmg_matchup_list_score") > 0 Then   ' Today In Progress
                  oCoversDTO.GameStatus = GameStatus.InProgress
                  ' === In Progross ===
                  '<div Class="cmg_matchup_list_column_2">
                  '  <div> <div Class="cmg_team_at"></div> </div>

                  '  <div Class="cmg_matchup_list_score">
                  '    <div Class="cmg_matchup_list_score_away">11</div>
                  '    <div Class="cmg_matchup_list_status">1st 6:06</div> Pre-game: Qtr 1
                  '    <div Class="cmg_matchup_list_score_home">9</div>
                  '  </div>
                  Call oParseColumn2.StringSearch("cmg_matchup_list_score")
                  Call oParseColumn2.SetElement()

                  Dim oParseScore As ParseHtml2 = New ParseHtml2(oParseColumn2.InnerHtml) ' This div Class="cmg_matchup_list_column_2"
                  oParseScore.GetHtmlEle("div")        ' <div Class="cmg_matchup_list_score_away">11</div>
                  s = oParseScore.GetHtmlEle("div")              ' <div Class="cmg_matchup_list_status">1st 6:06</div>
                  If LCase(s) = "pre-game" Then
                     oCoversDTO.GameStatus = GameStatus.NotStarted
                  Else
                     Call processTimeLeftInPeriod(s, oCoversDTO, poLeagueDTO.Periods, poLeagueDTO.MinutesPerPeriod)
                  End If
               Else
                  M9_Abend("Invalid Covers Game Status " & vbCrLf & oParseColumn2.Html)
               End If
               If oCoversDTO.GameStatus = GameStatus.NotStarted Then
                  getOpeningLines(oParseColumn2, oCoversDTO)
               End If
               oParseRotation.Ptr = savPtr
               oParseRotation.StringSearch("class=""cmg_team_name")
               oParseRotation.GetHtmlEle("span")
               oCoversDTO.RotNum = CInt(oParseRotation.InnerHtml)

               _ocRotation.Add(oCoversDTO.RotNum.ToString(), oCoversDTO)
            Catch ex As Exception
               Dim msg = IIf(InStr(ex.Message, "CallStack=") > 0, ex.Message, ex.Message & $" - CallStack= {ex.StackTrace}")
               Throw New Exception($"CoversRotation.GetRotation: Error - {poLeagueDTO.LeagueName} {pGameDate} - TeamAway: {oCoversDTO.TeamAway} - TeamHome: {oCoversDTO.TeamHome} - {msg}")

            End Try

            oParseRotation.StringSearch("cmg_game_container") 'Point to next game matchup
         Loop
      End Sub
      Private Sub getOpeningLines(oParseColumn2 As ParseHtml2, oCoversDTO As CoversDTO)
         oParseColumn2.Ptr = 1   'reset ptr
         oParseColumn2.StringSearch("O/U:")                    ' <span>O/U: 215</span>
         Dim innerHtml As String = oParseColumn2.GetPrevHtmlEle("span")  ' O/U: 215
         Dim ar() As String = Split(innerHtml)
         If UBound(ar) > 0 Then
            If IsNumeric(ar(1)) Then
               oCoversDTO.LineTotalOpen = CSng(ar(1))
            Else
               '   oCoversDTO.LineTotalOpen = 0
            End If
         Else
            '   oCoversDTO.LineTotalOpen = 0
         End If


         innerHtml = oParseColumn2.GetHtmlEle("span")  ' <span>CLE +3</span>
         ar = Split(innerHtml)
         If UBound(ar) > 0 Then
            If IsNumeric(ar(1)) Then
               oCoversDTO.LineSideOpen = CSng(ar(1))
            Else
               '  oCoversDTO.LineSideOpen = 0
            End If
         Else
            '  oCoversDTO.LineSideOpen = 0
         End If
      End Sub
      Private Sub getAttributes(oCoversDTO As CoversDTO)
         '*** Get Data from Attributes ***
         Dim s As String

         oCoversDTO.TeamAway = oParseRotation.GetAttribute("data-away-team-shortname-search")
         oCoversDTO.TeamAway = SqlFunctions.TeamLookup(pGameDate, poLeagueDTO.LeagueName, "Covers", oCoversDTO.TeamAway).Trim()

         oCoversDTO.TeamHome = oParseRotation.GetAttribute("data-home-team-shortname-search")
         oCoversDTO.TeamHome = SqlFunctions.TeamLookup(pGameDate, poLeagueDTO.LeagueName, "Covers", oCoversDTO.TeamHome).Trim()

         Dim ar = (oParseRotation.GetAttribute("data-game-Date")).Split()  ' "2019-07-05 20:00:00"

         oCoversDTO.GameDate = CDate(ar(0))
         ' v2.3 Game Time now String 5 - HH(24) : MM
         s = Left(ar(1), 5)      ' Get time hh:mm
         'i = CInt(Left(s, 2))    ' get hours
         'If i > 12 Then          '
         '   i = i - 12
         'End If
         oCoversDTO.GameTime = s ' v2.3 CDate(CStr(i) & Mid(s, 3)) ' Combine hh & :mm

         oCoversDTO.BoxscoreNumber = oParseRotation.GetAttribute("data-event-id")

         oCoversDTO.Url = genCoversBoxScoreUrl(pGameDate, poLeagueDTO.LeagueName, poLeagueDTO.MultiYearLeague, oCoversDTO.BoxscoreNumber)


         '01/06/2020  oCoversDTO.LineTotalOpen = CSng(checkForEmpty(oParseRotation.GetAttribute("data-game-total")))
         s = oParseRotation.GetAttribute("data-game-total")
         If IsNumeric(s) Then
            oCoversDTO.LineTotal = CSng(s)
         End If
         '  oCoversDTO.LineTotal = CSng(checkForEmpty(oParseRotation.GetAttribute("data-game-total")))

         If oParseRotation.GetAttribute("data-game-odd") <> "" Then
            oCoversDTO.LineSideOpen = CSng(oParseRotation.GetAttribute("data-game-odd"))
            oCoversDTO.LineSideClose = CSng(oParseRotation.GetAttribute("data-game-odd"))
         End If
         If pGameDate <= Today.Date Then
            oCoversDTO.ScoreAway = CInt(checkForEmpty(oParseRotation.GetAttribute("data-away-score")))
            oCoversDTO.ScoreHome = CInt(checkForEmpty(oParseRotation.GetAttribute("data-home-score")))
         End If

      End Sub
      Private Function checkForEmpty(attr As String) As String
         If Not IsNumeric(attr) Then
            Return "0"
         End If
         Return attr
      End Function
      Private Sub M9_Abend(ErrMsg As String)
         Throw New Exception(ErrMsg)
      End Sub
      ' v2.2
      Private Sub processTimeLeftInPeriod(TimeLeftInPeriod As String, oCoversDTO As CoversDTO, Periods As Integer, MinutesPerPeriod As Integer)
         ' Ubound folloed by Time literal
         ' 0 >final<  
         ' 0 >halftime<  
         ' 1 >1st 6:06< 
         ' 1 >1st end< 
         Dim ar As String()

         ar = Split(LCase(TimeLeftInPeriod))
         ' 0 >final<  
         ' 0 >halftime<  
         If UBound(ar) = 0 Then
            If ar(0) = "final" Then
               oCoversDTO.GameStatus = GameStatus.Final
            ElseIf ar(0) = "half time" Or ar(0) = "halftime" Then
               oCoversDTO.Period = CInt(Periods / 2)
               oCoversDTO.SecondsLeftInPeriod = 0
            Else
               M9_Abend("Covers processTimeLeftInPeriod error - TimeLeftInPeriod = " & TimeLeftInPeriod)
            End If
            Exit Sub
         End If

         ' 2 >1st OT 1:04<
         If UBound(ar) = 2 Then     ' >1st OT 1:04<
            oCoversDTO.Period = CInt(Left(ar(0), 1)) + Periods
            oCoversDTO.SecondsLeftInPeriod = convertTime2Seconds(CStr(ar(2)))
            If UCase(ar(1)) <> "OT" Then
               M9_Abend("Covers processTimeLeftInPeriod error - TimeLeftInPeriod = " & TimeLeftInPeriod)
            End If
            Exit Sub
         End If

         ' 1 >1st 6:06< 
         ' 1 >1st end< 
         If InStr(1, ar(0), "ot", vbTextCompare) > 0 Then
            oCoversDTO.Period = Periods + 1
         Else
            oCoversDTO.Period = CInt(Left(ar(0), 1))
         End If


         oCoversDTO.SecondsLeftInPeriod = convertTime2Seconds(CStr(ar(1)))

      End Sub
      Private Function convertTime2Seconds(sTime As String) As Integer
         If sTime = "end" Then
            convertTime2Seconds = 0
            Exit Function
         End If

         Dim ar() As String
         ar = Split(sTime, ":")  ' mm:ss
         convertTime2Seconds = CInt(ar(0)) * 60 + CInt(ar(1))
      End Function

      Private Function getCoversRotationHtml(GameDate As Date, LeagueName As String, CoversUrl As String) As String
         Dim url As String = genCoversRotationUrl(GameDate, LeagueName, CoversUrl)
         Dim oWebPageGet As WebPageGet = New WebPageGet()
         oWebPageGet.NewWebPageGet(url, 3, True)
         If oWebPageGet.ReturnCode <> 0 Then
            Throw New Exception("WebPageGet error" + vbCrLf + oWebPageGet.ToString())
         End If
         Return oWebPageGet.Html
      End Function
      Private Function genCoversRotationUrl(GameDate As Date, LeagueName As String, CoversUrl As String) As String
         ''  http://www.covers.com/Sports/WNBA/Matchups?selectedDate=2015-06-12
         Return LCase(($"{CoversUrl}/Sports/{LeagueName}/Matchups?selectedDate=")) & Format(GameDate, "yyyy-MM-dd")
      End Function
      Private Function genCoversBoxScoreUrl(GameDate As Date, LeagueName As String, MultiYearLeague As Boolean, BoxscoreNumber As String) As String
         Dim yr As Integer = Year(GameDate)
         Dim nextYear As Integer
         If MultiYearLeague Then
            If Month(GameDate) > 7 Then
               nextYear = yr + 1
            Else
               nextYear = yr
               yr = nextYear - 1
            End If
         End If
         Dim CoversYear As String = yr.ToString & (IIf(MultiYearLeague, "-" + (nextYear).ToString, "")).ToString()
         ' MultiYearLeague = Year hyphen Year+1 -  NBA 2019-2020 else 2020
         ' NBA  - https://www.covers.com/pageLoader/pageLoader.aspx?page=/data/nba/results/2019-2020/boxscore1006731.html
         ' WNBA - https://www.covers.com/pageLoader/pageLoader.aspx?page=/data/wnba/results/2019/boxscore1005541.html
         Return LCase(
            $"https://www.covers.com/pageLoader/pageLoader.aspx?page=/data/{LeagueName}/results/{CoversYear}/boxscore{BoxscoreNumber}.html"
         )
      End Function

      'http://www.covers.com/pageLoader/pageLoader.aspx?page=/data/wnba/results/2015/boxscore895085.html
      'Private Function getBoxscoreNumber(Url As String)
      '   Dim x As Long, y As Long
      '   x = InStr(1, Url, "BoxScore", vbTextCompare) + 8
      '   y = InStr(x, Url, ".", vbTextCompare)
      '   getBoxscoreNumber = Mid(Url, x, y - x)

      'End Function


      Private Function errorCheck(message As String) As Boolean
         If oParseRotation.Ptr = 0 Then
            ReturnCode = -1
            message = message
            Return True
         End If
         Return False
      End Function
   End Class
End Namespace