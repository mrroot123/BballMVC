Option Infer On
Imports System.Net.Http

Namespace Common4vb.HtmlParsing
   Public Class WebPageGet


      '  Public xml As XMLHTTP
      ' Public xml As New HttpClient


      Const Default_GetAttempts As Integer = 3

      '      Public Property Get XmlHttpObject() As XMLHTTP
      '         Set XmlHttpObject = xml
      'End Property

      Public Property Name As String
      Public Property Html As String

      Public Property Url As String

      Public Property ErrorMsg As String

      Public Property ReturnCode As Integer
      Public Property StatusCode As Integer

      Public Property GetAttempts As Integer

      Public Property DurationSeconds As Integer
      Public Property UrlLoadTime As Double

      Private _UseXmlHttp As Boolean
      Private _UsePostMethod As Boolean
      Private _QueryString As String

      Public Overrides Function ToString() As String
         ToString = "" _
            & "ReturnCode: " & ReturnCode & vbCrLf _
            & "ErrorMsg: " & ErrorMsg & vbCrLf _
            & "Url: " & Url & vbCrLf _
            & "StatusCode: " & StatusCode & vbCrLf _
            & "Get Attempts: " & GetAttempts & vbCrLf _
            & "Duration in Seconds: " & DurationSeconds & vbCrLf _
            & "UrlLoadTime: " & UrlLoadTime & vbCrLf _
            & Left(Html, 200) _
            & ""

      End Function

      Public Sub NewWebPagePost(Url As String, QueryString As String, Optional GetAttempts As Integer = Default_GetAttempts)
         Me.Url = Url
         _QueryString = QueryString
         Me.GetAttempts = GetAttempts
         _UsePostMethod = True
         Call getPage()
      End Sub
      Public Sub NewWebPageGet(Url As String, Optional GetAttempts As Integer = Default_GetAttempts, Optional UseXmlHttp As Boolean = False)
         Me.Url = Url
         Me.GetAttempts = GetAttempts
         _UseXmlHttp = UseXmlHttp

         Call getPage()
      End Sub
      Private Sub getPage()
         Dim ctr As Integer

         ctr = 0
         Do While True
            Try
               Call openAndSend()

               ' status 200,  readyState 4,   statusText  "OK"
               If ReturnCode = 0 Then
                  Exit Do
               End If
               Select Case StatusCode
                  Case 404
                     ErrorMsg = "Page not found - url = " & Url
                     Exit Sub

                  Case 500    'Internal Server error
                     ErrorMsg = "Internal Server error - url = " & Url
                     Exit Sub

                  Case 503    'Website Application Pool stopped
                     ErrorMsg = "Service Unavailable - url = " & Url
                     Exit Sub

                  Case 12031    'Website  stopped
                     ErrorMsg = "Website Unavailable - url = " & Url
                     Exit Sub
               End Select

               ctr = ctr + 1
               If ctr >= GetAttempts Then
                  '   bp
                  ErrorMsg = $"WebPageGet - getPage Number of Tries Error - url = {Url}  HttpRequestStatusCode = {StatusCode}"
                  ReturnCode = 1
                  Exit Sub
               End If
            Catch ex As Exception
               Dim msg = IIf(InStr(ex.Message, "CallStack=") > 0, ex.Message, ex.Message & $" - CallStack= {ex.StackTrace}")
               Throw New Exception($"WebPageGet.getPage: RC: {ReturnCode} - Error retrieving url: {Url} - {msg}")
            End Try
         Loop

      End Sub
      Private Sub openAndSend()
         Dim oTimer As New Stopwatch
         oTimer.Start()
         ReturnCode = 0
         ErrorMsg = ""
         If InStr(Url, "?") = 0 Then
            Url = Url & "?" & Mid(CStr(Rnd()), 3)
         Else
            Url = Url & "&" & Mid(CStr(Rnd()), 3)
         End If

         If _UsePostMethod Then
            callPostXMLHTTP()
         ElseIf _UseXmlHttp Then
            callXMLHTTP()
         Else
            callHttpClient()
         End If
         oTimer.Stop()
         Dim ts As TimeSpan = oTimer.Elapsed
         DurationSeconds = ts.Seconds
         UrlLoadTime = ts.TotalMilliseconds
      End Sub
      Private Sub callHttpClient()
         Using xml As New HttpClient
            xml.BaseAddress = New Uri(Url)

            Using response As HttpResponseMessage = xml.GetAsync("").Result  ' Blocking call! Program will wait here until a response Is received Or a timeout occurs.
               If response.IsSuccessStatusCode Then
                  Html = response.Content.ReadAsStringAsync().Result
               Else
                  StatusCode = CInt(response.StatusCode)
                  ReturnCode = StatusCode
                  ErrorMsg = response.ReasonPhrase
               End If
            End Using
         End Using
      End Sub
      Private Sub callXMLHTTP()
         Dim xml = CreateObject("MSXML2.ServerXMLHTTP")
         Try

            xml.Open("GET", Url, False)
            xml.Send()                            '*** Actually Sends the request and returns the data:
            If xml.readyState = 4 And xml.status = 200 Then
               Html = xml.responseText
            Else
               StatusCode = CInt(xml.status)
               ReturnCode = StatusCode
               ErrorMsg = xml.statusText
            End If

         Catch ex As Exception
            '          StatusCode = CInt(xml.status)
            '         ReturnCode = StatusCode
            ErrorMsg = ex.Message
            Throw New Exception("MSXML2.ServerXMLHTTP error: " + ErrorMsg)

         End Try

      End Sub
      Private Sub callPostXMLHTTP()
         Dim xml = CreateObject("MSXML2.ServerXMLHTTP")
         Try

            xml.Open("POST", Url, False)
            xml.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
            xml.send(_QueryString)                          '*** Actually Sends the request and returns the data:
            If xml.readyState = 4 And xml.status = 200 Then
               Html = xml.responseText
            Else
               StatusCode = CInt(xml.status)
               ReturnCode = StatusCode
               ErrorMsg = xml.statusText
            End If

         Catch ex As Exception
            '          StatusCode = CInt(xml.status)
            '         ReturnCode = StatusCode
            ErrorMsg = ex.Message
            Throw New Exception("MSXML2.ServerXMLHTTP error: " + ErrorMsg)

         End Try

      End Sub

   End Class

End Namespace
