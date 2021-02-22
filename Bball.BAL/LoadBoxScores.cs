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
      private string _message;
      public string Message {
         get { return _message; }
         set { _message += value + "\n"; }
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
         LoadBoxScoreRange(_oBballInfoDTO.LeagueName, _oBballInfoDTO.ConnectionString, SeasonInfoDO.DefaultDate);
      }
      // kdcleanup
      //public LoadBoxScores(string UserName, string LeagueName, DateTime GameDate, string ConnectionString)
      //{
      //   new LeagueInfoDO(LeagueName, _oLeagueDTO, ConnectionString, GameDate);  // Init _oLeagueDTO
      //   SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(GameDate, LeagueName, ConnectionString);

      //  // oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName);
      //   _oBballInfoDTO = new BballInfoDTO()
      //   {
      //      ConnectionString = ConnectionString,
      //      GameDate = oSeasonInfoDO.GameDate,
      //      LeagueName = LeagueName,
      //      UserName = UserName,
      //      oSeasonInfoDTO = oSeasonInfoDO.oSeasonInfoDTO
      //   };
      //   _DefaultDate = SeasonInfoDO.DefaultDate;
      //   LoadBoxScoreRange(LeagueName, ConnectionString, SeasonInfoDO.DefaultDate, _oLeagueDTO.BoxScoresL5MinURL);
      //}
      #endregion constructors

      public void ReloadBoxScores(IBballInfoDTO oBballInfoDTO)
      {
         new LeagueInfoDO(oBballInfoDTO);  // Init _oLeagueDTO

         BoxScoreDO.DeleteBoxScoresByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
         BoxScoreDO.DeleteBoxScoresLast5MinByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
         loadBoxScores(oBballInfoDTO);
      }
      private int loadBoxScores(IBballInfoDTO oBballInfoDTO)   // Return NumOfMatchups
      {
         /*
          * Load: Rotation and Boxscores, BoxscoresL5Min up to Yesterday
          * */

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         new SeasonInfoDO(oBballInfoDTO);                                        // set oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO
         RotationDO.PopulateRotation(ocRotation, oBballInfoDTO, oBballInfoDTO.oBballDataDTO.oLeagueDTO);    // Get Rotation for GameDate - Populate if Not Found
         if (ocRotation.Count == 0)
            return 0;   // No Games for GameDate

         CoversDTO oCoversDTO = null;
         try
         {
            foreach (var matchup in ocRotation)
            {

               oCoversDTO = matchup.Value;
               if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
                  continue;

               insertBoxScore(oCoversDTO, oBballInfoDTO);      // .oBballDataDTO.oSeasonInfoDTO);

            } // foreach MUP
         }
         catch (Exception ex)
         {
            string msg = $"BoxScore Load Error - "
               + $"{_oLeagueDTO.LeagueName}: {oBballInfoDTO.GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + "\n" + oCoversDTO.Url;
            throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));

         }

         return ocRotation.Count;  // return NumOfMatchups


      }  // LoadYesterdaysBoxScores

      public void LoadTodaysRotation()
      {
         // Load Rotations
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
            // string _strLoadDateTime = _oBballInfoDTO.LoadDateTime();    // _oSeasonInfoDO.GameDate.ToString();
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

            _oBballInfoDTO.GameDate = _oBballInfoDTO.GameDate.AddDays(1); // kd make nextGameDate function
            _oSeasonInfoDO.GameDate = _oSeasonInfoDO.GameDate.AddDays(1);
         }

         SqlFunctions.ParmTableParmValueUpdate(_oBballInfoDTO.ConnectionString, "BoxscoresLastUpdateDate", DateTime.Today.ToShortDateString());
      }

      private void LoadBoxScoreRange(string LeagueName, string ConnectionString, DateTime DefaultDate, string BoxScoresL5MinURL = "")
      {
         Helper.Log(_oBballInfoDTO, $"LoadBoxScores.LoadBoxScoreRange - LeagueName: {LeagueName}" );

         DateTime GameDate = getNextGameDate(BoxScoreDO.GetMaxBoxScoresGameDate(ConnectionString, LeagueName, DefaultDate), ConnectionString);

         while (GameDate < DateTime.Today)   // Load ALL previous Boxscores - usually Yesterday's
         {
            int NumOfMatchups = 0;
            try
            {
               NumOfMatchups = LoadYesterdaysBoxScores(GameDate);
            }
            catch (Exception ex)
            {
               throw new Exception(DALFunctions.StackTraceFormat(ex));
            }

            Console.WriteLine($"Processed {GameDate} - {DateTime.Now} - Matchups: {NumOfMatchups}");
            GameDate = getNextGameDate(GameDate, ConnectionString);
         }
      }


      private int LoadYesterdaysBoxScores(DateTime GameDate)   // Return NumOfMatchups
      {
         /*
          * Load: Rotation and Boxscores, BoxscoresL5Min up to Yesterday
          * */
         Helper.Log(_oBballInfoDTO, $"LoadBoxScores.LoadYesterdaysBoxScores - LeagueName: {_oBballInfoDTO.LeagueName}  GameDate: {_oBballInfoDTO.GameDate}");
         DateTime LoadDateTime = DateTime.Now;

         string _strLoadDateTime = LoadDateTime.ToString();

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         _oBballInfoDTO.GameDate = GameDate;

         _oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = new SeasonInfoDTO();
         new SeasonInfoDO(_oBballInfoDTO);   // init _oBballInfoDTO.oBballDataDTO,SeasonInfoDTO
         new LeagueInfoDO(_oBballInfoDTO.LeagueName, _oBballInfoDTO.oBballDataDTO.oLeagueDTO, _oBballInfoDTO.ConnectionString, _oBballInfoDTO.GameDate);  // Init _oLeagueDTO

         RotationDO.PopulateRotation(ocRotation,  _oBballInfoDTO, _oBballInfoDTO.oBballDataDTO.oLeagueDTO);   // Get Rotation for GameDate - Populate if Not Found
         if (ocRotation.Count == 0)
            return 0;   // No Games for GameDate

         CoversDTO oCoversDTO = null;
         try
         {
            foreach (var matchup in ocRotation)
            {

               oCoversDTO = matchup.Value;
               if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
                  continue;

               insertBoxScore(oCoversDTO, _oBballInfoDTO);     //.oBballDataDTO.oSeasonInfoDTO);

            } // foreach MUP
         }
         catch (Exception ex)
         {
            string msg = $"BoxScore Load Error - "
               + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + "\n" + oCoversDTO.Url;
            throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));

         }

         return ocRotation.Count;  // return NumOfMatchups


      }  // LoadYesterdaysBoxScores

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
               + "\n" + oCoversDTO.Url;
            throw new Exception(msg);
         }

         string[] arVenue = new string[] { "Away", "Home" };
         for (int i = 0; i < 2; i++)
         {
            try
            {
               // Write Away & Home rows to BoxScores
               BoxScoresDTO BoxScoresDTO = new BoxScoresDTO()
               {
                  Venue = arVenue[i],
                  Season = oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO.Season,
                  SubSeason = oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO.SubSeason,
                  LoadDate = Convert.ToDateTime(LoadDateTime),
                  LoadTimeSeconds = oCoversBoxscore.LoadTimeSecound,
                  Source = "Covers"
               };
               oCoversBoxscore.PopulateBoxScoresDTO(BoxScoresDTO);
               Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(BoxScoresDTO, oBballInfoDTO.ConnectionString);
            }
            catch (Exception ex)
            {
               string msg = $"LoadBoxScores.insertBoxScore Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + "\n" + oCoversDTO.Url;
               throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
            }
         }
         if (!String.IsNullOrEmpty(oBballInfoDTO.oBballDataDTO.oLeagueDTO.BoxScoresL5MinURL))
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
                  + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
                  + "\n" + ex + Message;
               Helper.LogMessage(oBballInfoDTO, ex, msg);
            }
            catch (Exception ex)
            {
               //if (oLast5Min.oWebPageGet)
               string msg = $"BoxScoreL5Min Load Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
                  + "\n" + ex + Message;
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

         LoadYesterdaysBoxScores(GameDate);
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
   // kdcleanup
   //private int xLoadYesterdaysBoxScores(DateTime GameDate)   // Return NumOfMatchups
   //{
   //   /*
   //    * Load: Rotation and Boxscores, BoxscoresL5Min up to Yesterday
   //    * */
   //   DateTime LoadDateTime = DateTime.Now;

//   string _strLoadDateTime = LoadDateTime.ToString();

//   SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
//   _oBballInfoDTO.GameDate = GameDate;
//   SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName, _oBballInfoDTO.ConnectionString);
//   RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO);   // Get Rotation for GameDate - Populate if Not Found
//   if (ocRotation.Count == 0)
//      return 0;   // No Games for GameDate

//   CoversDTO oCoversDTO = null;
//   try
//   {
//      foreach (var matchup in ocRotation)
//      {

//         oCoversDTO = matchup.Value;
//         if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
//            continue;
//         #region insertBoxScore
//         // 1) Get BoxScore from Covers
//         CoversBoxscore oCoversBoxscore = new CoversBoxscore(GameDate, _oLeagueDTO, oCoversDTO);
//         oCoversBoxscore.GetBoxscore();   // Get BoxScore html from Covers
//         if (oCoversBoxscore.ReturnCode != 0)
//         {
//            // kdtodo log error
//            string msg = $"oCoversBoxscore.ReturnCode: {oCoversBoxscore.ReturnCode} - "
//               + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
//               + "\n" + oCoversDTO.Url;
//            throw new Exception(msg);
//         }
//         string[] arVenue = new string[] { "Away", "Home" };
//         for (int i = 0; i < 2; i++)
//         {
//            try
//            {
//               // Write Away & Home rows to BoxScores
//               BoxScoresDTO oBoxScoresDTO = new BoxScoresDTO();
//               oCoversBoxscore.PopulateBoxScoresDTO(oBoxScoresDTO, arVenue[i]
//                              , oSeasonInfoDO.oSeasonInfoDTO.Season, oSeasonInfoDO.oSeasonInfoDTO.SubSeason, LoadDateTime
//                              , oCoversBoxscore.LoadTimeSecound, "Covers");
//               Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(oBoxScoresDTO, _oBballInfoDTO.ConnectionString);
//            }
//            catch (Exception ex)
//            {
//               string msg = $"BoxScore Load Error - "
//                  + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
//                  + "\n" + oCoversDTO.Url;
//               throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
//            }
//         }
//         if (!String.IsNullOrEmpty(_oLeagueDTO.BoxScoresL5MinURL))
//         {
//            // Write Last 5 Minutes stats
//            BoxScoresLast5Min oLast5Min = null;
//            BoxScoresLast5MinDTO oLast5MinDTOHome = new BoxScoresLast5MinDTO()
//            {
//               LeagueName = oCoversDTO.LeagueName,
//               GameDate = oCoversDTO.GameDate,
//               RotNum = oCoversDTO.RotNum + 1,
//               Team = oCoversDTO.TeamHome,
//               Opp = oCoversDTO.TeamAway,
//               Venue = "Home",
//               LoadDate = LoadDateTime
//            };
//            try
//            {
//               //Bball.DAL.Tables.
//               BoxScoreDO.InsertAwayHomeRowsBoxScoresLast5Min(oLast5MinDTOHome, _oBballInfoDTO.ConnectionString, oLast5Min);
//            }
//            catch (FileNotFoundException ex)
//            {
//               string msg = $"BoxScoreL5Min Url Error - "
//                  + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
//                  + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
//                  + "\n" + ex + Message;
//               Helper.LogMessage(_oBballInfoDTO, ex, msg);
//            }
//            catch (Exception ex)
//            {
//               //if (oLast5Min.oWebPageGet)
//               string msg = $"BoxScoreL5Min Load Error - "
//                  + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
//                  + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome)
//                  + "\n" + ex + Message;
//               Helper.LogMessage(_oBballInfoDTO, ex, msg);
//            }
//         }  // Insert 
//         #endregion insertBoxscore
//      } // foreach MUP
//   }
//   catch (Exception ex)
//   {
//      string msg = $"BoxScore Load Error - "
//         + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
//         + "\n" + oCoversDTO.Url;
//      throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));

//   }

//   return ocRotation.Count;  // return NumOfMatchups


//}  // LoadYesterdaysBoxScores
