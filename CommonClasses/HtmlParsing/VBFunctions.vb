Option Explicit On

Namespace HtmlParsing.Functions

   Public Class VBFunctions

      Public Shared Function URLEncode(StringToEncode As String) As String

         Dim TempAns As String = ""
         Dim CurChr As Integer
         CurChr = 1

         Do Until CurChr - 1 = Len(StringToEncode)
            Select Case Asc(Mid(StringToEncode, CurChr, 1))
               Case 48 To 57, 65 To 90, 97 To 122
                  TempAns = TempAns & Mid(StringToEncode, CurChr, 1)
               Case 32
                  TempAns = TempAns & "%" & Hex(32)
               Case Else
                  TempAns = TempAns & "%" &
                    Right("0" & Hex(Asc(Mid(StringToEncode, CurChr, 1))), 2)
            End Select

            CurChr = CurChr + 1
         Loop

         URLEncode = TempAns
      End Function
      'Public Shared Function DictionarySort(dctList As Dictionary(Of String, Object)) As Dictionary(Of String, Object)
      '   Dim arrTemp() As String
      '   Dim curKey As Object
      '   Dim itX As Integer
      '   Dim itY As Integer

      '   'Only sort if more than one item in the dict
      '   If dctList.Count > 1 Then

      '      'Populate the array
      '      ReDim arrTemp(dctList.Count - 1)
      '      itX = 0
      '      For Each curKey In dctList
      '         arrTemp(itX) = curKey
      '         itX = itX + 1
      '      Next

      '      'Do the sort in the array
      '      For itX = 0 To (dctList.Count - 2)
      '         For itY = (itX + 1) To (dctList.Count - 1)
      '            If arrTemp(itX) > arrTemp(itY) Then
      '               curKey = arrTemp(itY)
      '               arrTemp(itY) = arrTemp(itX)
      '               arrTemp(itX) = curKey
      '            End If
      '         Next
      '      Next

      '      'Create the new dictionary
      '      DictionarySort = CreateObject("Scripting.Dictionary")
      '      For itX = 0 To (dctList.Count - 1)
      '         DictionarySort.Add(arrTemp(itX), dctList(arrTemp(itX)))
      '      Next

      '   Else
      '      DictionarySort = dctList
      '   End If
      'End Function

      '      Private Sub testSort()
      '         Dim d As Scripting.Dictionary(Of String, Object)
      '         Dim ds As Scripting.Dictionary

      '   Set d = CreateObject("Scripting.Dictionary")
      '   d.Add "b", "Two"
      '   d.Add "c", "Three"
      '   d.Add "a", "One"

      '   Set ds = DictionarySort(d)
      '   Set d = Nothing

      '      For Each varKey In oCoversRotation.ocRotation.Keys()
      '            oCoversRotation.ocRotation(varKey)
      'End Sub

   End Class
End Namespace

