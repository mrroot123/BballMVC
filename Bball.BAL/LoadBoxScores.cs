using System;
using System.Collections.Generic;

using BballMVC.DTOs;
using BballMVC.IDTOs;

using Bball.VbClasses.Bball.VbClasses;
using Bball.DAL.Tables;
using Bball.DAL.Functions;
using Bball.DataBaseFunctions;
using Bball.DAL.Parsing;
using System.IO;
using TTI.Logger;

namespace Bball.BAL
{
   public class LoadBoxScores
   {
      const string cCRLF = "<br>";
      private string _message;
      public string Message {
         get { return _message; }
         set { _message += value + cCRLF; }
      }

      private ILeagueDTO _oLeagueDTO = new LeagueDTO();
      // private SeasonInfoDO _oSeasonInfoDO;
      private IBballInfoDTO _oBballInfoDTO;
      private readonly DateTime _DefaultDate;

      #region Constructors & Init
      // Constructor
      public LoadBoxScores() { }
      public LoadBoxScores(IBballInfoDTO oBballInfoDTO)
      {
         Helper.Log(oBballInfoDTO, $"LoadBoxScores(IBballInfoDTO oBballInfoDTO) - LeagueName: {oBballInfoDTO.LeagueName}  GameDate: {oBballInfoDTO.GameDate}");
         new LeagueInfoDO(oBballInfoDTO.LeagueName, _oLeagueDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate);  // Init _oLeagueDTO
         SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(oBballInfoDTO.GameDate, _oLeagueDTO.LeagueName, oBballInfoDTO.ConnectionString);

         _oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);
         _oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = oSeasonInfoDO.oSeasonInfoDTO;

         _DefaultDate = SeasonInfoDO.DefaultDate;
         loadBoxScoreRange(_oBballInfoDTO.LeagueName, _oBballInfoDTO.ConnectionString, SeasonInfoDO.DefaultDate); // 1
      }

      #endregion constructors
      // called by constructor
      private void loadBoxScoreRange(string LeagueName, string ConnectionString, DateTime DefaultDate, string BoxScoresL5MinURL = "")
      {
         Helper.Log(_oBballInfoDTO, $"LoadBoxScores.loadBoxScoreRange - LeagueName: {LeagueName}");

         DateTime GameDate = getNextGameDate(BoxScoreDO.GetMaxBoxScoresGameDate(ConnectionString, LeagueName, DefaultDate), ConnectionString);

         while (GameDate < DateTime.Today)   // Load ALL previous Boxscores - usually Yesterday's
         {
            int NumOfMatchups = 0;
            try
            {
               NumOfMatchups = loadBoxScoresAndRotationByGameDate(GameDate);  //1
            }
            catch (Exception ex)
            {
               throw new Exception(DALFunctions.StackTraceFormat(ex));
            }

            Console.WriteLine($"Processed {GameDate} - {DateTime.Now} - Matchups: {NumOfMatchups}");
            GameDate = getNextGameDate(GameDate, ConnectionString);
         }
      }


      #region reloadBoxScores
      public void ReloadBoxScores(IBballInfoDTO oBballInfoDTO)
      {
         new LeagueInfoDO(oBballInfoDTO);  // Init _oLeagueDTO
         // 03/06/2021 - Make Delete BxSc & L5Min one method that calls these two
         BoxScoreDO.DeleteBoxScoresByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
         BoxScoreDO.DeleteBoxScoresLast5MinByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);

         /*
          * Load: Rotation and Boxscores, BoxscoresL5Min up to Yesterday
          * */

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         new SeasonInfoDO(oBballInfoDTO);                                        // set oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO
         RotationDO.PopulateRotation(ocRotation, oBballInfoDTO, oBballInfoDTO.oBballDataDTO.oLeagueDTO, true);    // Get Rotation for GameDate - Populate if Not Found
         if (ocRotation.Count == 0)
            return;   // No Games for GameDate

