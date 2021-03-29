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
using Newtonsoft.Json.Linq;

namespace BballMVC.ControllerAPIs
{
   public class AdjustmentsController : BaseApiController
   {
      IAdjustmentsBO oAdjustmentsBO;
      //  IAdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
     // BballInfoDTO _oBballInfoDTO = new BballInfoDTO();

      // Constructor
      public AdjustmentsController()
      {
         oAdjustmentsBO = new AdjustmentsBO(oBballInfoDTO);
      }

      [HttpGet]   // G1
      public HttpResponseMessage GetAdjustments(DateTime GameDate, string LeagueName)
      {
         List<IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(GameDate, LeagueName);
         return Request.CreateResponse(HttpStatusCode.OK, ocAdjustmentDTO);
      }
      // G1 new GetTodaysAdjustments
      [HttpGet]   // G1
      public HttpResponseMessage GetAdjustments(string UserName, DateTime GameDate, string LeagueName)
      {
         oBballInfoDTO.UserName = UserName;
         oBballInfoDTO.GameDate = GameDate;
         oBballInfoDTO.LeagueName = LeagueName;

         oAdjustmentsBO.GetTodaysAdjustments(oBballInfoDTO);

         //List<IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(GameDate, LeagueName);
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO.ocAdjustments);
      }
      [HttpGet]   // G1 By Team
      public HttpResponseMessage GetAdjustmentsByTeam(DateTime GameDate, string LeagueName, string Team, double SideLine)
      {
         List<IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustmentsByTeam(GameDate, LeagueName, Team, SideLine);
         return Request.CreateResponse(HttpStatusCode.OK, ocAdjustmentDTO);
      }
      [HttpGet]   // G2
      public HttpResponseMessage GetAdjustmentInfo(DateTime GameDate, string LeagueName)
      {
         IBballDataDTO oBballDataDTO = oAdjustmentsBO.GetAdjustmentInfo(GameDate, LeagueName);
         return Request.CreateResponse(HttpStatusCode.OK, oBballDataDTO);
      }
      [HttpGet]   // G2B
      public HttpResponseMessage GetAdjustmentInfo2(DateTime GameDate, string LeagueName)
      {
         oBballInfoDTO.GameDate = GameDate;
         oBballInfoDTO.LeagueName = LeagueName;

         oAdjustmentsBO.GetAdjustmentInfo(oBballInfoDTO);
         return Request.CreateResponse(HttpStatusCode.OK, oBballInfoDTO.oBballDataDTO);
      }


      [HttpPost]
      public HttpResponseMessage PostAdjustmentUpdates2(JObject jObject, [FromUri]string CollectionType)
      {
         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }

      [HttpPost]
      public HttpResponseMessage PostAdjustmentUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         //   var a = new AdjustmentDTO { AdjustmentAmount = 2, AdjustmentID = 1 };
         //   var b =  Request.RequestUri.GetLeftPart(System.UriPartial.Authority);
         IList<IAdjustmentDTO> aa = new List<IAdjustmentDTO>();
         foreach (AdjustmentDTO adj in ocAdjustmentDTO)
         {
            aa.Add(adj);
         }
         //  IList<IAdjustmentDTO> x = (IList<IAdjustmentDTO>) ocAdjustmentDTO;
         oBballInfoDTO.GameDate = DateTime.Today;
         oAdjustmentsBO.UpdateAdjustments(aa);

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
      //[HttpPost] //  [ValidateAntiForgeryToken]
      //public HttpResponseMessage PostInsertAdjustment(AdjustmentWrapper oAdjustmentWrapper)
      //{
      ////   oAdjustmentsBO.InsertNewAdjustment(oAdjustmentWrapper);
      //   return Request.CreateResponse(HttpStatusCode.OK);
      //}
      [HttpPost] //  [ValidateAntiForgeryToken]
      public HttpResponseMessage PostInsertAdjustment(AdjustmentDTO oAdjustmentDTO)
      {
         try
         {
            oAdjustmentsBO.InsertNewAdjustment(oAdjustmentDTO);
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

   }
}