using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;
using System.Threading.Tasks;
using TTI.Logger;
using TTI.Models;

namespace Bball.BAL
{

   public class DataBO : IDataBO
   {
      // IBballInfoDTO _oBballInfoDTO;
      DataDO _DataDO = new DataDO();
      // Constructor
      //    public DataBO(IBballInfoDTO BballInfoDTO) => _oBballInfoDTO = BballInfoDTO;

      public string SqlToJson(string RequestType, string Parms, string ConnectionString)
          => new DataDO().SqlToJson(RequestType, Parms, ConnectionString);

      public async Task GetDataAsync(IBballInfoDTO oBballInfoDTO)
      {
         string[] arCollectionTypes = oBballInfoDTO.CollectionType.Split('~');
         foreach (var CollectionType in arCollectionTypes)
         {
            Helper.Log(oBballInfoDTO, $"DataDO.GetData - CollectionType: {CollectionType}");

            switch (CollectionType)
            {

            case PostDataConstants.ReloadBoxScoresAsync:
               await new LoadBoxScores().ReloadBoxScoresAsync(oBballInfoDTO);
               break;

            case GetDataConstants.AppInitAsync:
               await appInitAsync(oBballInfoDTO);
               break;

            case "error":
               var x = 0;
               var y = 2 / x;
               break;
            default:
               throw new Exception("DataBO.GetData - Invalid CollectionType: " + CollectionType);
            }

         }
      }

      public void GetData(IBballInfoDTO oBballInfoDTO)
      {
         string[] arCollectionTypes = oBballInfoDTO.CollectionType.Split('~');
         foreach (var CollectionType in arCollectionTypes)
         {
            Helper.Log(oBballInfoDTO, $"DataDO.GetData - CollectionType: {CollectionType}");

            switch (CollectionType)
            {
            case GetDataConstants.AppInit:
               appInit(oBballInfoDTO);
               break;


            case PostDataConstants.ReloadBoxScores:
               new LoadBoxScores().ReloadBoxScores(oBballInfoDTO);
               break;


            // 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  4) LeagueParmsDTO
            case GetDataConstants.GetLeagueData:
               new DataDO().GetLeagueData(oBballInfoDTO);
               new DataDO().GetUserLeagueParmsDTO(oBballInfoDTO);
               new DataDO().VerifyTables(oBballInfoDTO);
               break;

            // Todays Matchups
            case GetDataConstants.RefreshTodaysMatchups:       // Run uspCalcTMs, Get ocTodaysMatchupsDTO
               new DataDO().RefreshTodaysMatchups(oBballInfoDTO);
               new DataDO().GetUserLeagueParmsDTO(oBballInfoDTO);
               new DataDO().GetLeagueData(oBballInfoDTO);
               break;
            case GetDataConstants.GetPastMatchups:
               new DataDO().GetTodaysMatchups(oBballInfoDTO);
               new DataDO().GetUserLeagueParmsDTO(oBballInfoDTO);
               new DataDO().GetLeagueData(oBballInfoDTO);
               break;

            case GetDataConstants.DataConstants:
               GetDataConstants.PopulateGetDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
               break;
            case GetDataConstants.GetBoxScoresSeeds:           // ocBoxScoresSeedsDTO
               new DataDO().GetBoxScoresSeeds(oBballInfoDTO);
               break;
            //case GetDataConstants.GetDailySummaryDTO:          // oDailySummaryDTO
            //   new DataDO().GetDailySummaryDTO(oBballInfoDTO);
            //   new DataDO().GetUserLeagueParmsDTO(oBballInfoDTO);
            //   break;

            case GetDataConstants.GetLeagueNames:              // ocLeagueNames
               new DataDO().GetLeagueNames(oBballInfoDTO);
               break;
            //case GetDataConstants.LoadBoxScores:  02/13/2021
            //  // new LoadBoxScores(oBballInfoDTO.UserName, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate, oBballInfoDTO.ConnectionString).LoadTodaysRotation();
            //   new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
            //   break;
            case GetDataConstants.RefreshPostGameAnalysis:     // ocPostGameAnalysisDTO
               new DataDO().RefreshPostGameAnalysis(oBballInfoDTO);
               break;

            case "error":
               var x = 0;
               var y = 2 / x;
               break;
            default:
               throw new Exception("DataBO.GetData - Invalid CollectionType: " + CollectionType);
            }

         }
      }
      async Task appInitAsync(IBballInfoDTO oBballInfoDTO)  // 03/06/2021 - not referenced
      {
         GetDataConstants.PopulateGetDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
         oBballInfoDTO.oBballDataDTO.BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;

         List<Task<TaskInfo>> tasks = new List<Task<TaskInfo>>();

         await Task.Run(() => {
            new DataDO().GetLeagueNames(oBballInfoDTO);  // return LeagueNames for dropdown & Load Boxscores
         });

         foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         {
            oBballInfoDTO.LeagueName = item.Value;
            tasks.Add(Task.Run(() => {
               TaskInfo oTaskInfo = new TaskInfo() { TaskID = "LoadTodaysRotation", TaskType = oBballInfoDTO.LeagueName };
               new LoadBoxScoresAsync().LoadBoxScoreRangeAsync(oBballInfoDTO);
               oTaskInfo.EndTask();
               return oTaskInfo;
            }));
            new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
         }

         tasks.Add(Task.Run(() => {
            TaskInfo oTaskInfo = new TaskInfo() { TaskID = "UpdateYesterdaysAdjustments" };
            new AdjustmentsDO(oBballInfoDTO).UpdateYesterdaysAdjustments();
            oTaskInfo.EndTask();
            return oTaskInfo;
         }));

         tasks.Add(Task.Run(() => {
            TaskInfo oTaskInfo = new TaskInfo() { TaskID = "UpdateTodaysPlays" };
            new AdjustmentsDO(oBballInfoDTO).UpdateTodaysPlays();
            oTaskInfo.EndTask();
            return oTaskInfo;
         }));

         await Task.WhenAll(tasks);

      }  // appInitAsync
      void appInit(IBballInfoDTO oBballInfoDTO)
      {
         GetDataConstants.PopulateGetDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
         oBballInfoDTO.oBballDataDTO.BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;

         new AdjustmentsDO(oBballInfoDTO).UpdateYesterdaysAdjustments();
         new DataDO().GetLeagueNames(oBballInfoDTO);  // return LeagueNames for dropdown & Load Boxscores
         //
         IBballInfoDTO _oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);


         foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)   // Batch process
         {
            oBballInfoDTO.LeagueName = item.Value;

            new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();  // Constructor Loads BoxScores then Rotation is Loaded
         }
         new AdjustmentsDO(oBballInfoDTO).UpdateTodaysPlays(); // Batch process


      }  // appInit

      async Task<bool> updateYesterdaysAdjustmentsAsync(IBballInfoDTO oBballInfoDTO)
      {
         await Task.Run(() =>
            new AdjustmentsDO(oBballInfoDTO).UpdateYesterdaysAdjustments());
         return true;
      }

      async Task<string> loadBoxScoresAsync(IBballInfoDTO oBballInfoDTO)
      {
         await Task.Run(() => {
            new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
         }
         );
         return oBballInfoDTO.LeagueName;
      }



      // Posts
      public void PostData(IBballInfoDTO oBballInfoDTO)
      {
         //  JObject jObject = (JObject)strJObject;
         switch (oBballInfoDTO.CollectionType)
         {
         case PostDataConstants.InsertAdjustment:
            // IAdjustmentDTO oAdjustmentDTO = oBballInfoDTO.oJObject.ToObject<AdjustmentDTO>();
            //new AdjustmentsDO().InsertAdjustmentRow(oAdjustmentDTO);
            _DataDO.InsertAdjustmentRow(oBballInfoDTO);
            break;

         case PostDataConstants.UpdateAdjustments:
            _DataDO.UpdateAdjustments(oBballInfoDTO);
            IList<BballMVC.IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oBballInfoDTO.oJObject.ToObject<IList<BballMVC.IDTOs.IAdjustmentDTO>>();
            // new AdjustmentsDO().UpdateAdjustmentRow(ocAdjustmentDTO);
            break;

         case PostDataConstants.ProcessPlays:
            _DataDO.ProcessPlays(oBballInfoDTO);
            break;

         case PostDataConstants.ReloadBoxScores:
            new LoadBoxScores().ReloadBoxScores(oBballInfoDTO);
            break;

         default:
            throw new Exception("DataDO.PostData - Invalid CollectionType :" + oBballInfoDTO.CollectionType);
         }
      }
   }

   public  class GetDataConstants
   {
      public const string AppInit = "AppInit";
      public const string AppInitAsync = "AppInitAsync";
      public const string DataConstants = "DataConstants";
      public const string GetBoxScoresSeeds = "GetBoxScoresSeeds";
      public const string GetDailySummaryDTO = "GetDailySummaryDTO";
      public const string GetLeagueData = "GetLeagueData";
      public const string GetLeagueNames = "GetLeagueNames";
      public const string LoadBoxScores = "LoadBoxScores";
      public const string RefreshPostGameAnalysis = "RefreshPostGameAnalysis";
      public const string RefreshTodaysMatchups = "RefreshTodaysMatchups";
      public const string GetPastMatchups = "GetPastMatchups";

      public static void PopulateGetDataConstants(dynamic d)
      {
         d.AppInit = AppInit;
         d.DataConstants = DataConstants;
         d.GetBoxScoresSeeds = GetBoxScoresSeeds;
         d.GetDailySummaryDTO = GetDailySummaryDTO;
         d.GetLeagueData = GetLeagueData;
         d.GetLeagueNames = GetLeagueNames;
         d.LoadBoxScores = LoadBoxScores;
         d.RefreshPostGameAnalysis = RefreshPostGameAnalysis;
         d.RefreshTodaysMatchups = RefreshTodaysMatchups;
         d.GetPastMatchups = GetPastMatchups;
      }
   }
   public class PostDataConstants
   {
      
      public const string InsertAdjustment = "InsertAdjustment";
      public const string ProcessPlays = "ProcessPlays";
      public const string ReloadBoxScores = "ReloadBoxScores";
      public const string ReloadBoxScoresAsync = "ReloadBoxScoresAsync";
      public const string UpdateAdjustments = "UpdateAdjustments";
      
      public static void PopulatePostDataConstants(dynamic d)
      {
         d.InsertAdjustment = InsertAdjustment;
         d.ProcessPlays = ProcessPlays;
         d.ReloadBoxScores = ReloadBoxScores;
         d.UpdateAdjustments = UpdateAdjustments;
      }

   }  // PostDataConstants

}  // Namespace
