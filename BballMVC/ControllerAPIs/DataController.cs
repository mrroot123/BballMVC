using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Bball.BAL;
using Bball.IBAL;

using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace BballMVC.ControllerAPIs
{
   public class DataController : BaseApiController
   {
      
      IDataBO oDataBO;
      //  IDataBO oDataBO = new DataBO();

      public DataController()
      {
         oDataBO = new DataBO();
      }

      [HttpGet]
      public HttpResponseMessage GetLeagueNames(string UserName)
      {
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
         {
            UserName = UserName
         };
         oBballInfoDTO.ConnectionString = GetConnectionString();
         oDataBO.GetLeagueNames(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      [HttpGet]
      public HttpResponseMessage GetLeagueData(string UserName, DateTime GameDate, string LeagueName)
      {
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
            { UserName = UserName, GameDate = GameDate, LeagueName = LeagueName, ConnectionString = GetConnectionString()  };
         oDataBO.GetLeagueData(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }
      [HttpGet]
      public HttpResponseMessage RefreshTodaysMatchups(string UserName, DateTime GameDate, string LeagueName)
      {
         try
         {
            oBballInfoDTO.UserName = UserName;
            oBballInfoDTO.GameDate = GameDate;
            oBballInfoDTO.LeagueName = LeagueName;

            new LoadBoxScores(LeagueName, GameDate, oBballInfoDTO.ConnectionString).LoadTodaysRotation();
            oDataBO.RefreshTodaysMatchups(oBballInfoDTO);
         }
         catch (Exception ex)
         {
            throw new Exception($"Message: {ex.Message} - Stacktrace: {ex.StackTrace}");
         }

         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO);
      }
      [HttpGet]
      public HttpResponseMessage GetBoxScoresSeeds(string UserName, DateTime GameDate, string LeagueName)
      {
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
         {
            UserName = UserName,
            GameDate = GameDate,
            LeagueName = LeagueName,
            ConnectionString = GetConnectionString()
         };
         oDataBO.GetBoxScoresSeeds(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO);
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
}