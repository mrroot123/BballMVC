using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Bball.BAL;
using Bball.DAL.Functions;
using Bball.IBAL;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;
using TTI.Logger;

namespace BballMVC.ControllerAPIs
{
   // [ApiExceptionFilter]
   public class DataController : BaseApiController
   {
      
      IDataBO oDataBO;
      //  IDataBO oDataBO = new DataBO();

      public DataController()
      {
         oDataBO = new DataBO();
      }


      [HttpGet]
      public HttpResponseMessage GetData(string UserName, DateTime GameDate, string LeagueName, string CollectionType)
      {
         oBballInfoDTO.UserName = UserName;
         oBballInfoDTO.GameDate = GameDate;
         oBballInfoDTO.LeagueName = LeagueName;
         oBballInfoDTO.CollectionType = CollectionType;

         oDataBO.GetData(oBballInfoDTO);

         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      [HttpGet]
      public HttpResponseMessage RefreshTodaysMatchups(string UserName, DateTime GameDate, string LeagueName)
      {
         #region refreshTodaysMatchupsTryCatch
         try
         {
            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;

            new LoadBoxScores(UserName, LeagueName, GameDate, oBballInfoDTO.ConnectionString).LoadTodaysRotation();
            oBballInfoDTO.CollectionType = "RefreshTodaysMatchups";
            oDataBO.GetData(oBballInfoDTO);
         }
         catch (Exception ex)
         {
            TTILogMessage oTTILogMessage = new TTILogMessage();
            oTTILogMessage.UserName = UserName;
            oTTILogMessage.ApplicationName = "Bball";
            oTTILogMessage.MessageText = ex.Message;
            oTTILogMessage.CallStack = ex.StackTrace;
            new LogBO().LogMessage(oTTILogMessage, oBballInfoDTO.ConnectionString, oBballInfoDTO.LogName);
            throw new Exception($"Message: {ex.Message} - Stacktrace: {ex.StackTrace}");
         }
         #endregion refreshTodaysMatchupsTryCatch

         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }

      //[HttpPost]
      //public HttpResponseMessage PostData([FromBody]JObject strJObject)
      //{
      //   var CollectionType = "";
      //   // JObject x = (JObject)sjObject;
      //   oDataBO.PostData(strJObject, CollectionType);
      //   return Request.CreateResponse(HttpStatusCode.OK, "Success");
      //}
      //[HttpPost]
      //public HttpResponseMessage PostData([FromBody]string strJObject)
      //{
      //   var CollectionType = "";
      //   // JObject x = (JObject)sjObject;
      //   oDataBO.PostData(strJObject, CollectionType);
      //   return Request.CreateResponse(HttpStatusCode.OK, "Success");
      //}

      //[HttpPost]
      //public HttpResponseMessage PostData([FromBody]string oJObject, [FromUri]string CollectionType)
      //{
      //  // oBballInfoDTO.oJObject = oJObject;
      //   oBballInfoDTO.CollectionType = CollectionType;
      //   oDataBO.PostData(oBballInfoDTO);
      //   return Request.CreateResponse(HttpStatusCode.OK, "Success");
      //}
      public class MyClass
      {
         public string MyString { get; set; }
      }
      [HttpPost]
      public HttpResponseMessage PostJsonString([FromBody] JsonString oJsonString, [FromUri]string CollectionType)
      {
         oBballInfoDTO.sJsonString = oJsonString.sJsonString;
         oBballInfoDTO.CollectionType = CollectionType;
         oDataBO.PostData(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
      [HttpPost]
      public HttpResponseMessage xPostTest([FromBody]string MyString)
      {
         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }

      //  ajx.AjaxPost(url.UrlPostObject + "?CollectionType=ProcessPlays", ocTodaysPlaysDTO)
      [HttpPost]
      public HttpResponseMessage PostObject([FromBody]List<DTOs.TodaysPlaysDTO> ocTodaysPlaysDTO, [FromUri]string CollectionType)
      {
         oBballInfoDTO.oObject = ocTodaysPlaysDTO;
         
         oBballInfoDTO.CollectionType = CollectionType;
         oDataBO.PostData(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
      [HttpPost]
      public HttpResponseMessage PostData([FromBody]JObject oJObject, [FromUri]string CollectionType)
      {
         oBballInfoDTO.oJObject = oJObject;
         oBballInfoDTO.CollectionType = CollectionType;
         try
         {
            oDataBO.PostData(oBballInfoDTO);
         }
         catch (Exception ex)
         {
            string msg = $"DataController/PostData error - CollectionType = {CollectionType} ";
            throw new Exception(DALFunctions.StackTraceFormat(msg, ex, ""));

         }
         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }

      [HttpPost]
      public HttpResponseMessage PostBoxScoresSeeds(BBSdata oBBSdata)
      {
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
         {
            UserName = oBBSdata.UserName,
            GameDate = oBBSdata.GameDate,
            LeagueName = oBBSdata.LeagueName,
            ConnectionString = GetConnectionString()
         };

         IList<IBoxScoresSeedsDTO> oc = new List<IBoxScoresSeedsDTO>();
         foreach (BBSupdates o in oBBSdata.ocBBSupdates)
         {
            oc.Add(new BoxScoresSeedsDTO()
            {
               Team = o.Team
               ,
               AdjustmentAmountMade = o.AdjustmentAmountAllowed
               ,
               AdjustmentAmountAllowed = o.AdjustmentAmountAllowed
            });
         }
         oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO = oc;
         //oDataBO.UpdateData(aa);

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
      public class BBSdata
      {
         public string UserName { get; set; }
         public DateTime GameDate { get; set; }
         public string LeagueName { get; set; }
         public List<BBSupdates> ocBBSupdates { get; set; }
      }
      public class BBSupdates
      {
         public string Team { get; set; }
         public float AdjustmentAmountMade { get; set; }
         public float AdjustmentAmountAllowed { get; set; }
      }
      /*
      [HttpGet]
      public HttpResponseMessage GetAdjustmentInfo(DateTime GameDate, string LeagueName)
      {
         IAdjustmentInitDataDTO oAdjustmentInitDataDTO = oDataBO.GetAdjustmentInfo(GameDate, LeagueName);
         return Request.CreateResponse(HttpStatusCode.OK, oAdjustmentInitDataDTO);
      }

      [HttpPost]
      public HttpResponseMessage PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         //   var a = new AdjustmentDTO { AdjustmentAmount = 2, AdjustmentID = 1 };
         //   var b =  Request.RequestUri.GetLeftPart(System.UriPartial.Authority);
         IList<IAdjustmentDTO> aa = new List<IAdjustmentDTO>();
         foreach (AdjustmentDTO adj in ocAdjustmentDTO)
         {
            aa.Add(adj);
         }
         //  IList<IAdjustmentDTO> x = (IList<IAdjustmentDTO>) ocAdjustmentDTO;
         oDataBO.UpdateData(aa);

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
      [HttpPost] //  [ValidateAntiForgeryToken]
      public HttpResponseMessage PostInsertAdjustment(AdjustmentDTO oAdjustmentDTO)
      {
         try
         {
            oDataBO.InsertNewAdjustment(oAdjustmentDTO);
         }
         catch (SqlException ex)
         {
            if (ex.State == 0)
            {
               return Request.CreateResponse(HttpStatusCode.BadRequest, ex.Message);
            }
            throw new Exception(ex.Message);
         }
         catch (Exception ex)
         {
            throw new Exception(ex.Message);
         }
         return Request.CreateResponse(HttpStatusCode.OK);
      }
*/
   }
   //public class GetDataConstants
   //{
   //   public const string DataConstants = "DataConstants";
   //   public const string GetBoxScoresSeeds = "GetBoxScoresSeeds";
   //   public const string GetDailySummaryDTO = "GetDailySummaryDTO";
   //   public const string GetLeagueData = "GetLeagueData";
   //   public const string GetLeagueNames = "GetLeagueNames";
   //   public const string LoadBoxScores = "LoadBoxScores";
   //   public const string RefreshPostGameAnalysis = "RefreshPostGameAnalysis";
   //   public const string RefreshTodaysMatchups = "RefreshTodaysMatchups";
   //}
}