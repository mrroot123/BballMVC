using System;
using System.Collections.Generic;
using Bball.BAL;
using Bball.DAL;
using Bball.DAL.Tables;
//using HtmlParsing.Common4vb.HtmlParsing;


namespace BballConsole
{
    class BballMenu
   {
      static string[] menu = new string[] {
           "1) Load Today's Rotation"
         , "2) Load Adjustments"
         , "3) Write Html to Disk"
         , "4) Re-Load/Fix BoxScores by Day"

         , "X) Exit"
      };
      static void Main(string[] args)
      {
         
         string LeagueName = "NBA";
         DateTime GameDate;
         string s = "";
         DateTime StartGameDate = Convert.ToDateTime("10/16/2018");
         while (s != "x")
         {
            try
            {
               switch (s)
               {
                  case "x":
                     LoadBoxScores l = new LoadBoxScores("NBA", StartGameDate);

                     l.LoadBoxScoreRange();  //       DateTime.Today.AddDays(-4));
                     break;

                  case "y":
                     LoadBoxScores l2 = new LoadBoxScores("NBA",  StartGameDate);
                     l2.LoadBoxScore(DateTime.Today.AddDays(-1));
                     break;

                  case "1":   // Load Today's Rotation
                     LoadBoxScores l3 = new LoadBoxScores("NBA", StartGameDate);
                     l3.LoadTodaysRotation();
                     break;

                  case "2":   // Load Adjustments
                     GameDate = Convert.ToDateTime("03/11/2020");
                     AdjustmentsDO oAdjustments = new AdjustmentsDO(GameDate, LeagueName, Bball.DataBaseFunctions.SqlFunctions.GetConnectionString());
                     oAdjustments.ProcessDailyAdjustments(GameDate, LeagueName);
                     break;

                  case "3":   // Write Html to Disk
                     writeHtmlToDisk();
                     break;

                  case "4":   // Re-Load/Fix BoxScores by Day


                     List<DateTime> GameDates = new List<DateTime>()
                     {

                        Convert.ToDateTime("2019-04-05") //,
                        //Convert.ToDateTime("2020-01-31"),
                        //Convert.ToDateTime("2020-02-08"),
                        //Convert.ToDateTime("2020-02-12"),
                        //Convert.ToDateTime("2020-03-04")
                     };
                     foreach (DateTime fixDate in GameDates)
                     {
                        Console.WriteLine( DateTime.Now.ToString() + ": Fixing Date - " + fixDate.ToShortDateString());
                        new LoadBoxScores().FixBoxscores(LeagueName, fixDate);
                        
                     }
                     break;

                  default:
                     break;
               }

            }
            catch (Exception ex)
            {
               string msg = SysDAL.DALfunctions.StackTraceFormat(ex);
               Console.WriteLine(msg);
            }
            Console.WriteLine("Complete - " + DateTime.Now.ToString());
            Console.WriteLine("");
            Console.WriteLine((char) 7);
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
      static void test()
      {
         XXx prop = new XXx();
         iterateProps(prop);
      }
      static void iterateProps(object obj)
      {
        
         foreach (var prop in obj.GetType().GetProperties())
         {

            var typ = prop.GetType();
            if (prop.PropertyType.UnderlyingSystemType.Name == "String")
            {
               var myField = typ.GetProperties(); 
               prop.SetValue(obj, null);
            }
            else
            {
               iterateProps(prop);
            }
         }
      }
      public class XXx
      {
         public string XX1 { get; set; }
         public int Xint { get; set; }
         public bool XXBool { get; set; }
         public YYy yClass { get; set; }

         public XXx()
         {
            XX1 = "";
            Xint = 1;
            XXBool = true;
         }

      }
      public class YYy
      {
         public string YY1 { get; set; }
         public string YY2 { get; set; }
         public string YY3 { get; set; }
         public YYy()
         {
            YY1 = "";
            YY2 = "";
            YY3 = "";
         }
         public void YYy_m1()
         {
            YY2 = "";
         }

      }
   }  // class
}
/*
 * 
 * Run Todays matchups
 * copy Schedule from .accdb -> .mdb 
 * copy schedule .mdb -> SS
 */
