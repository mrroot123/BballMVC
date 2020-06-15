using System;
using System.Collections.Generic;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.VbClasses.Bball.VbClasses;

using Bball.DAL;
using Bball.DAL.Tables;
using Bball.DAL.Functions;
using Bball.DataBaseFunctions;
using System.Text;

namespace Bball.BAL
{
   public class LoadBoxScores
   {

      private ILeagueDTO _oLeagueDTO = new LeagueDTO();
      private string _strLoadDateTime;
      private string _ConnectionString = SqlFunctions.GetConnectionString();
      //private DateTime _GameDate;
      private SeasonInfoDO _oSeasonInfoDO;
      private IBballInfoDTO _oBballInfoDTO;
      private string _UserName = "Test";  // kdtodo populate


      // public  DateTime DefaultDate = Convert.ToDateTime("1/1/2000");  // kdtodo move to constants

      // Constructor
      public LoadBoxScores(string LeagueName) => init(LeagueName,  Convert.ToDateTime("10/16/2018"));
      

      public LoadBoxScores(string LeagueName,  DateTime StartGameDate) =>  init(LeagueName, StartGameDate);

      public LoadBoxScores()
      { }


      private void init(string LeagueName, DateTime StartGameDate)
      {
         new LeagueInfoDO(LeagueName, _oLeagueDTO, _ConnectionString);  // Init _oLeagueDTO
         _strLoadDateTime = DateTime.Now.ToLongDateString();
         DateTime GameDate = BoxScoreDO.GetMaxBoxScoresGameDate(_ConnectionString, LeagueName, SeasonInfoDO.DefaultDate);
         if (GameDate == SeasonInfoDO.DefaultDate)
            GameDate = StartGameDate;
         else
            GameDate = GameDate.AddDays(1);

         _oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName);
         if (_oSeasonInfoDO.oSeasonInfoDTO.Bypass)
            _oSeasonInfoDO.GetNextGameDate();
         //
         RotationDO.DeleteRestOfRotation(GameDate, LeagueName);
         _oBballInfoDTO = new BballInfoDTO()
         {
            ConnectionString = _ConnectionString,
            GameDate = _oSeasonInfoDO.GameDate,
            LeagueName = LeagueName,
            UserName = _UserName,
            oSeasonInfoDTO = _oSeasonInfoDO.oSeasonInfoDTO
         };
      }

      public void  FixBoxscores(string LeagueName, DateTime GameDate)
      {
         new LeagueInfoDO(LeagueName, _oLeagueDTO, _ConnectionString);  // Init _oLeagueDTO
         _strLoadDateTime = DateTime.Now.ToLongDateString();
         _oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName);
         if (_oSeasonInfoDO.oSeasonInfoDTO.Bypass)
         {
            Console.WriteLine($"No Games Scheduled for {GameDate}");
            return;
         }
         //
         string strSql = $"Delete From {{0}} Where LeagueName = '{LeagueName}' and  GameDate = '{GameDate.ToShortDateString()}'";
         SqlFunctions.ExecSql(string.Format(strSql, "Rotation"), _ConnectionString);
         SqlFunctions.ExecSql(string.Format(strSql, "BoxScores"), _ConnectionString);
         SqlFunctions.ExecSql(string.Format(strSql, "BoxScoresLast5Min"), _ConnectionString);

         LoadBoxScore(GameDate);
      }

      public void LoadTodaysRotation()
      {
         if (!_oSeasonInfoDO.RotationLoadedToDate())
         { 
            LoadBoxScoreRange();

            // Load Rotations
            //
            int rotationDays2Load = 2;
            for (int i = 0; i < rotationDays2Load; i++) // Loop twice - Load Today's & Tomorrow's Rotation
            {
               string _strLoadDateTime = _oSeasonInfoDO.GameDate.ToString();

               SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
               RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO);
               
               // kd 06/14/2020 Eliminate Adjustments from prev Adj table
               //AdjustmentsDO oAdjustments = new AdjustmentsDO(_oSeasonInfoDO.GameDate, _oLeagueDTO.LeagueName, _ConnectionString);
               //oAdjustments.ProcessDailyAdjustments(_oSeasonInfoDO.GameDate, _oLeagueDTO.LeagueName);
               //_oSeasonInfoDO.GameDate = _oSeasonInfoDO.GameDate.AddDays(1);
            }
         }
         SqlFunctions.ParmTableParmValueUpdate("BoxscoresLastUpdateDate", DateTime.Today.ToShortDateString());
      }

      public void LoadBoxScoreRange()
      {
         // DateTime processDate = GameDate;
         while (_oSeasonInfoDO.GameDate < DateTime.Today)
         {
            int NumOfMatchups = 0;
            try
            {
               NumOfMatchups = LoadBoxScore(_oSeasonInfoDO.GameDate);
            }
            catch (Exception ex)
            {
               throw new Exception(DALFunctions.StackTraceFormat(ex));
            }

            Console.WriteLine($"Processed {_oSeasonInfoDO.GameDate} - {DateTime.Now} - Matchups: {NumOfMatchups}");
            _oSeasonInfoDO.GetNextGameDate();
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

         RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO);
         if (ocRotation.Count == 0)
            return 0;   // No Games for GameDate

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
                  oCoversBoxscore.PopulateBoxScoresDTO(BoxScoresDTO, arVenue[i], _oSeasonInfoDO.oSeasonInfoDTO.Season, _oSeasonInfoDO.oSeasonInfoDTO.SubSeason, LoadDateTime
                                                   , oCoversBoxscore.LoadTimeSecound, "Covers");
                  Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(BoxScoresDTO);
               }
               catch (Exception ex)
               {
                  string msg = $"BoxScore Load Error - "
                     + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                     + "\n" + oCoversDTO.Url;
                  throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
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
               throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
            }
         } // foreach MUP

         // kd 06/20/2020 Eliminate Adjs from prev Adj Table
         //AdjustmentsDO oAdjustments = new AdjustmentsDO(GameDate, _oLeagueDTO.LeagueName, _ConnectionString);
         //oAdjustments.ProcessDailyAdjustments(GameDate, _oLeagueDTO.LeagueName);

         return ocRotation.Count;  // return NumOfMatchups

      }  // LoadBoxScore

      //void populateRotation(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, string ConnectionString, string strLoadDateTime)
      //{
      //   Rotation oRotation = new Rotation(ocRotation, GameDate, _oLeagueDTO, ConnectionString, strLoadDateTime);
      //   oRotation.GetRotation();
      //}
   }
}
