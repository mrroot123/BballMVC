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
using System.Threading.Tasks;
using TTI.Models;

namespace Bball.BAL
{
   public class LoadBoxScoresAsync
   {
      const string cCRLF = "<br>"; // Environment.NewLine 
      private string _message;
      public string Message {
         get { return _message; }
         set { _message += value + cCRLF; }
      }
      public async Task  LoadBoxScoreRangeAsync(IBballInfoDTO oBballInfoDTO)
      {
         Helper.Log(oBballInfoDTO, $"LoadBoxScores.loadBoxScoreRange - LeagueName: {oBballInfoDTO.LeagueName}");

         oBballInfoDTO.GameDate = BoxScoreDO.GetMaxBoxScoresGameDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, SeasonInfoDO.DefaultDate);

         getNextGameDate(oBballInfoDTO);

         while (oBballInfoDTO.GameDate < DateTime.Today)   // Load ALL previous Boxscores - usually Yesterday's
         {
            int NumOfMatchups = 0;
            try
            {
               await ReloadBoxScoresAsync(oBballInfoDTO);
            }
            catch (Exception ex)
            {
               throw new Exception(DALFunctions.StackTraceFormat(ex));
            }

            Helper.Log(oBballInfoDTO, $"Processed {oBballInfoDTO.GameDate} - {DateTime.Now} - Matchups: {NumOfMatchups}");
            getNextGameDate(oBballInfoDTO);
         }
      }
      #region reloadBoxScoresAsync
      public async Task ReloadBoxScoresAsync(IBballInfoDTO oBballInfoDTO)
      {
         SetupReloadBoxScoresAsync();      //oBballInfoDTO);

         await loopRotation2InsertBoxscoresAsync(oBballInfoDTO);

         return;

         //async Task ReloadBoxScoresSetupAsync()    // IBballInfoDTO oBballInfoDTO)
         void SetupReloadBoxScoresAsync()    // IBballInfoDTO oBballInfoDTO)
         {
            new LeagueInfoDO(oBballInfoDTO);  // Init _oLeagueDTO
            new SeasonInfoDO(oBballInfoDTO);                                        // set oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO
                                                                                    //  await Task.Run(() => {
            BoxScoreDO.DeleteBoxScoresByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
            BoxScoreDO.DeleteBoxScoresLast5MinByDate(oBballInfoDTO.ConnectionString, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate);
            //  });
         }
      }  // ReloadBoxScores

