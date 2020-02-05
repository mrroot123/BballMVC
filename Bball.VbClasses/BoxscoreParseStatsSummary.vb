Option Explicit On   'Explicitly declared vars
Option Strict On     'Types must be the same or converted

Imports System.Text
Imports Bball.VbClasses.Bball.VbClasses.BballConstants
Imports HtmlParsing.Common4vb.HtmlParsing


Namespace Bball.VbClasses
   Public Class BoxscoreParseStatsSummary

      ' Summary Stats - Parse Quarters / Periods for Both Teams

      '  Away & Home next
      '<table id="nbaGITeamStats"
      '
      '--Player TR
      '<tr class="odd">
      '   <td id="nbaGIBoxNme">
      '   <td class="nbaGIPosition"> </td>
      '
      '--Total TR
      '<tr class="even">
      '   <td id="nbaGIBoxNme" class="nbaGIScrTot">Total</td>
      '   <td> </td>

      Public ReturnCode As Long
      Public ErrorMessage As String
      Const warning As Integer = 1
      Const cancelBoxscore = 11
      Private arVenuePeriodScores(1) As List(Of String)    'Aw & Hm
      Private pPeriods As Integer
      Public Function BBrefBoxscore() As String
         BBrefBoxscore = "BB-Ref"
      End Function
      Public Function NBAboxscore() As String
         NBAboxscore = "NBA"
      End Function
      Public Function CoversBoxscore() As String
         CoversBoxscore = "Covers"
      End Function
      Public Function ScoreReg(ixVenue As Integer) As Integer  'Get Team Score in Regulation
         Dim i As Integer
         For i = 0 To pPeriods - 1
            ScoreReg = ScoreReg + PeriodScore(ixVenue, i)
         Next
         Return ScoreReg
      End Function
      Public Function ScoreOT(ixVenue As Integer) As Integer 'Get Team Final Score i
         Dim i As Integer
         For i = 0 To arVenuePeriodScores(ixVenue).Count - 1
            ScoreOT = ScoreOT + PeriodScore(ixVenue, i)
         Next
         Return ScoreOT
      End Function

      Public Function PeriodScore(ixVenue As Integer, Period As Integer) As Integer
         Dim ocPeriodScores As List(Of String)
         ocPeriodScores = arVenuePeriodScores(ixVenue)
         PeriodScore = CInt(ocPeriodScores.Item(Period))
      End Function
      Public Function OtPeriods() As Integer
         OtPeriods = arVenuePeriodScores(1).Count - pPeriods
      End Function
      Public Sub NewBoxscoreParseStatsSummary(BoxScoreSource As String, PeriodsHtml As String, GameDate As Date, LeagueName As String, Periods As Integer)

         Select Case BoxScoreSource
            Case BBrefBoxscore()
               Call InitBasketBallReferenceBoxscore(PeriodsHtml, GameDate, LeagueName, Periods)
            Case NBAboxscore()
               Call InitNBAboxscore(PeriodsHtml, GameDate, LeagueName, Periods)
            Case CoversBoxscore()
               Call InitCoversBoxscore(PeriodsHtml, GameDate, LeagueName, Periods)
         End Select

         '  Call Init(PeriodsHtml, GameDate, LeagueName, Periods)
         If ReturnCode <> 0 Then Throw New Exception("NewBoxscoreParseStatsSummary - " & ErrorMessage)

         'Dim ixVenue As Integer
         '   For ixVenue = ixAway To ixHome
         '     Call verifyTeamPeriodScores(ixVenue)
         '  Next
      End Sub
      Private Sub InitBasketBallReferenceBoxscore(PeriodsHtml As String, GameDate As Date, LeagueName As String, Periods As Integer)
         Dim oTable As New ParseHtml2(PeriodsHtml)
         '        Dim oTR As New ParseHtml2
         Dim ixVenue As Integer

         pPeriods = Periods
         ' oTable.newParseHtml2(PeriodsHtml)

         '  1       <tr>  <th colspan="6">Scoring</th>
         '  2 HEAD  <tr class='thead'> <th>1</th> th>2</th> <th>3</th> <th>4</th> <th>OT</th> <th>T</th>
         '  3 AWAY  <tr>
         '         td 1 <td><a href="/teams/PHO/2017.html">PHO</a></td>
         '         td 2 Qtr 1 <td>40</td> <td>13</td> <td>30</td> <td>19</td> <td>8</td>
         '           <td><strong>110</strong></td>
         '  4 HOME  <tr>
         '           <td><a href="/teams/OKC/2017.html">OKC</a></td>
         '           <td>25</td> <td>24</td> <td>28</td> <td>25</td> <td>11</td>
         '           <td><strong>113</strong></td>

         oTable.GetHtmlEle("tr")                        ' Bypass Qtr hdr row
         oTable.GetHtmlEle("tr")                        ' Bypass Qtr hdr row

         For ixVenue = AWAY To HOME
            Dim oTR As ParseHtml2 = New ParseHtml2(oTable.GetHtmlEle("tr"))     'get  QTRs

            Dim tm As String
            tm = oTR.GetHtmlEle("td")                            ' Bypass Team td
            Dim LastTD As Boolean
            Do While Not LastTD
               Dim td As String
               td = oTR.GetHtmlEle("td")
               If InStr(td, "strong") > 0 Then
                  Exit Do
               End If
               arVenuePeriodScores(ixVenue).Add(td)
            Loop
         Next

      End Sub
      Private Sub InitCoversBoxscore(PeriodsHtml As String, GameDate As Date, LeagueName As String, Periods As Integer)
         Dim oTable As ParseHtml2 = New ParseHtml2(PeriodsHtml)
         ' Dim oTR As New ParseHtml
         Dim ixVenue As Integer
         pPeriods = Periods
         ' oTable.newParseHtml2(PeriodsHtml)

         '       1 2 3 4 T Odds Bet Final
         'WAS   18 26 13 16 73
         'CONN  24 16 13 15 68

         oTable.GetHtmlEle("tr")                        ' Bypass Qtr hdr row
            For ixVenue = AWAY To HOME
                Dim oTR As ParseHtml2 = New ParseHtml2(oTable.GetHtmlEle("tr"))     'get  QTRs

                Dim tm As String
                tm = oTR.GetHtmlEle("td")                            ' Bypass Team td

                arVenuePeriodScores(ixVenue) = New List(Of String)()

                Do While True
                    Dim td As String
                    td = oTR.GetHtmlEle("td")
                    If InStr(oTR.OuterHtml, "col") = 0 Then
                        Exit Do
                    End If
                    arVenuePeriodScores(ixVenue).Add(editTD(td))
                Loop
            Next

        End Sub
      Private Function editTD(td As String) As String
         Dim sb As StringBuilder = New StringBuilder()

         For i As Integer = 1 To td.Length
            If IsNumeric(Mid(td, i, 1)) Then
               sb.Append(Mid(td, i, 1))
            End If
         Next i
         Return sb.ToString()
      End Function
      Private Sub InitNBAboxscore(PeriodsHtml As String, GameDate As Date, LeagueName As String, Periods As Integer)
         Dim oHtml As ParseHtml2 = New ParseHtml2(PeriodsHtml)
         'Dim oTR As ParseHtml
         pPeriods = Periods
         ' Call oHtml.newParseHtml2(PeriodsHtml)
         ' http://www.nba.com/games/20130522/INDMIA/gameinfo.html
         ' http://www.nba.com/games/20091102/MEMSAC/gameinfo.html

         '<table class="nbaGIRegul" cellspacing="0" cellpadding="0">
         '   <tbody>
         '   <tr>
         '      <td class="nbaGIQtrPts">31</td>
         '      <td class="nbaGIQtrPts">14</td>
         '      <td class="nbaGIQtrPts">28</td>
         '      <td class="nbaGIQtrPts">28</td>
         '      <td class="nbaGIQtrPtsLast">101</td>
         '   <tr> Spaces Ignore
         '   <tr>
         '      <td class="nbaGIQtrPts">21</td>
         '      <td class="nbaGIQtrPts">24</td>
         '      <td class="nbaGIQtrPts">13</td>
         '      <td class="nbaGIQtrPts">24</td>
         '      <td class="nbaGIQtrPtsLast">82</td>
         '   </tbody>
         '</table>
         '<table class="nbaGIOT" cellpadding="0" cellspacing="0">  OT follows IF OT and "nbaGIQtrPtsLast" in OT
         '   <tr>
         '      <td class="nbaGIQtrPts1OT">20</td>
         '      <td class="nbaGIQtrPtsLast">114</td>
         '   </tr>
         '   <tr>
         '      <td class="nbaGIQtrStatus">
         '         <div id="nbaGIQtrIndic" style="width:100%;height:9px;background:#cc0000;"></div>
         '      </td>
         '      <td class="nbaGIQtrStatus">
         '         <div id="nbaGIQtrIndic" style="width:50%;height:9px;background:#ccc;"></div>
         '      </td>
         '   </tr>
         '   <tr>
         '      <td class="nbaGIQtrPts1OT">14</td>
         '      <td class="nbaGIQtrPtsLast">108</td>
         '   </tr>
         '</table>

         ' todo IMPORTANT - 5/13/2014 - See Documentation\NBA Parce HTML examples.txt
         ' Fix OT situations
         ' Get AWAY Periods / Qtrs summery TR
         Dim oTR As ParseHtml2
         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))

         If oHtml.Ptr = 0 Then
            ErrorMessage = "Away Row not found"
            ReturnCode = cancelBoxscore
            Exit Sub
         End If
         Call parseTeamPeriodScores(oTR, AWAY)


         ' Get Spaces / Blank TR & bypass
         'Set oTR = New ParseHtml
         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))
         If oHtml.Ptr = 0 Then
            ErrorMessage = "Spacer Row not found"
            ReturnCode = cancelBoxscore
            Exit Sub
         End If

         ' Get HOME Periods / Qtrs summery TR

         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))
         If oHtml.Ptr = 0 Then
            ErrorMessage = "Home Row not found"
            ReturnCode = cancelBoxscore
            Exit Sub
         End If
         Call parseTeamPeriodScores(oTR, HOME)

         '*** Check for OT Periods ***

         ' Get AWAY OT Periods / Qtrs summery TR
         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))
         If oHtml.Ptr = 0 Then      ' No OT Periods so exit
            Exit Sub
         End If
         Call parseTeamPeriodScores(oTR, AWAY)


         ' Get Spaces / Blank TR & bypass
         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))
         If oHtml.Ptr = 0 Then
            ErrorMessage = "OT Spacer Row not found"
            ReturnCode = cancelBoxscore
            Exit Sub
         End If

         ' Get HOME OT Periods / Qtrs summery TR
         oTR = New ParseHtml2(oHtml.GetHtmlEle("tr"))
         If oHtml.Ptr = 0 Then
            ErrorMessage = "Home OT Row not found"
            ReturnCode = cancelBoxscore
            Exit Sub
         End If
         Call parseTeamPeriodScores(oTR, HOME)

      End Sub

      Private Sub parseTeamPeriodScores(oTR As ParseHtml2, ixVenue As Integer)
         Dim ocPeriodScores As New Collection
         Dim eleValue As String = oTR.GetHtmlEle("td")
         Do While oTR.Ptr > 0
            arVenuePeriodScores(ixVenue).Add(eleValue)
            eleValue = oTR.GetHtmlEle("td")
         Loop

         '   Set arVenuePeriodScores(ixVenue) = ocPeriodScores
         '   Call verifyTeamPeriodScores(ixVenue)

      End Sub

      Private Sub verifyTeamPeriodScores(ixVenue As Integer)
         '   Exit Sub  ' todo fix Getting OT periods
         Dim i As Integer, ctr As Integer
         Dim ocPeriodScores As List(Of String) = arVenuePeriodScores(ixVenue)
         For i = 1 To ocPeriodScores.Count - 1
            ctr = ctr + CInt(ocPeriodScores.Item(i))
         Next
         If ctr <> CInt(ocPeriodScores.Item(ocPeriodScores.Count)) Then
            ErrorMessage = venueName(ixVenue) & " Period Scores do not = Final"
            ReturnCode = warning
         End If

      End Sub

      Private Function venueName(ixVenue As Integer) As String
         Dim s As String = (IIf(ixVenue = 0, "Away".ToString(), "Home".ToString())).ToString()
         Return s
      End Function



   End Class
End Namespace
