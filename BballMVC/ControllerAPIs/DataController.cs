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
      public HttpResponseMessage GetBballInfo()
      {
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO);
      }
      [HttpGet]
      public HttpResponseMessage GetBballData(string UserName, DateTime GameDate, string LeagueName, string CollectionType)
      {
         try
         {

            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;
            oBballInfoDTO.CollectionType = CollectionType;

            oDataBO.GetData(oBballInfoDTO);
         }
         catch (Exception ex)
         {
            oBballInfoDTO.oBballDataDTO.Message = ex.Message;
            oBballInfoDTO.oBballDataDTO.MessageNumber = 500;
            return Request.CreateResponse(HttpStatusCode.InternalServerError, oBballInfoDTO);
         }
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      [HttpGet]
      public HttpResponseMessage GetData(string UserName, DateTime GameDate, string LeagueName, string CollectionType)
      {
        
         try
         {

            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;
            oBballInfoDTO.CollectionType = CollectionType;

            oDataBO.GetData(oBballInfoDTO);
         }
         catch (Exception ex)
         {
            oBballInfoDTO.oBballDataDTO.Message = ex.Message;
            oBballInfoDTO.oBballDataDTO.MessageNumber = 500;
            return Request.CreateResponse(HttpStatusCode.InternalServerError, oBballInfoDTO);
         }
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO);
      }
      [HttpGet]
      public HttpResponseMessage RefreshTodaysMatchups(string UserName, DateTime GameDate, string LeagueName)
      {
         #region refreshTodaysMatchupsTryCatch
         Helper.Log(oBballInfoDTO, "RefreshTodaysMatchups Entry");
         try
         {
            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;

           // 02/13/2021 new LoadBoxScores(UserName, LeagueName, GameDate, oBballInfoDTO.ConnectionString).LoadTodaysRotation();
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
         stopwatch.Stop();
         Helper.Log(oBballInfoDTO, $"RefreshTodaysMatchups Exit - ET in ms: {stopwatch.ElapsedMilliseconds}");

         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      // Get Matchups with past date
      [HttpGet]
      public HttpResponseMessage GetPastMatchups(string UserName, DateTime GameDate, string LeagueName)
      {     // kdtodo combine RefreshTodaysMatchups & GetPastMatchups to one private method passing CollectionType
         #region getPastMatchupsTryCatch
         try
         {
            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;

            oBballInfoDTO.CollectionType = "GetPastMatchups";

            //oBballInfoDTO.CollectionType = "ReloadBoxScores"; kdcleanup
            //oBballInfoDTO.GameDate = Convert.ToDateTime("2/1/2021");

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
         #endregion getPastMatchupsTryCatch

         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      
      [HttpGet]
      public HttpResponseMessage SqlToJson(string RequestType, string Parms)
      {
         var json = oDataBO.SqlToJson(RequestType, Parms, oBballInfoDTO.ConnectionString);
         return Request.CreateResponse(HttpStatusCode.OK, json);
      }

      //[HttpPost] kdcleanup
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
      //public class MyClass
      //{
      //   public string MyString { get; set; }
      //}
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
         oBballInfoDTO.UserName = oBBSdata.UserName;
         oBballInfoDTO.GameDate = oBBSdata.GameDate;
         oBballInfoDTO.LeagueName = oBBSdata.LeagueName;
            
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

   }

}