         //kdtodo cleanup - Same foreach loop in ReloadBoxScores & loadBoxScoresAndRotationByGameDate
         CoversDTO oCoversDTO = null;
         try
         {
            foreach (var matchup in ocRotation)
            {

               oCoversDTO = matchup.Value;
               if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
                  continue;

               insertBoxScore(oCoversDTO, oBballInfoDTO);      // 1

            } // foreach MUP
         }
         catch (Exception ex)
         {
            string msg = $"BoxScore Load Error - "
               + $"{_oLeagueDTO.LeagueName}: {oBballInfoDTO.GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + cCRLF + oCoversDTO.Url;
            throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
         }
      }  // ReloadBoxScores
      #endregion reloadBoxScores

      // called by DataBO.appInit Only
      public void LoadTodaysRotation()
      {
         // Load Rotation ONLY
         //
         //int rotationDays2Load = 2;
         //for (int i = 0; i < rotationDays2Load; i++) // Loop twice - Load Today's & Tomorrow's Rotation
         // 02/12/2021 REWRITE
         DateTime GameDate = SqlFunctions.GetMaxGameDate(
            _oBballInfoDTO.ConnectionString, _oBballInfoDTO.LeagueName, "Rotation", _DefaultDate);
         GameDate = getNextGameDate(GameDate, _oBballInfoDTO.ConnectionString);
         SeasonInfoDO _oSeasonInfoDO = new SeasonInfoDO(_oBballInfoDTO.GameDate, _oBballInfoDTO.LeagueName, _oBballInfoDTO.ConnectionString);
         new DataDO().GetUserLeagueParmsDTO(_oBballInfoDTO);   // will Populate _oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO
         int LoadRotationDaysAhead = _oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO.LoadRotationDaysAhead;

         while (_oBballInfoDTO.GameDate <= DateTime.Today.AddDays(LoadRotationDaysAhead))  // Is GameDate > Tomorrow)
         {
            _oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = _oSeasonInfoDO.oSeasonInfoDTO;
            if (!_oSeasonInfoDO.oSeasonInfoDTO.Bypass)
            {
               SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
               try
               {
                  
                  RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO, true);   // always refresh Rotation b4 loading Boxscores
               }
               catch (Exception ex)
               {
                  throw new Exception($"Covers Rotation Error {_oBballInfoDTO.GameDate} - {ex.Message}");
               }
            }

           // 03/06/2021 _oBballInfoDTO.GameDate = _oBballInfoDTO.GameDate.AddDays(1); // kd make nextGameDate function
           // _oSeasonInfoDO.GameDate = _oSeasonInfoDO.GameDate.AddDays(1);
            _oSeasonInfoDO.GetNextGameDate();
            _oBballInfoDTO.GameDate = _oSeasonInfoDO.GameDate;
         }

         SqlFunctions.ParmTableParmValueUpdate(_oBballInfoDTO.ConnectionString, "BoxscoresLastUpdateDate", DateTime.Today.ToShortDateString());
      }


      // called by loadBoxScoreRange & FixBoxscores
      private int loadBoxScoresAndRotationByGameDate(DateTime GameDate)   // Return NumOfMatchups
      {
         /*
          * Load: Rotation and Boxscores, BoxscoresL5Min up to Yesterday
          * */

         IBballInfoDTO oBballInfoDTO = _oBballInfoDTO;  // kdcleanup - Pass as Parm, get rid of _oBballInfoDTO refs

         Helper.Log(oBballInfoDTO, $"LoadBoxScores.loadBoxScoresAndRotationByGameDate - LeagueName: {_oBballInfoDTO.LeagueName}  GameDate: {_oBballInfoDTO.GameDate}");

         
         _oBballInfoDTO.GameDate = GameDate;

         _oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = new SeasonInfoDTO();
         new SeasonInfoDO(_oBballInfoDTO);   // init _oBballInfoDTO.oBballDataDTO.SeasonInfoDTO
         _oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = _oBballInfoDTO.oSeasonInfoDTO;
         new LeagueInfoDO(_oBballInfoDTO.LeagueName, _oBballInfoDTO.oBballDataDTO.oLeagueDTO, _oBballInfoDTO.ConnectionString, _oBballInfoDTO.GameDate);  // Init _oLeagueDTO

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();  // Init Instance
         // Refresh Rotation from Covers and write
         RotationDO.PopulateRotation(ocRotation,  _oBballInfoDTO, _oBballInfoDTO.oBballDataDTO.oLeagueDTO, true);   
         
         if (ocRotation.Count == 0)
            return 0;   // No Games for GameDate

         BoxScoreDO.DeleteBoxScoresByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
         BoxScoreDO.DeleteBoxScoresLast5MinByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);

         //kdtodo cleanup - Same foreach loop in ReloadBoxScores & loadBoxScoresAndRotationByGameDate
         CoversDTO oCoversDTO = null;
         try
         {
            foreach (var matchup in ocRotation)
            {
               oCoversDTO = matchup.Value;
               if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
                  continue;
               insertBoxScore(oCoversDTO, _oBballInfoDTO);     // 2
            } // foreach MUP
         }
         catch (Exception ex)
         {
            string msg = $"BoxScore Load Error - "
               + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + cCRLF + oCoversDTO.Url;
            throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
         }

         return ocRotation.Count;  // return NumOfMatchups
      }  // loadBoxScoresAndRotationByGameDate


      // called by ReloadBoxScores & loadBoxScoresAndRotationByGameDate
      private void insertBoxScore(CoversDTO oCoversDTO, IBballInfoDTO oBballInfoDTO)   // ISeasonInfoDTO oSeasonInfoDTO)
      {
         #region insertBoxScore
         var GameDate = oCoversDTO.GameDate;
         var LoadDateTime = oBballInfoDTO.LoadDateTime;


         // 1) Get BoxScore from Covers
         CoversBoxscore oCoversBoxscore = new CoversBoxscore(GameDate, oBballInfoDTO.oBballDataDTO.oLeagueDTO, oCoversDTO);
         oCoversBoxscore.GetBoxscore();   // Get BoxScore html from Covers
         if (oCoversBoxscore.ReturnCode != 0)
         {
            string msg = $"oCoversBoxscore.ReturnCode: {oCoversBoxscore.ReturnCode} - "
               + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + cCRLF + oCoversDTO.Url;
            throw new Exception(msg);
         }

         string[] arVenue = new string[] { "Away", "Home" };
         for (int i = 0; i < 2; i++)
         {
            try
            {
               // Write Away & Home rows to BoxScores
               // kdpace
               BoxScoresDTO oBoxScoresDTO = new BoxScoresDTO()
               {
                  Venue = arVenue[i],
                  Season = oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO.Season,
                  SubSeason = oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO.SubSeason,
                  LoadDate = Convert.ToDateTime(LoadDateTime),
                  LoadTimeSeconds = oCoversBoxscore.LoadTimeSecound,
                  Source = "Covers"
               };
               oCoversBoxscore.PopulateBoxScoresDTO(oBoxScoresDTO);
               BoxScoreDO.PopulateGamePace(oBballInfoDTO.ConnectionString, oBoxScoresDTO);
               // kdpace populate pace
               // DTO --> Dal
               // Dal --> uspCalcPace
               // DALfunctions.InsertTableRow(oBballInfoDTO.ConnectionString, TableName, ocColumnNames, ocValues);
               Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(oBoxScoresDTO, oBballInfoDTO.ConnectionString);
            }
            catch (Exception ex)
            {
               string msg = $"LoadBoxScores.insertBoxScore Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + cCRLF + oCoversDTO.Url;
               throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
            }
         }
         if (!String.IsNullOrEmpty(oBballInfoDTO.oBballDataDTO.oLeagueDTO.BoxScoresL5MinURL.Trim()))
         {
            // Write Last 5 Minutes stats
            BoxScoresLast5Min oLast5Min = null;
            BoxScoresLast5MinDTO oLast5MinDTOHome = new BoxScoresLast5MinDTO()
            {
               LeagueName = oCoversDTO.LeagueName,
               GameDate = oCoversDTO.GameDate,
               RotNum = oCoversDTO.RotNum + 1,
               Team = oCoversDTO.TeamHome,
               Opp = oCoversDTO.TeamAway,
               Venue = "Home",
               LoadDate = Convert.ToDateTime(LoadDateTime)
            };
            try
            {
               //Bball.DAL.Tables.
               BoxScoreDO.InsertAwayHomeRowsBoxScoresLast5Min(oLast5MinDTOHome, oBballInfoDTO.ConnectionString, oLast5Min);
            }
            catch (FileNotFoundException ex)
            {
               string msg = $"BoxScoreL5Min Url Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + cCRLF + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
                  + cCRLF + ex + Message;
               Helper.LogMessage(oBballInfoDTO, ex, msg);
            }
            catch (Exception ex)
            {
               //if (oLast5Min.oWebPageGet)
               string msg = $"BoxScoreL5Min Load Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + cCRLF + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
                  + cCRLF + ex + Message;
               Helper.LogMessage(oBballInfoDTO, ex, msg);
            }
         }  // Insert 
         #endregion insertBoxscore
      }

      private DateTime getNextGameDate(DateTime GameDate, string ConnectionString)
      {
         return new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName, ConnectionString).GetNextGameDate();
      }
      public void FixBoxscores(string LeagueName, DateTime GameDate, string _ConnectionString)
      {
         SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(GameDate, LeagueName, _ConnectionString);
         new LeagueInfoDO(LeagueName, _oLeagueDTO, _ConnectionString, GameDate);  // Init _oLeagueDTO
         //_strLoadDateTime = DateTime.Now.ToLongDateString();
         oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName, _ConnectionString);
         if (oSeasonInfoDO.oSeasonInfoDTO.Bypass)
         {
            Console.WriteLine($"No Games Scheduled for {GameDate}");
            return;
         }
         //
         string strSql = $"Delete From {{0}} Where LeagueName = '{LeagueName}' and  GameDate = '{GameDate.ToShortDateString()}'";
         SqlFunctions.ExecSql(string.Format(strSql, "Rotation"), _ConnectionString);
         SqlFunctions.ExecSql(string.Format(strSql, "BoxScores"), _ConnectionString);
         SqlFunctions.ExecSql(string.Format(strSql, "BoxScoresLast5Min"), _ConnectionString);

         loadBoxScoresAndRotationByGameDate(GameDate);
      }

   }  // LoadBoxScores
   public class InsertBoxScore
   {
      // constructor
      public void Insert(IBballInfoDTO oBballInfoDTO, string url)
      {
      }
   }  // InsertBoxScore
}  // namespace

