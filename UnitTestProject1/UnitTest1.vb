Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports Bball.VbClasses.Bball.VbClasses
Imports HtmlParsing.Common4vb.HtmlParsing
Imports BballMVC.DTOs
Imports Bball.BAL
'Imports Bball.DAL.SqlFunctions
Imports SysDAL.DALfunctions

Imports System.Reflection

'<TestClass()> Public Class UnitTest1
'   ' https://docs.microsoft.com/en-us/visualstudio/test/run-unit-tests-with-test-explorer?view=vs-2017
'   Public Sub TestCoversRotation()
'      ' Arrange-Act-Assert
'      Dim oLeagueDTO As LeagueDTO = New LeagueDTO _
'         With {.LeagueName = "NBA", .Periods = 4, .MinutesPerPeriod = 12, .OverTimeMinutes = 5, .MultiYearLeague = True}
'      Dim ocRotation As SortedList(Of String, CoversDTO) = New SortedList(Of String, CoversDTO)()
'      Dim d As Date = "11/23/2019"
'      Dim oCoversRotation As CoversRotation = New CoversRotation(ocRotation, d, oLeagueDTO)
'      Try
'         oCoversRotation.GetRotation()
'      Catch ex As Exception
'         Dim msg = IIf(InStr(ex.Message, "CallStack=") > 0, ex.Message, ex.Message & $" - CallStack= {ex.StackTrace}")
'         MsgBox(msg)
'      End Try

'   End Sub
' <TestMethod()> 
Public Sub Test_Insert()
      Try
         '  Functions.TestInsert()
      Catch ex As Exception

         Dim msg = IIf(InStr(ex.Message, "CallStack=") > 0, ex.Message, ex.Message & $" - CallStack= {ex.StackTrace}")
         MsgBox(msg)
      End Try
      MsgBox("Done")
   End Sub
   '<TestMethod()> Public Sub TestGetBoxScores()
   '   Dim cs As String = "   at Bball.VbClasses.Bball.VbClasses.BoxscoreParseStatsSummary.InitCoversBoxscore(String PeriodsHtml, DateTime GameDate, String LeagueName, Int32 Periods) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\BoxscoreParseStatsSummary.vb:line 148\n   at Bball.VbClasses.Bball.VbClasses.BoxscoreParseStatsSummary.NewBoxscoreParseStatsSummary(String BoxScoreSource, String PeriodsHtml, DateTime GameDate, String LeagueName, Int32 Periods) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\BoxscoreParseStatsSummary.vb:line 71\n   at Bball.VbClasses.Bball.VbClasses.CoversBoxscore.processPeriods(String BoxScoreUrl) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\CoversBoxscore.vb:line 118\n   at Bball.VbClasses.Bball.VbClasses.CoversBoxscore.GetBoxscore() in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\CoversBoxscore.vb:line 98\n   at Bball.BAL.LoadBoxScores.Load(DateTime GameDate) in D:\My Documents\wwwroot\BballMVC\Bball.BAL\LoadBoxScores.cs:line 54\n   at Bball.BAL.LoadBoxScores.LoadBoxScoreRange(DateTime GameDate) in D:\My Documents\wwwroot\BballMVC\Bball.BAL\LoadBoxScores.cs:line 30\n   at UnitTestProject1.UnitTest1.TestGetBoxScores() in D:\My Documents\wwwroot\BballMVC\UnitTestProject1\UnitTest1.vb:line 46"

   '   Dim oLoadBoxScores As LoadBoxScores = New LoadBoxScores("NBA", Convert.ToDateTime("10/22/2019"))
   '   Dim msg As String
   '   Try
   '      ' MSaccessDB.MStest("")

   '      Dim d As Date = CDate("10/26/2019")
   '      oLoadBoxScores.LoadBoxScoreRange()
   '   Catch ex As Exception
   '      msg = SysDAL.DALfunctions.StackTraceFormat(ex)
   '      MsgBox(msg)
   '   End Try
   '   MsgBox("Done")
   'End Sub
   Public Sub TestParser()
      If True Then Return

      Dim html As String = "<div><div outer=""out""><div><div>My inner html</div></div></div></div>"

      Dim oParse As New ParseHtml2(html)
      oParse.FindString("out")
      oParse.SetElement()

   End Sub
End Class