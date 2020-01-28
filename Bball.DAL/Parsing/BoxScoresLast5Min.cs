using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HtmlParsing.HtmlParsing.Functions;
using HtmlParserNameSpace;
using HtmlParsing.Common4vb.HtmlParsing;
using BballMVC.DTOs;
using Bball.DAL.Parsing;
using Bball.DataBaseFunctions;

namespace Bball.DAL.Parsing
{
   public class BoxScoresLast5Min
   {
      /*
      f Start of 4th quarter
      tr layout
      1) Time- MM:SS.s
      2) Away Desc
      3) Away Pts made - +2
      4) Score -  22-25
      5) Home Pts Made
      6) Home Desc
      Get next TR savTime until Time< 5:00
      Get next TR savTime until Time < 1:00
      Get next TR savTime until Time = 0:00.0

            https://www.basketball-reference.com/boxscores/pbp/201911270BOS.html
                                                               /{YYYYMMDD}0{HomeTeam}.html
   
          d:\my documents\wwwroot\testhtmlparser\htmlparser\htmlparser.cs 
          */
      private string _html;
      trTDs otrTDs = new trTDs();
      trTDs oPrevtrTDs = new trTDs();
      BoxScoresLast5MinDTO _oLast5Min;

      public BoxScoresLast5Min(string url)
      {
         WebPageGet oWebPageGet = new WebPageGet();
         oWebPageGet.NewWebPageGet(url);
         if (oWebPageGet.ReturnCode != 0)
         {
            throw new Exception("BoxScoresLast5Min WebPageGet Error: \n" + oWebPageGet.ToString());
         }
         _html = oWebPageGet.Html;
      }

      public static string BuildBoxScoresLast5MinUrl(BoxScoresLast5MinDTO oLast5MinDTO)
      {
         oLast5MinDTO.Source = "BasketballReference";
         string BbrferTeam = SqlFunctions.TeamLookupTeamNameByTeamNameInDatabase(oLast5MinDTO.GameDate, oLast5MinDTO.LeagueName, oLast5MinDTO.Source, oLast5MinDTO.Team).Trim();
         return $"https://www.basketball-reference.com/boxscores/pbp/{oLast5MinDTO.GameDate.ToString("yyyyMMdd")}0{BbrferTeam}.html";
      }

      public void ParseBoxScoresLast5Min(BoxScoresLast5MinDTO oLast5Min)
      {
         _oLast5Min = oLast5Min;
         HtmlParser oPage = new HtmlParser(_html);
         oPage.FindTagByString("Start of 4th quarter");
         if (oPage.ReturnCode != 0)
            throw new Exception("ParseBoxScoresLast5Min - Start of 4th quarter Not Found");

         oPage.FindTagByTagname("tr");
         if (oPage.ReturnCode != 0)
            throw new Exception("ParseBoxScoresLast5Min - Initial TR Not Found");
         parseTR(oPage.HtmlInner);

         while (otrTDs.TimeInSeconds > 300)   // Get next TR savTime until Time< 5:00 / 300 seconds
         {
            oLast5Min.Q4Last5MinScore = otrTDs.AwayScore + otrTDs.HomeScore;
            oPage.FindTagByTagname("tr");
            if (oPage.ReturnCode != 0)
               throw new Exception("ParseBoxScoresLast5Min - Get next TR savTime until Time< 5 mins Not Found");
            parseTR(oPage.HtmlInner);
         }  // while

         while (otrTDs.TimeInSeconds > 60)   // Get next TR savTime until Time< 1 min / 60 seconds
         {
            oLast5Min.Q4Last1MinScore = otrTDs.AwayScore + otrTDs.HomeScore;
            oLast5Min.Q4Last1MinWinningTeam = otrTDs.AwayScore > otrTDs.HomeScore ? oLast5Min.Opp : oLast5Min.Team;
            oLast5Min.Q4Last1MinScoreUs = (double)otrTDs.HomeScore;
            oLast5Min.Q4Last1MinScoreOp = (double)otrTDs.AwayScore;

            oPage.FindTagByTagname("tr");
            if (oPage.ReturnCode != 0)
               throw new Exception("ParseBoxScoresLast5Min - Get next TR savTime until Time< 1 min Not Found");
            parseTR(oPage.HtmlInner);
         }  // while


         while (otrTDs.TimeInSeconds > 0)   // Get next TR savTime until Time = 0  seconds
         {
            oLast5Min.Q4Score = otrTDs.AwayScore + otrTDs.HomeScore;
            if (otrTDs.AwayPoints > 0)
            {
               switch (otrTDs.AwayPoints)
               {
                  case 1:
                     oLast5Min.Q4Last1MinOpPt1++;
                     break;
                  case 2:
                     oLast5Min.Q4Last1MinOpPt2++;
                     break;
                  case 3:
                     oLast5Min.Q4Last1MinOpPt3++;
                     break;
               }
            }
            if (otrTDs.HomePoints > 0)
            {
               switch (otrTDs.HomePoints)
               {
                  case 1:
                     oLast5Min.Q4Last1MinUsPt1++;
                     break;
                  case 2:
                     oLast5Min.Q4Last1MinUsPt2++;
                     break;
                  case 3:
                     oLast5Min.Q4Last1MinUsPt3++;
                     break;
               }
            }
            oPage.FindTagByTagname("tr");
            if (oPage.ReturnCode != 0)
               throw new Exception("ParseBoxScoresLast5Min - Get next TR savTime until Time< 5:00 Not Found");
            parseTR(oPage.HtmlInner);
         }  // while Time > 0
 
      }  // ParseBoxScoresLast5Min

