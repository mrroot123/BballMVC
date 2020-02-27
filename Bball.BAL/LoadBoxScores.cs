using System;
using System.Collections.Generic;

using BballMVC.DTOs;
using Bball.VbClasses.Bball.VbClasses;

using Bball.DAL;
using Bball.DAL.Tables;
using Bball.DataBaseFunctions;
using System.Text;

namespace Bball.BAL
{
   public class LoadBoxScores
   {

      private LeagueDTO _oLeagueDTO = new LeagueDTO();
      private string _strLoadDateTime;
      private string _ConnectionString = SqlFunctions.GetConnectionString();
      //private DateTime _GameDate;
      private SeasonInfoDO _oSeasonInfo; 

      public  DateTime DefaultDate = Convert.ToDateTime("1/1/2000");  // kdtodo move to constants
      // Constructor
      public LoadBoxScores(string LeagueName, string strLoadDateTime, DateTime StartGameDate)
      {
         new LeagueInfoDO(LeagueName, _oLeagueDTO, _ConnectionString);  // Init _oLeagueDTO
         _strLoadDateTime = strLoadDateTime;
         DateTime GameDate = BoxScoreDO.GetMaxBoxScoresGameDate(_ConnectionString, LeagueName, DefaultDate);
         if (GameDate == DefaultDate)
            GameDate = StartGameDate;
         else
            GameDate = GameDate.AddDays(1);

         _oSeasonInfo  = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName);
         if (_oSeasonInfo.oSeasonInfoDTO.Bypass)
            _oSeasonInfo.GetNextGameDate();
         //
         RotationDO.DeleteRestOfRotation(GameDate, LeagueName);
      }

      public void LoadTodaysRotation()
      {
         LoadBoxScoreRange();

         for (int i = 0; i < 2; i++) // Loop twice - Load Today's & Tomorrow's Rotation
         { 
            string _strLoadDateTime = _oSeasonInfo.GameDate.ToString();

            SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
             RotationDO.PopulateRotation(ocRotation, _oSeasonInfo.GameDate, _oLeagueDTO,  _ConnectionString, _strLoadDateTime);

            AdjustmentsDO oAdjustments = new AdjustmentsDO(_oSeasonInfo.GameDate, _oLeagueDTO.LeagueName, _ConnectionString);
            oAdjustments.ProcessDailyAdjustments(_oSeasonInfo.GameDate, _oLeagueDTO.LeagueName);
            _oSeasonInfo.GameDate = _oSeasonInfo.GameDate.AddDays(1);
         }
         SqlFunctions.ParmTableParmValueUpdate("BoxscoresLastUpdateDate", DateTime.Today.ToShortDateString());
      }

      public void LoadBoxScoreRange()
      {
         // DateTime processDate = GameDate;
         while (_oSeasonInfo.GameDate < DateTime.Today)
         {
            int NumOfMatchups = 0;
            try
            {
               NumOfMatchups = LoadBoxScore(_oSeasonInfo.GameDate);
            }
            catch (Exception ex)
            {
               throw new Exception(SysDAL.DALfunctions.StackTraceFormat(ex));
            }

            Console.WriteLine($"Processed {_oSeasonInfo.GameDate} - {DateTime.Now} - Matchups: {NumOfMatchups}");
            _oSeasonInfo.GetNextGameDate();
         }
      }

      public int LoadBoxScore(DateTime GameDate)   // Return NumOfMatchups
      {
         /*
          * 
          * */
         DateTime LoadDateTime = DateTime.Now;
         string _strLoadDateTime = LoadDateTime.ToString();

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();

         RotationDO.PopulateRotation(ocRotation, _oSeasonInfo.GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime);
         if (ocRotation.Count == 0) return 0;   // No Games for GameDate

         foreach (var matchup in ocRotation)
         {
            CoversDTO oCoversDTO = matchup.Value;
            // 1) Get BoxScore from Covers
            CoversBoxscore oCoversBoxscore = new CoversBoxscore(GameDate, _oLeagueDTO, oCoversDTO);
            oCoversBoxscore.GetBoxscore();   // Get BoxScore from Covers
            if (oCoversBoxscore.ReturnCode != 0)
            {
               // kdtodo log error
               continue;
            }
            string[] arVenue = new string[] { "Away", "Home" };
            for (int i = 0; i < 2; i++)
            {
               try
               {
                  // Write Away & Home rows to BoxScores
                  BoxScoresDTO BoxScoresDTO = new BoxScoresDTO();
                  oCoversBoxscore.PopulateBoxScoresDTO(BoxScoresDTO, arVenue[i], _oSeasonInfo.oSeasonInfoDTO.Season, _oSeasonInfo.oSeasonInfoDTO.SubSeason, LoadDateTime
                                                   , oCoversBoxscore.LoadTimeSecound, "Covers");
                  Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(BoxScoresDTO);
               }
               catch (Exception ex)
               {
                  string msg = $"BoxScore Load Error - "
                     + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                     + "\n" + oCoversDTO.Url;
                  throw new Exception(SysDAL.DALfunctions.StackTraceFormat(msg, ex, ""));
               }
            }

            // Write Last 5 Minutes stats
            BoxScoresLast5MinDTO oLast5MinDTOHome = new BoxScoresLast5MinDTO()
            {
               LeagueName = oCoversDTO.LeagueName
               , GameDate = oCoversDTO.GameDate
               , RotNum = oCoversDTO.RotNum + 1
               , Team = oCoversDTO.TeamHome
               , Opp = oCoversDTO.TeamAway
               , Venue = "Home"
               , LoadDate = LoadDateTime
            };
            try
            { 
               //Bball.DAL.Tables.
               BoxScoreDO.InsertAwayHomeRowsBoxScoresLast5Min(oLast5MinDTOHome);
            }
            catch (Exception ex)
            {
               string msg = $"BoxScoreL5Min Load Error - "
                  + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome);
               throw new Exception(SysDAL.DALfunctions.StackTraceFormat(msg, ex, ""));
            }
         } // foreach

         AdjustmentsDO oAdjustments = new AdjustmentsDO(GameDate, _oLeagueDTO.LeagueName, _ConnectionString);
         oAdjustments.ProcessDailyAdjustments(GameDate, _oLeagueDTO.LeagueName);

         return ocRotation.Count;  // return NumOfMatchups

      }  // LoadBoxScore

      //void populateRotation(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, string ConnectionString, string strLoadDateTime)
      //{
      //   Rotation oRotation = new Rotation(ocRotation, GameDate, _oLeagueDTO, ConnectionString, strLoadDateTime);
      //   oRotation.GetRotation();
      //}
   }
}