      async Task loopRotation2InsertBoxscoresAsync(IBballInfoDTO oBballInfoDTO)
      {
         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         RotationDO.PopulateRotation(ocRotation, oBballInfoDTO, oBballInfoDTO.oBballDataDTO.oLeagueDTO, RefreshRotation: true);    // Get Rotation for GameDate - Populate if Not Found
         if (ocRotation.Count == 0)
            return;   // No Games for GameDate

         List<Task<TaskInfo>> tasks = new List<Task<TaskInfo>>();

         foreach (var matchup in ocRotation)
         {
            CoversDTO oCoversDTO = matchup.Value;
            if (oCoversDTO.GameStatus == (int)CoversRotation.GameStatus.Canceled)   // Bypass Canceled games
               continue;
            tasks.Add(Task.Run(() =>
                  insertBoxScoreAsync(oCoversDTO, oBballInfoDTO, new TaskInfo())
            ));      // 1

         } // foreach MUP
         string msg = "";
         // var results = 
         await Task.WhenAll(tasks);
         bool throwEx = false;
         foreach (var e in tasks)
         {
            if (e.Result.ReturnCode != 0)
            {
               throwEx = true;
               msg += $"{e.Result.TaskID} - {e.Result.TaskType} - {e.Result.Message}\n";
            }
         }
         if (throwEx)
            throw new Exception(msg);
      }
      private TaskInfo insertBoxScoreAsync(CoversDTO oCoversDTO, IBballInfoDTO oBballInfoDTO, TaskInfo oTaskInfo)   // ISeasonInfoDTO oSeasonInfoDTO)
      {
         #region insertBoxScore

         var GameDate = oCoversDTO.GameDate;
         var LoadDateTime = oBballInfoDTO.LoadDateTime;
         oTaskInfo.TaskID = oBballInfoDTO.GameDate.ToShortDateString() + "-" + oCoversDTO.RotNum.ToString();
         oTaskInfo.TaskType = "LoadBoxscore";

         // 1) Get BoxScore from Covers
         CoversBoxscore oCoversBoxscore = new CoversBoxscore(GameDate, oBballInfoDTO.oBballDataDTO.oLeagueDTO, oCoversDTO);
         oCoversBoxscore.GetBoxscore();   // Get BoxScore html from Covers
         if (oCoversBoxscore.ReturnCode != 0)
         {
            string msg = $"oCoversBoxscore.ReturnCode: {oCoversBoxscore.ReturnCode} - "
               + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
               + cCRLF + oCoversDTO.Url;
            Helper.LogMessage(oBballInfoDTO, new Exception(msg), msg);
            oTaskInfo.EndTaskWithError(-1, msg);
            return oTaskInfo;
         }

         string[] arVenue = new string[] { "Away", "Home" };
         for (int i = 0; i < 2; i++)
         {
            try
            {
               // Write Away & Home rows to BoxScores
               // kdpace
               BoxScoresDTO oBoxScoresDTO = new BoxScoresDTO() {
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
                  + cCRLF + oCoversDTO.Url + " -- " + ex.Message;
               oTaskInfo.EndTaskWithError(-1, msg);
               return oTaskInfo;
            }
         }

         // kdtodo - 02/16/2022
         // 1) move L5Min to seperate method
         // 2) make catch code sepparate method
         // 3) make L5Min url a parm & access once only - done
         //
         // Process L5Min
         if (!String.IsNullOrEmpty(oBballInfoDTO.oBballDataDTO.oLeagueDTO.BoxScoresL5MinURL.Trim()))
         {
            // Write Last 5 Minutes stats
            
            BoxScoresLast5Min oLast5Min = null;
            BoxScoresLast5MinDTO oLast5MinDTOHome = new BoxScoresLast5MinDTO() {
               LeagueName = oCoversDTO.LeagueName,
               GameDate = oCoversDTO.GameDate,
               RotNum = oCoversDTO.RotNum + 1,
               Team = oCoversDTO.TeamHome,
               Opp = oCoversDTO.TeamAway,
               Venue = "Home",
               LoadDate = Convert.ToDateTime(LoadDateTime)
            };
            string L5MinUrl = Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome, oBballInfoDTO.ConnectionString);
            try
            {
               //Bball.DAL.Tables.
               BoxScoreDO.InsertAwayHomeRowsBoxScoresLast5Min(oLast5MinDTOHome, oBballInfoDTO.ConnectionString, oLast5Min);
            }
            catch (FileNotFoundException ex)
            {
               string msg = $"BoxScoreL5Min Url Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + cCRLF + L5MinUrl
                  + cCRLF + ex + Message;
               Helper.LogMessage(oBballInfoDTO, ex, msg);
               oTaskInfo.EndTaskWithError(1, msg);    // Error code 1 = warning since L5Min rows are optional
               return oTaskInfo;
            }
            catch (Exception ex)
            {
               //if (oLast5Min.oWebPageGet)
               string msg = $"BoxScoreL5Min Load Error - "
                  + $"{oBballInfoDTO.LeagueName}: {GameDate}  {oCoversDTO.RotNum}:  {oCoversDTO.TeamAway}-{oCoversDTO.TeamHome} "
                  + cCRLF + L5MinUrl
                  + cCRLF + ex + Message;
               Helper.LogMessage(oBballInfoDTO, ex, msg);
               oTaskInfo.EndTaskWithError(1, msg);    // Error code 1 = warning since L5Min rows are optional
               return oTaskInfo;
            }

         }  // Insert L5Min

         #endregion insertBoxscore
         oTaskInfo.EndTask();
         //if (oCoversDTO.RotNum > 550)
         //   oTaskInfo.ReturnCode = 1;
         return oTaskInfo;
      }  // insertBoxScoreAsync
      #endregion reloadBoxScoresAsync
      private void getNextGameDate(IBballInfoDTO oBballInfoDTO)
      {
         oBballInfoDTO.GameDate = new SeasonInfoDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString).GetNextGameDate();
      }
   }  // class LoadBoxScoresAsync
}  // namespace 
