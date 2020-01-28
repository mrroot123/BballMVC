Option Explicit On   'Explicitly declared vars
Option Strict On     'Types must be the same or converted

Imports Bball.VbClasses.Bball.VbClasses.BballConstants
Imports HtmlParsing.Common4vb.HtmlParsing
Imports BballMVC.DTOs

Namespace Bball.VbClasses
   Public Class CoversClass
      ' Covers Rotation

      ' BuildUrl
      '  Rotation
      '  Boxscore

      Dim ocRotation As SortedList(Of String, CoversDTO)
      Public oCoversRotation As CoversRotation
      Public oCoversBoxscore As CoversBoxscore

      Public ReturnCode As Integer
      Public ErrorMessage As String

      Private pGameDate As Date
      Private poLeagueDTO As LeagueDTO    '1.99.65
      'Private pLeagueName As String
      Private oParseBoxscore As ParseHtml2



      Public Sub New(GameDate As Date, oLeagueDTO As LeagueDTO)
         pGameDate = GameDate
         poLeagueDTO = oLeagueDTO

      End Sub

      Public Sub GetRotation()

         oCoversRotation = New CoversRotation(ocRotation, pGameDate, poLeagueDTO)
         Call oCoversRotation.GetRotation()

         If oCoversRotation.ReturnCode <> 0 Then
            ReturnCode = 1
            ErrorMessage = "GetRotation Error - " & oCoversRotation.Message
            Exit Sub
         End If
      End Sub

      Public Sub GetBoxscoreByTeamAway(TeamAway As String)
         Dim oCoversDTO As New CoversDTO

         For Each varKey In ocRotation.Keys()
            oCoversDTO = ocRotation(varKey)
            If oCoversDTO.TeamAway = TeamAway Then
               Exit For
            End If
         Next
         oCoversBoxscore = New CoversBoxscore(pGameDate, poLeagueDTO, oCoversDTO)
         Call oCoversBoxscore.GetBoxscore()

      End Sub

   End Class
End Namespace
