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
using Bball.DAL.Parsing;
using System.IO;

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
      public LoadBoxScores(IBballInfoDTO oBballInfoDTO)
      {
         new LeagueInfoDO(oBballInfoDTO.LeagueName, _oLeagueDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate);  // Init _oLeagueDTO
         SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(oBballInfoDTO.GameDate, _oLeagueDTO.LeagueName, oBballInfoDTO.ConnectionString);

         _oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);
         _oBballInfoDTO.oSeasonInfoDTO = oSeasonInfoDO.oSeasonInfoDTO;

         _DefaultDate = SeasonInfoDO.DefaultDate;
         LoadBoxScoreRange(_oBballInfoDTO.LeagueName, _oBballInfoDTO.ConnectionString, SeasonInfoDO.DefaultDate);
      }
      public LoadBoxScores(string UserName, string LeagueName, DateTime GameDate, string ConnectionString)
      {
         new LeagueInfoDO(LeagueName, _oLeagueDTO, ConnectionString, GameDate);  // Init _oLeagueDTO
         SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(GameDate, LeagueName, ConnectionString);

        // oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName);
         _oBballInfoDTO = new BballInfoDTO()
         {
            ConnectionString = ConnectionString,
            GameDate = oSeasonInfoDO.GameDate,
            LeagueName = LeagueName,
            UserName = UserName,
            oSeasonInfoDTO = oSeasonInfoDO.oSeasonInfoDTO
         };
         _DefaultDate = SeasonInfoDO.DefaultDate;
         LoadBoxScoreRange(LeagueName, ConnectionString, SeasonInfoDO.DefaultDate, _oLeagueDTO.BoxScoresL5MinURL);
      }
      #endregion constructors

      public void LoadTodaysRotation()
      {


         // Load Rotations
         //
         //int rotationDays2Load = 2;
         //for (int i = 0; i < rotationDays2Load; i++) // Loop twice - Load Today's & Tomorrow's Rotation

         DateTime GameDate = SqlFunctions.GetMaxGameDate(
            _oBballInfoDTO.ConnectionString, _oBballInfoDTO.LeagueName, "Rotation", _DefaultDate);
         GameDate = getNextGameDate(GameDate, _oBballInfoDTO.ConnectionString);
         SeasonInfoDO _oSeasonInfoDO = new SeasonInfoDO(GameDate, _oBballInfoDTO.LeagueName, _oBballInfoDTO.ConnectionString);
         new DataDO().GetUserLeagueParmsDTO(_oBballInfoDTO);   // will Populate _oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO
         int LoadRotationDaysAhead = _oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO.LoadRotationDaysAhead; 

         while (_oBballInfoDTO.GameDate <= DateTime.Today.AddDays(LoadRotationDaysAhead))  // Is GameDate > Tomorrow)
         {
            // string _strLoadDateTime = _oBballInfoDTO.LoadDateTime();    // _oSeasonInfoDO.GameDate.ToString();

            SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
            try
            {
               RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO, true);   // always refresh Rotation b4 loading Boxscores
            }
            catch (Exception ex)
            {
               throw new Exception($"Covers Rotation Error {_oBballInfoDTO.GameDate} - {ex.Message}");
            }

            _oBballInfoDTO.GameDate = _oBballInfoDTO.GameDate.AddDays(1); // kd make nextGameDate function
            _oSeasonInfoDO.GameDate = _oSeasonInfoDO.GameDate.AddDays(1);
         }
  
         SqlFunctions.ParmTableParmValueUpdate(_oBballInfoDTO.ConnectionString, "BoxscoresLastUpdateDate", DateTime.Today.ToShortDateString());
      }

      private void LoadBoxScoreRange(string LeagueName, string ConnectionString, DateTime DefaultDate, string BoxScoresL5MinURL = "")
      {
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
         DateTime LoadDateTime = DateTime.Now;

         string _strLoadDateTime = LoadDateTime.ToString();

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         _oBballInfoDTO.GameDate = GameDate;
         SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName, _oBballInfoDTO.ConnectionString);
         RotationDO.PopulateRotation(ocRotation, _oBballInfoDTO, _oLeagueDTO);   // Get Rotation for GameDate - Populate if Not Found
         if (ocRotation.Count == 0)
            return 0;   // No Games for GameDate

         foreach (var matchup in ocRotation)
         {

            CoversDTO oCoversDTO = matchup.Value;
            if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass cancelled games
               continue;

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
                  oCoversBoxscore.PopulateBoxScoresDTO(BoxScoresDTO, arVenue[i]
                                 , oSeasonInfoDO.oSeasonInfoDTO.Season, oSeasonInfoDO.oSeasonInfoDTO.SubSeason, LoadDateTime
                                 , oCoversBoxscore.LoadTimeSecound, "Covers");
                  Bball.DAL.Tables.BoxScoreDO.InsertBoxScores(BoxScoresDTO, _oBballInfoDTO.ConnectionString);
               }
               catch (Exception ex)
               {
                  string msg = $"BoxScore Load Error - "
                     + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:{arVenue[i]}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                     + "\n" + oCoversDTO.Url;
                  throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
               }
            }
            if (! String.IsNullOrEmpty(_oLeagueDTO.BoxScoresL5MinURL))
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
                  LoadDate = LoadDateTime
               };
               try
               {
                  //Bball.DAL.Tables.
                  BoxScoreDO.InsertAwayHomeRowsBoxScoresLast5Min(oLast5MinDTOHome, _oBballInfoDTO.ConnectionString, oLast5Min);
               }
               catch (FileNotFoundException ex)
               {
                  // bypass 404 url not found -  todo log it
               }
               catch (Exception ex)
               {
                  //if (oLast5Min.oWebPageGet)
                  string msg = $"BoxScoreL5Min Load Error - "
                     + $"{_oLeagueDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                     + "\n" + Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome);
                  throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));
               }
            }  // Insert 
         } // foreach MUP
         

         return ocRotation.Count;  // return NumOfMatchups


      }  // LoadYesterdaysBoxScores

      private DateTime getNextGameDate(DateTime GameDate, string ConnectionString)
      {
         return  new SeasonInfoDO(GameDate, _oLeagueDTO.LeagueName, ConnectionString).GetNextGameDate();
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

   }
}
