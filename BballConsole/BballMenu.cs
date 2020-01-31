using System;
using Bball.BAL;
//using HtmlParsing.Common4vb.HtmlParsing;


namespace BballConsole
{
    class BballMenu
   {
      static string[] menu = new string[] {
           "1) Load Boxscore Range"
         , "2) Load Boxscore"
         , "3) Load Today's Rotation"
         , "4) Write Html to Disk"
         , "X) Exit"
      };
      static void Main(string[] args)
      {
         Trace.Trace.SetTraceFile(@"Trace.txt");
         Trace.Trace.SetLogFile(@"BballErrorLog.txt");

         string s = "";
         DateTime StartGameDate = Convert.ToDateTime("10/16/2018");
         while (s != "x")
         {
            try
            {
               switch (s)
               {
                  case "1":
                     LoadBoxScores l = new LoadBoxScores("NBA", DateTime.Now.ToString(), StartGameDate);

                     l.LoadBoxScoreRange();  //       DateTime.Today.AddDays(-4));
                     break;

                  case "2":
                     LoadBoxScores l2 = new LoadBoxScores("NBA", DateTime.Now.ToLongDateString(), StartGameDate);
                     l2.LoadBoxScore(DateTime.Today.AddDays(-1));
                     break;

                  case "3":
                     LoadBoxScores l3 = new LoadBoxScores("NBA", DateTime.Now.ToLongDateString(), StartGameDate);
                     l3.LoadTodaysRotation();
                     break;

                  case "4":
                     writeHtmlToDisk();
                     break;

                  default:
                     break;
               }
            }
            catch (Exception ex)
            {
               string msg = SysDAL.DALfunctions.StackTraceFormat(ex);
               Trace.Trace.Log(msg);
               Console.WriteLine(msg);
            }

            for (int i = 0; i < menu.Length; i++)  // Display Menu
               Console.WriteLine(menu[i]);

            Console.Write("Make Selection: ");
            s = Console.ReadLine().ToLower();

         }  // while
      }  // Main
      static void writeHtmlToDisk()
      {
         string s = "";
         //string url;
         //string FileName;
         //while (s != "x")
         //{
         //   Console.Write("Enter x to EXIT or ");
         //   Console.Write("Enter URL: ");
         //   url = Console.ReadLine().ToLower();
         //   if (url.ToLower() == "x")
         //      return;
         //   const string defaultFileName = @"T:\Bball\Html\html.txt";
         //   Console.Write($"Enter FileName or Return to Default to {defaultFileName}: ");
         //   FileName = Console.ReadLine().ToLower();
         //   if (string.IsNullOrEmpty(FileName))
         //      FileName = defaultFileName;
         //   ParseHtml2 o = new ParseHtml2(url, "", "");
         //   o.WriteHtmlToDisk(FileName);

         //}  // while
      }
      
   }  // class
}
/*
 * 
 * Run Todays matchups
 * copy Schedule from .accdb -> .mdb 
 * copy schedule .mdb -> SS
 */
