Option Explicit On   'Explicitly declared vars
Option Strict On     'Types must be the same or converted


Imports HtmlParsing.Common4vb.HtmlParsing

Namespace Bball.VbClasses
   Public Class BoxscoreTeamTotalsParse

      '*** Description ***
      '***
      '=== Update Log ===
      'Created: 05/01/2014

      Const ClassName As String = "BoxscoreTeamTotalsParse"

      Public ReturnCode As Long
      Public ErrorMessage As String

      ' Public oBoxscoreTeamTotalsDTO As BoxscoreTeamTotalsDTO   ' ProcessTotalsLineRow will populate BoxscoreTeamTotalsDTO for ONE Team

      Private arTotalsLineFields As String()

      Const Pos_c As Long = 0
      Const WebPageColumnName_c As Long = 1
      Const DBcolumnName_c As Long = 2
      Const Processing_c As Long = 3
      Const Value1_c As Long = 4
      Const Value2_c As Long = 5

      Const BypassVar As String = "b"
      Const SplitVar As String = "s"
      Const MoveVar As String = "m"

      Private ar As String()

      ' 1) Load field TD Sequence in SetTotalsLineFields(TotalsLineFields  As String)
      '
      ' 2) ProcessTotalsLineRow(trTotalRowHtml As String)
      '
      ' oBoxscoreTeamTotalsDTO is now Populated and returned

      Public Sub SetTotalsLineFields(TotalsLineFields As String)
         arTotalsLineFields = Split(TotalsLineFields)
      End Sub
      Public Sub ProcessTotalsLineRow(trTotalRowHtml As String, oBoxscoreTeamTotalsDTO As BoxscoreTeamTotalsDTO)
         Dim var As String, vars As String(), e As String

         ' todo  initTable
         Dim oTR As ParseHtml2 = New ParseHtml2(trTotalRowHtml)

         'oBoxscoreTeamTotalsDTO = New BoxscoreTeamTotalsDTO
         For Each e In arTotalsLineFields
            var = Trim(oTR.GetHtmlEle("td"))
            Select Case LCase(e)
               Case "min"
                  ' Mins ex: 240:00
                  vars = Split(var, ":")

                  oBoxscoreTeamTotalsDTO.Minutes = CInt(CInt(Right(vars(0), 3)) / 5)  'Mins for 5 players so div by 5
               Case "mp"
                  oBoxscoreTeamTotalsDTO.Minutes = CInt(CInt(var) / 5)  'Mins for 5 players so div by 5

               Case "fgm-a"
                  vars = Split(var, "-")
                  oBoxscoreTeamTotalsDTO.PT2 = CInt(vars(0))
                  oBoxscoreTeamTotalsDTO.Pt2Attempts = CInt(vars(1))
               Case "fg"
                  oBoxscoreTeamTotalsDTO.PT2 = CInt(var)
               Case "fga"
                  oBoxscoreTeamTotalsDTO.Pt2Attempts = CInt(var)

               Case "ftm-a"
                  vars = Split(var, "-")
                  oBoxscoreTeamTotalsDTO.PT1 = CInt(vars(0))
                  oBoxscoreTeamTotalsDTO.Pt1Attempts = CInt(vars(1))
               Case "ft"
                  oBoxscoreTeamTotalsDTO.PT1 = CInt(var)
               Case "fta"
                  oBoxscoreTeamTotalsDTO.Pt1Attempts = CInt(var)

               Case "3pm-a"
                  vars = Split(var, "-")
                  oBoxscoreTeamTotalsDTO.PT3 = CInt(vars(0))
                  oBoxscoreTeamTotalsDTO.Pt3Attempts = CInt(vars(1))
               Case "3p"
                  oBoxscoreTeamTotalsDTO.PT3 = CInt(var)
               Case "3pa"
                  oBoxscoreTeamTotalsDTO.Pt3Attempts = CInt(var)

               Case "off"
                  oBoxscoreTeamTotalsDTO.OffRB = CInt(var)
               Case "orb"
                  oBoxscoreTeamTotalsDTO.OffRB = CInt(var)

               Case "ast"
                  oBoxscoreTeamTotalsDTO.Assists = CInt(var)

               Case "a"
                  oBoxscoreTeamTotalsDTO.Assists = CInt(var)

               Case "to"
                  oBoxscoreTeamTotalsDTO.TurnOvers = CInt(var)
               Case "tov"
                  oBoxscoreTeamTotalsDTO.TurnOvers = CInt(var)

               Case "pts"
                  oBoxscoreTeamTotalsDTO.TeamPoints = CInt(var)


            End Select
         Next

         'fgm-a has 2 & 3 PTers - Subtract the 3PTers from the 2PTers
         oBoxscoreTeamTotalsDTO.PT2 = oBoxscoreTeamTotalsDTO.PT2 - oBoxscoreTeamTotalsDTO.PT3
         oBoxscoreTeamTotalsDTO.Pt2Attempts = oBoxscoreTeamTotalsDTO.Pt2Attempts - oBoxscoreTeamTotalsDTO.Pt3Attempts
      End Sub
   End Class
End Namespace
