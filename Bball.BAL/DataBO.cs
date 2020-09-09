using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;
using Bball.DAL.Constants;
using Newtonsoft.Json.Linq;

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
            switch (CollectionType)
            {
               case GetDataConstants.AppInit:
                  GetDataConstants.PopulateDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
                  oBballInfoDTO.oBballDataDTO.BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;
                  new AdjustmentsDO(oBballInfoDTO).UpdateYesterdaysAdjustments();
                  new DataDO().GetLeagueNames(oBballInfoDTO);
                  //
                  IBballInfoDTO _oBballInfoDTO = new BballInfoDTO();
                  oBballInfoDTO.CloneBballDataDTO(_oBballInfoDTO);

                  foreach (var item in oBballInfoDTO.oBballDataDTO.ocLeagueNames){
                     _oBballInfoDTO.LeagueName = item.Value;
                     new LoadBoxScores(_oBballInfoDTO);
                     new DataDO().Exec_uspCalcTodaysMatchups(_oBballInfoDTO);
                  }

                  break;
               case GetDataConstants.DataConstants:
                  GetDataConstants.PopulateDataConstants(oBballInfoDTO.oBballDataDTO.DataConstants);
                  break;
               case GetDataConstants.GetBoxScoresSeeds:           // ocBoxScoresSeedsDTO
                  new DataDO().GetBoxScoresSeeds(oBballInfoDTO);
                  break;
               case GetDataConstants.GetDailySummaryDTO:          // oDailySummaryDTO
                  new DataDO().GetDailySummaryDTO(oBballInfoDTO);
                  break;
               // 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  4) RefreshTodaysMatchups  5) ocPostGameAnalysisDTO
               case GetDataConstants.GetLeagueData:
                  new DataDO().GetLeagueData(oBballInfoDTO);
                  break;
               case GetDataConstants.GetLeagueNames:              // ocLeagueNames
                  new DataDO().GetLeagueNames(oBballInfoDTO);
                  break;
               case GetDataConstants.LoadBoxScores:
                  new LoadBoxScores(oBballInfoDTO.UserName, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate, oBballInfoDTO.ConnectionString).LoadTodaysRotation();
                  break;
               case GetDataConstants.RefreshPostGameAnalysis:     // ocPostGameAnalysisDTO
                  new DataDO().RefreshPostGameAnalysis(oBballInfoDTO); 
                  break;
               case GetDataConstants.RefreshTodaysMatchups:       // Run uspCalcTMs, Get ocTodaysMatchupsDTO
                  new DataDO().RefreshTodaysMatchups(oBballInfoDTO);
                  break;
               case "error":
                  var x = 0;
                  var y = 2 / x;
                  break;
               default:
                  throw new Exception("Invalid CollectionType: " + CollectionType);
            }

         }
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

      public static void PopulateDataConstants(dynamic d)
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
      }
   }
   public class PostDataConstants
   {
      public const string InsertAdjustment = "InsertAdjustment";
      public const string UpdateAdjustments = "UpdateAdjustments";

      public static void PopulateDataConstants(dynamic d)
      {
         d.InsertAdjustment = InsertAdjustment;
         d.UpdateAdjustments = UpdateAdjustments;
      }

   }  // PostDataConstants

}  // Namespace