      private void parseTR(string trHtml)
      {
         int savTimeInSecounds = otrTDs.TimeInSeconds;

         try
         {
            HtmlParser otrHtml = new HtmlParser(trHtml);
            otrTDs.Init(ref oPrevtrTDs);

            otrHtml.FindTagByTagname("td");  // 1) Time
            string[] ar = otrHtml.HtmlInner.Split(':');
            otrTDs.TimeInSeconds = Convert.ToInt32(ar[0]) * 60 + Convert.ToInt32(ar[1].Substring(0, 2));
            if (otrTDs.TimeInSeconds == 0)
               return;
            oPrevtrTDs.TimeInSeconds = otrTDs.TimeInSeconds;
            otrHtml.FindTagByTagname("td");  // 2) Ignore Away Desc

            otrHtml.FindTagByTagname("td");  // 3) Away Pts made - +2
            if (otrHtml.ReturnCode == 1)
            {
               otrTDs.RestoreFromPrevtrTD(oPrevtrTDs);
               return;
            }
            if (otrHtml.HtmlInner.IndexOf("nbsp") == -1)
               try { otrTDs.AwayPoints = Convert.ToInt32(otrHtml.HtmlInner); }
               catch
               { throw new Exception($"Away Points Invalid: {_oLast5Min.GameDate}  {_oLast5Min.LeagueName}  {_oLast5Min.Opp}-{_oLast5Min.Team} TimeLeft:  {otrTDs.TimeInSeconds} \n  {otrHtml.HtmlInner}"); }

            otrHtml.FindTagByTagname("td");  // 4) Score -  22-25
            ar = otrHtml.HtmlInner.Split('-');
            otrTDs.AwayScore = Convert.ToInt32(ar[0]);
            otrTDs.HomeScore = Convert.ToInt32(ar[1]);

            otrHtml.FindTagByTagname("td");  // 5) Home Pts Made
            if (otrHtml.HtmlInner.IndexOf("nbsp") == -1)
            {
               try { otrTDs.HomePoints = Convert.ToInt32(otrHtml.HtmlInner); }
               catch
               {
                  throw new Exception($"Home Points Invalid: {_oLast5Min.GameDate}  {_oLast5Min.LeagueName}  {_oLast5Min.Opp}-{_oLast5Min.Team} TimeLeft:  {otrTDs.TimeInSeconds} \n  {otrHtml.HtmlInner}");
               }
            }
         }
         catch (Exception ex)
         {
            throw new Exception($@"Bball.DAL\Parsing\BoxScoresLastSMin.parseTR Error: TR = {trHtml}");
         }
         if (savTimeInSecounds > 0)
         {
            if (savTimeInSecounds >= otrTDs.TimeInSeconds)
            {
               if ((savTimeInSecounds - otrTDs.TimeInSeconds) > 200)
                  otrTDs.TimeInSeconds = savTimeInSecounds;
            }
         }

      }  // parseTR
   }  // class
   /*
      1) Time- MM:SS.s
      2) Away Desc
      3) Away Pts made - +2
      4) Score -  22-25
      5) Home Pts Made
      6) Home Desc
   */
   struct trTDs
   {
      public int TimeInSeconds;
      public int AwayPoints;
      public int HomePoints;
      public int AwayScore;
      public int HomeScore;
      public void Init(ref trTDs oPrevtrTDs)
      {

         oPrevtrTDs.TimeInSeconds = TimeInSeconds;
         oPrevtrTDs.AwayPoints = AwayPoints;
         oPrevtrTDs.HomePoints = HomePoints;
         oPrevtrTDs.AwayScore = AwayScore;
         oPrevtrTDs.HomeScore = HomeScore;

         TimeInSeconds = 0;
         AwayPoints = 0;
         HomePoints = 0;
         AwayScore = 0;
         HomeScore = 0;
      }
      public void RestoreFromPrevtrTD(trTDs oPrevtrTDs)
      {

         TimeInSeconds = oPrevtrTDs.TimeInSeconds;
         AwayPoints = 0;   // Zeros - dont want to count Points Twice
         HomePoints = 0;
         AwayScore = oPrevtrTDs.AwayScore;
         HomeScore = oPrevtrTDs.HomeScore;
      }
   }

}  // NameSpace
