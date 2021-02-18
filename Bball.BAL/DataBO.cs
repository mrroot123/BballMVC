using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;
using Bball.DAL.Constants;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using TTI.Logger;

namespace Bball.BAL
{
   
   public class DataBO : IDataBO 
   {
      // IBballInfoDTO _oBballInfoDTO;
      DataDO _DataDO = new DataDO();
      // Constructor
  //    public DataBO(IBballInfoDTO BballInfoDTO) => _oBballInfoDTO = BballInfoDTO;

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
                  break;

               case GetDataConstants.RefreshTodaysMatchups:       // Run uspCalcTMs, Get ocTodaysMatchupsDTO
                  new DataDO().RefreshTodaysMatchups(oBballInfoDTO);
                  new DataDO().GetDailySummaryDTO(oBballInfoDTO);
                  break;

               case GetDataConstants.GetPastMatchups:       
                  new DataDO().GetTodaysMatchups(oBballInfoDTO);
                  new DataDO().GetDailySummaryDTO(oBballInfoDTO);
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
      async Task appInitAsync(IBballInfoDTO oBballInfoDTO)
      {
         GetDataConstants.PopulateGetDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
         oBballInfoDTO.oBballDataDTO.BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;

         Task<bool> taskAdj = updateYesterdaysAdjustmentsAsync(oBballInfoDTO);

         new DataDO().GetLeagueNames(oBballInfoDTO);
         //
         IBballInfoDTO _oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);

         
         foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         {
            new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
         }
         new AdjustmentsDO(oBballInfoDTO).UpdateTodaysPlays();
         await taskAdj;

         //List<Task<string>> taskCalcTMs = new List<Task<string>>();
         //foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         //{
         //   _oBballInfoDTO.LeagueName = item.Value;
         //   taskCalcTMs.Add(loadBoxScoresAsync(_oBballInfoDTO));
         //}
         //while (taskCalcTMs.Count > 0)
         //{
         //   Task finishedTask = await Task.WhenAny(taskCalcTMs);
         //   for (int i= 0; i < taskCalcTMs.Count;i++)
         //   {
         //      if (taskCalcTMs[i].Result != null)
         //      {
         //         taskCalcTMs.RemoveAt(i);
         //         break;
         //      }
         //   }
         //}  // while


      }  // appInit
      void appInit(IBballInfoDTO oBballInfoDTO)
      {
         GetDataConstants.PopulateGetDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
         oBballInfoDTO.oBballDataDTO.BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;

         Task<bool> taskAdj = updateYesterdaysAdjustmentsAsync(oBballInfoDTO);

         new DataDO().GetLeagueNames(oBballInfoDTO);
         //
         IBballInfoDTO _oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);


         foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         {
            oBballInfoDTO.LeagueName = item.Value;
            
            new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
         }
         new AdjustmentsDO(oBballInfoDTO).UpdateTodaysPlays();
         //await taskAdj;

         //List<Task<string>> taskCalcTMs = new List<Task<string>>();
         //foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         //{
         //   _oBballInfoDTO.LeagueName = item.Value;
         //   taskCalcTMs.Add(loadBoxScoresAsync(_oBballInfoDTO));
         //}
         //while (taskCalcTMs.Count > 0)
         //{
         //   Task finishedTask = await Task.WhenAny(taskCalcTMs);
         //   for (int i= 0; i < taskCalcTMs.Count;i++)
         //   {
         //      if (taskCalcTMs[i].Result != null)
         //      {
         //         taskCalcTMs.RemoveAt(i);
         //         break;
         //      }
         //   }
         //}  // while


      }  // appInit

      async Task<bool> updateYesterdaysAdjustmentsAsync(IBballInfoDTO oBballInfoDTO)
      {
         await Task.Run(() =>
            new AdjustmentsDO(oBballInfoDTO).UpdateYesterdaysAdjustments());
         return true;
      }

      async Task<string> loadBoxScoresAsync(IBballInfoDTO oBballInfoDTO)
      {
         await Task.Run(() =>
            {
               new LoadBoxScores(oBballInfoDTO).LoadTodaysRotation();
               //new DataDO().Exec_uspCalcTodaysMatchups(oBballInfoDTO);
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
