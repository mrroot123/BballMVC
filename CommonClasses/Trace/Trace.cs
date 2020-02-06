using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.IO;

namespace Trace
{
    public static class Trace
   {
      public static bool TraceOn;
      public static bool DisplayOn;    // Display on console

      private static string _TraceFile;
      private static string _LogFile;
      public static bool LogOn;
      public static bool DisplayLogOn;    // Display on console

      private static DateTime _ThisTime = DateTime.Now;
      private  static DateTime tNow;

      private  static string _ThisEvent;

      const string DateFormat = "yyyy-MM-dd hh:mm:ss";

      
      public static void SetTraceFile(string TraceFile) =>  _TraceFile = TraceFile; // set fileName

      public static void SetLogFile(string LogFile) => _LogFile = LogFile; // set fileName

      public static void TurnTraceOff()
      {
         StartEvent(" ");  // Log Last Event
         TraceOn = false;
      }

      // Start new Event - 
      public static void StartEvent(string ThisEvent)
      {
         if (!(TraceOn | DisplayOn))
            return;

         tNow = DateTime.Now;
         if (_ThisEvent != "")
            logIt(_TraceFile);    // Log previous event
         _ThisEvent = ThisEvent;
         _ThisTime = tNow;
      }

      private  static string calcElapsedTime()
      {
         long secs;
         long mins;
         string strSecs;
         string strMins;
         secs = (long)(tNow - _ThisTime).TotalSeconds;
         mins = Convert.ToInt32( Math.Floor((double)(int)(secs / 60)));
         secs = secs - (mins * 60);

         strSecs = System.Convert.ToString(secs);
         if (strSecs.Length == 1)
            strSecs = "0" + strSecs;

         strMins = System.Convert.ToString(mins);
         if (strMins.Length == 1)
            strMins = "  " + strMins;
         else if (strMins.Length == 2)
            strMins = " " + strMins;

         return strMins + ":" + strSecs;
      }

      public static void Log(string LogMsg)
      {
         string s;
         s = $"{_ThisTime.ToString(DateFormat)}  - {LogMsg}";
         if (DisplayLogOn)
            System.Console.WriteLine(s);
         if (! String.IsNullOrEmpty(_LogFile))
            FileFunctions.AppendTextStream(_LogFile, s);
      }

      private static void logIt(string FileName)
      {
         string s;
         s = $"{_ThisTime.ToString(DateFormat)}  {calcElapsedTime()} - {_ThisEvent}";
         if (DisplayOn)
            System.Console.WriteLine(s);
         if (TraceOn)
            FileFunctions.AppendTextStream(FileName, s);
      }
   }  // class


   public class FileFunctions
   {
      public static void AppendTextStream(string FileName, string text)
      {
         string s = "";
         var filemode = FileMode.Truncate;
         if (File.Exists(FileName))
            s = File.ReadAllText(FileName);
         else
            filemode = FileMode.Create;

         using (FileStream oFileStream = new FileStream(FileName, filemode))
         {
            using (StreamWriter oStreamWriter = new StreamWriter(oFileStream))
            {
               try
               {
                  oStreamWriter.WriteLine(s + text);

                  oStreamWriter.Close();
                  oFileStream.Close();
               }
               catch (Exception ex)
               {
                  oStreamWriter.Close();
                  oFileStream.Close();
                  throw new Exception($"FileFunctions.AppendTextStream error: {ex.Message}");
               }
            }
         }
      }

      public static void AppendTextFilex(string path, string text)
      {
         //string path = @"c:\temp\MyTest.txt";
         // This text is added only once to the file.
         if (!File.Exists(path))
         {
            // Create a file to write to.
            using (StreamWriter sw = File.CreateText(path))
            {
               sw.WriteLine("");
            }
         }

         // This text is always added, making the file longer over time
         // if it is not deleted.
         using (StreamWriter sw = File.AppendText(path))
         {
            sw.WriteLine(text);
          }

         // Open the file to read from.
         using (StreamReader sr = File.OpenText(path))
         {
            string s = "";
            while ((s = sr.ReadLine()) != null)
            {
               Console.WriteLine(s);
            }
         }
      }
   }
}  // namespace
