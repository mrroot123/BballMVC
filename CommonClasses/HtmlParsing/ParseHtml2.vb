Option Explicit On
Imports System.IO
' Ver    Description
'  v1     Prior
'  v2.1   11-08-2019
Namespace Common4vb.HtmlParsing
   Public Class ParseHtml2

      Public ReturnCode As Long
      Public ErrorMessage As String

      Dim pPtrEnd As Long
      Private pPreviousPtr As Long
      Private AbendOnNotFound As Boolean = False


      Const HTML_INVALID As Integer = -1
      Const HTML_OUTER As Integer = 0
      Const HTML_INNER As Integer = 1
      Const HTML_OUTER_END_TAG As Integer = 2
      Public Overrides Function ToString() As String
         ToString = "" _
                  & vbCrLf & "ReturnCode   - " & ReturnCode _
                  & vbCrLf & "ErrorMessage - " & ErrorMessage _
                  & vbCrLf & "Ptr          - " & Ptr _
                  & vbCrLf & "InnerHtml    - " & InnerHtml _
                  & vbCrLf & "OuterHtml    - " & OuterHtml _
                  & ""
      End Function

      Public Property Html As String
      Public Property Ptr As Long
      Public Property OuterHtml As String
      Public Property InnerHtml As String
      Public Property oWebPageGet As WebPageGet

      '***
      '*** Constructor
      '***
      Public Sub New(Html As String)
         Me.Html = Html
         Ptr = 1
      End Sub
      Public Sub New(Url As String, StartString As String, EndString As String)
         '   Dim xml As Object, y As Long
         '   Set xml = CreateObject("MSXML2.ServerXMLHTTP") '*** XMLHTTP
         '
         '   xml.Open "GET", Url, False
         '   xml.send
         Dim y As Long
         oWebPageGet = New WebPageGet
         Call oWebPageGet.NewWebPageGet(Url, 10)

         If oWebPageGet.ReturnCode <> 0 Then
            ReturnCode = oWebPageGet.ReturnCode
            Select Case oWebPageGet.StatusCode
               Case 404
                  ErrorMessage = "Url not found - " & Url
               Case Else
                  ErrorMessage = "Web Page Error - Status: " & oWebPageGet.StatusCode & vbCrLf & oWebPageGet.ErrorMsg
            End Select
            Exit Sub
         End If
         Html = oWebPageGet.Html
         Ptr = InStr(1, Html, StartString, vbTextCompare)
         If Ptr > 0 Then
            If EndString > "" Then
               y = InStr(Ptr + 1, Html, EndString, vbTextCompare)
               If y > 0 Then
                  Html = Mid(Html, Ptr, y - Ptr + 1)
               Else
                  Html = Mid(Html, Ptr)
               End If
               Ptr = 1
            End If
         End If
      End Sub

      Public Sub WriteHtmlToDisk(FileName As String)
         File.WriteAllText(FileName, Html)
      End Sub
      Public Sub ResetPrt()
         Ptr = pPreviousPtr  '11/08/2012

      End Sub
      Public Sub FindString(SearchString As String, Optional AbendOnNotFound As Boolean = False)
         Ptr = InStr(Ptr, Html, SearchString, vbTextCompare)
         If AbendOnNotFound Then ZeroPtrCheck("FindString")

      End Sub
      'v2.2
      Public Function FindStringInHtml(SearchString As String) As Long
         FindStringInHtml = InStr(1, Html, SearchString, vbTextCompare)
      End Function
      ' v2.1
      ' <tag> Inner Html </tag>
      ' StartTagOpen    EndTagOpen
      ' StartTagClose   EndTagClose
      '
      ' < - Open  Close - >
      '
      ' Find Beginning of Element & Set Outer & Inner Html
      Public Sub SetElement()
         pointToPrevOpen("")
         SetOuterHtmlFromPtr(Ptr)
         pointToNextClose()
         Ptr = Ptr + 1
         setNestedInnerHtml(getTagNameFromOuterHtml())
      End Sub
      ' v2.1
      Private Function getTagNameFromOuterHtml() As String
         If IsNothing(OuterHtml) Or OuterHtml = "" Then Return ""

         Dim ar() As String = OuterHtml.Split(" ")
         Return ar(0)
      End Function
      ' <tag> Inner Html </tag>
      ' StartTagOpen    EndTagOpen
      ' StartTagClose   EndTagClose
      '
      ' < - Open  Close - >
      '
      Public Function GetNextElement() As String

         Select Case getHtmlPtrLocation()
            Case HTML_INVALID
               m9_abend("GetNextElement - HTML_INVALID")

            Case HTML_OUTER_END_TAG
               pointToInnerHtmlEndTagOpen()
               bumpPtrIfNotZero()

            Case HTML_OUTER
               pointToNextClose()
               Ptr = Ptr + 1   ' point to Inner html
               Call setNestedInnerHtml("")
               '    pprt = Ptr + 1   ' point to Inner html
               pointToInnerHtmlEndTagOpen()
               bumpPtrIfNotZero()

            Case HTML_INNER
               pointToInnerHtmlEndTagOpen()
               pointToNextClose()
               bumpPtrIfNotZero()
         End Select
         If Ptr = 0 Then
            Return ""
         End If

         pointToStartTagOpen()
         Return InnerHtml
      End Function
      Private Sub pointToInnerHtmlEndTagOpen()
         ' next Tag will be an Open

         Dim level As Integer
         level = 1
         Do While level > 0
            Call pointToNextEndTagOpen()  ' v2.1
            If startTagOpen() Then
               level = level + 1
            Else
               level = level - 1
            End If
         Loop

      End Sub
      ' <tag
      ' ^
      Private Sub pointToStartTagOpen()
         Do While True
            pointToNextOpen("")
            If Ptr = 0 Or startTagOpen() Then
               Exit Sub
            End If
         Loop
      End Sub
      Private Sub pointToNextOpen(TagName As String)
         Ptr = InStr(Ptr, Html, "<" & TagName, vbTextCompare)
         Do While True
            Ptr = InStr(Ptr, Html, "<" & TagName, vbTextCompare)
            If Ptr = 0 Then Return
            If Mid(Html, Ptr, 2) <> "</" Then Return
            Ptr = Ptr + 1  ' v2.1 
         Loop
      End Sub

      ' v2.1 - modified
      ' <div ... 
      ' ^ point here
      Private Sub pointToPrevOpen(TagName As String)
         Ptr = InStrRev(Html, "<" & TagName, Ptr, vbTextCompare)
         Do While Ptr > 0
            If Mid(Html, Ptr, 2) <> "</" Then Return
            Ptr = InStrRev(Html, "<" & TagName, Ptr - 1, vbTextCompare)
         Loop
      End Sub
      ' v2.1 - new method
      Private Sub pointToNextEndTagOpen()
         Ptr = InStr(Ptr, Html, "</", vbTextCompare)
      End Sub
      Private Sub pointToNextClose()
         Ptr = InStr(Ptr, Html, ">", vbTextCompare)
      End Sub
      Private Function startTagOpen() As Boolean
         startTagOpen = Not endTagOpen()
      End Function
      Private Function endTagOpen() As Boolean
         endTagOpen = (Mid(Html, Ptr, 2) = "</")
      End Function
      Private Sub bumpPtrIfNotZero()
         If Ptr > 0 Then
            Ptr = Ptr + 1
         End If
      End Sub
      Private Function search4Ele(TagName As String, bSearch4PreviousEle As Boolean) As Boolean   'True = Element not found
         pPreviousPtr = Ptr  '11/08/2012

         If bSearch4PreviousEle Then
            Ptr = InStrRev(Html, "<" & TagName, Ptr, vbTextCompare)   '*** point to <td  ie for example
         Else
            Ptr = InStr(Ptr, Html, "<" & TagName, vbTextCompare)   '*** point to <td  ie for example
         End If

         If Ptr = 0 Then
            InnerHtml = ""
            Return True

         End If
         pPtrEnd = InStr(Ptr, Html, ">", vbTextCompare)              '*** point to end of eleHdr <td ... >
         OuterHtml = Mid(Html, Ptr, pPtrEnd - Ptr + 1)                '*** Save Ele Hdr ex: <td>

         'chk following statement - rewrite Ptr = pPtrEnd + 1
         Ptr = InStr(Ptr, Html, ">", 1) + 1        '*** point to value <td>abc</td>
         '                       ^^^
         If Right(Replace(OuterHtml, " ", ""), 2) = "/>" Then    '<td ... />
            InnerHtml = ""
            Return True
         End If
         Return False
      End Function
      '***
      '*** Extract the value (InnerHTML) from an HTML Element ***
      '*** Ptr will point past Value to </ele> when done
      '*** OuterHtml is set
      '*** <? ....>value</?> - where ? = HtmlEle - td for example
      Public Function GetHtmlEle(HtmlEle As String, Optional AbendOnNotFound As Boolean = False) As String
         Const bSearch4PreviousEle As Boolean = False
         GetHtmlEle = ""

         If search4Ele(HtmlEle, bSearch4PreviousEle) Then
            If AbendOnNotFound Then ZeroPtrCheck("GetHtmlEle")
            Exit Function
         End If

         Call setNestedInnerHtml(HtmlEle)

         If AbendOnNotFound Then ZeroPtrCheck("GetHtmlEle")

         GetHtmlEle = InnerHtml
      End Function

      '***
      '*** Extract the value from the previous HTML Element ***
      '*** Ptr will point past Value to </ele> when done
      '*** OuterHtml is set
      '*** <? ....>value</?> - where ? = HtmlEle - td for example
      '*** This code is the same as GetHtmlEle except for InStrRev
      Public Function GetPrevHtmlEle(HtmlEle As String, Optional AbendOnNotFound As Boolean = False) As String
         Const bSearch4PreviousEle As Boolean = True
         GetPrevHtmlEle = ""


         Ptr = InStr(Ptr, Html, HtmlEle, vbTextCompare)


         If search4Ele(HtmlEle, bSearch4PreviousEle) Then
            If AbendOnNotFound Then ZeroPtrCheck("GetPrevHtmlEle")
            Exit Function
         End If

         Call setNestedInnerHtml(HtmlEle)

         If AbendOnNotFound Then ZeroPtrCheck("GetPrevHtmlEle")

         GetPrevHtmlEle = InnerHtml
      End Function

      ' Get Attribute from OuterHtml
      Public Function GetAttribute(AttributeName As String) As String
         Dim Ptr As Long, ptrValueStart As Long
         Dim delim As String

         AttributeName = Trim(AttributeName)

         Ptr = InStr(2, OuterHtml, AttributeName, vbTextCompare)
         If Ptr = 0 Then
            Return ""   ' AttributeName does not exist
         End If

         ' attr="value"
         ' attr = "value"
         ' attr=value
         ' Find equal sign
         Ptr = Ptr + Len(AttributeName)  'sb pointing to = unless extraneous spaces
         ' attr=value
         ' ptr ^
         Do While Mid(OuterHtml, Ptr, 1) <> "="
            Ptr = Ptr + 1  ' bypass spaces
            If Ptr > Len(OuterHtml) Then m9_abend("Equal sign not found for Attribute " & AttributeName)
         Loop
         Ptr = Ptr + 1  ' bypass equal
         ' Get Attr value delimiter
         Do While Mid(OuterHtml, Ptr, 1) = " "
            Ptr = Ptr + 1  ' bypass spaces
            If Ptr > Len(OuterHtml) Then m9_abend("Equal sign not found for Attribute " & AttributeName)
         Loop

         ' Now pointing to attr delimeter - ie ' or " or none
         delim = Mid(OuterHtml, Ptr, 1)
         If delim = "'" Or delim = """" Then
            Ptr = Ptr + 1  ' point to 1st attr val char
         Else
            delim = " "    ' un-quoted value
         End If
         ptrValueStart = Ptr
         Do While Ptr <= Len(OuterHtml)
            If Mid(OuterHtml, Ptr, 1) = delim Then
               Return Mid(OuterHtml, ptrValueStart, Ptr - ptrValueStart)
            End If
            Ptr = Ptr + 1
         Loop
         If delim = " " Then
            GetAttribute = Mid(OuterHtml, ptrValueStart, Ptr - ptrValueStart)
         End If
         Return ""
      End Function

      ' 12345
      ' < x >  StartChar = 2, > = 5, Len = 3
      Public Sub SetOuterHtml()
         Dim ptrEnd As Long
         ptrEnd = InStr(2, Html, ">", vbTextCompare)
         OuterHtml = Mid(Html, 2, ptrEnd - 2)
      End Sub
      ' v2.1 new
      Public Sub SetOuterHtmlFromPtr(ptr As Long)
         Dim ptrEnd As Long
         ptrEnd = InStr(ptr + 1, Html, ">", vbTextCompare)
         OuterHtml = Mid(Html, ptr + 1, ptrEnd - ptr - 1)
      End Sub
      ' v2.1 new
      Public Sub SetInnerHtmlFromPtr(ptrStart As Long)
         pointToInnerHtmlEndTagOpen()
         InnerHtml = Mid(Html, ptrStart, Ptr - ptrStart)
      End Sub
      '*** Search Ele with ID in Ele Hdr
      '*** Extract the value from an HTML Element ***
      '*** Ptr will point past Value to </ele> when done
      '*** OuterHtml is set
      '*** <? ....>value</?> - where ? = HtmlEle - td for example
      Public Function GetHtmlByID(HtmlEle As String, id As String) As String

         pPreviousPtr = Ptr  '11/08/2012

         Do While True
            Ptr = InStr(Ptr, Html, "<" & HtmlEle, vbTextCompare)   '*** point to <td  ie for example
            If Ptr = 0 Then
               GetHtmlByID = ""
               Exit Function
            End If
            pPtrEnd = InStr(Ptr, Html, ">", vbTextCompare)              '*** point to end of eleHdr <td ... >
            OuterHtml = Mid(Html, Ptr, pPtrEnd - Ptr + 1)                '*** Save Ele Hdr ex: <td>

            If InStr(1, OuterHtml, id, vbTextCompare) > 0 Then
               Exit Do
            End If
            Ptr = pPtrEnd
         Loop

         Ptr = InStr(Ptr, Html, ">", 1) + 1              '*** point to value <td>abc</td>
         '                       ^
         If Mid(Html, Ptr - 2, 1) = "/" Then                  '<td ... />  empty element
            InnerHtml = ""
            GetHtmlByID = InnerHtml
            Exit Function
         End If

         Call setNestedInnerHtml(HtmlEle)
         GetHtmlByID = InnerHtml

      End Function
      '11/08/2013
      ' v.2.1 - renamed getNestedInnerHtml to setNestedInnerHtml
      ' Sets InnerHtml
      ' on Entrance Ptr points to start of Inner Html
      ' Points to Close Element - </ele WHEN done
      Private Sub setNestedInnerHtml(HtmlEle As String)
         Dim nLevel As Integer, nNextEleStart As Long
         Dim OpenEle As String, CloseEle As String
         Dim OpenEleLen As Integer, CloseEleLen As Integer
         ' Op - Open Ele   Cl - Close ele
         '  Nested example: <td> abc <td> xxx </td></td>
         '                  1Op      2op      2cl  1Cl
         '                                          nNextEleStart
         '                                         pPtrEnd
         ' lvl = 1
         OpenEle = "<" & HtmlEle
         OpenEleLen = Len(OpenEle)
         CloseEle = "</" & HtmlEle
         CloseEleLen = Len(CloseEle)

         nLevel = 1
         nNextEleStart = Ptr   'Point to start of Inner Html

         While nLevel > 0
            Select Case True
               Case Mid(Html, nNextEleStart, CloseEleLen) = CloseEle   ' </tag
                  nLevel = nLevel - 1

               Case Mid(Html, nNextEleStart, OpenEleLen) = OpenEle     'nNextEleStart points to the <tag  of the following: <td>   or <td />
                  pPtrEnd = InStr(nNextEleStart, Html, ">", vbTextCompare)
                  If Not Right(Replace(Mid(Html, nNextEleStart, pPtrEnd - nNextEleStart + 1), " ", ""), 2) = "/>" Then
                     nLevel = nLevel + 1
                  End If
            End Select
            nNextEleStart = nNextEleStart + 1
            If nLevel > 20 Then
               m9_abend("ParseHtml2.setNestedInnerHtml - Nest Level exceeds max - probably looping")
            End If
         End While
         InnerHtml = Mid(Html, Ptr, nNextEleStart - 1 - Ptr)
         Ptr = Ptr + Len(InnerHtml)           'Point to Close Element - </ele
      End Sub


      Public Sub StringSearch(s As String)
         pPreviousPtr = Ptr  '11/08/2012

         Ptr = InStr(Ptr, Html, s, vbTextCompare)
      End Sub


      Public Function dis(chars As Integer)
         dis = Mid(Html, Ptr, chars)
      End Function

      'Public Sub HtmlToFile(fileName As String)
      '   Call fWriteTextStream(fileName, Html)
      'End Sub

      ' <tag outer>Inner text</tag>
      ' <tr><td>abc <b>bold</b> xyz</td></tr>
      '
      ' -1 - Invalid html
      '  0 - Outer Html
      '  1 - Inner html
      '  2 - Outer Html end tag


      Private Function getHtmlPtrLocation() As Integer
         If Mid(Html, Ptr, 1) = "<" Then
            If Mid(Html, Ptr + 1, 1) = "/" Then
               getHtmlPtrLocation = HTML_OUTER_END_TAG
            Else
               getHtmlPtrLocation = HTML_OUTER
            End If
            Exit Function
         End If

         If Mid(Html, Ptr, 1) = ">" Or
            InStr(Ptr, Html, "<", vbTextCompare) > InStr(Ptr, Html, ">", vbTextCompare) Then
            If InStrRev(Html, "<", Ptr, vbTextCompare) = 0 Then
               getHtmlPtrLocation = HTML_INVALID
            ElseIf Mid(Html, InStrRev(Html, "<", Ptr, vbTextCompare) + 1, 1) = "/" Then
               getHtmlPtrLocation = HTML_OUTER_END_TAG
            Else
               getHtmlPtrLocation = HTML_OUTER
            End If
         Else
            getHtmlPtrLocation = HTML_INNER
         End If

      End Function

      Sub ZeroPtrCheck(msg As String)
         If Ptr = 0 Then
            m9_abend("ParseHtml2 - Zero Ptr - " & msg)
         End If

      End Sub

      Private Sub m9_abend(msg As String)
         Throw New System.Exception("m9_abend: " & msg)
      End Sub
   End Class
End Namespace