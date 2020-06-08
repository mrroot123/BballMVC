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
   public class AdjustmentsController : BaseApiController
   {
      IAdjustmentsBO oAdjustmentsBO;
    //  IAdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();

      public AdjustmentsController()
      {
         oAdjustmentsBO = new AdjustmentsBO();
      }

      [HttpGet]
      public HttpResponseMessage GetAdjustments(DateTime GameDate, string LeagueName)
      {
         List<IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(GameDate, LeagueName);

         return Request.CreateResponse(HttpStatusCode.OK, ocAdjustmentDTO);
      }
      [HttpGet]
      public HttpResponseMessage GetAdjustmentInfo(DateTime GameDate, string LeagueName)
      {
         IAdjustmentInitDataDTO oAdjustmentInitDataDTO = oAdjustmentsBO.GetAdjustmentInfo(GameDate, LeagueName);
         return Request.CreateResponse(HttpStatusCode.OK, oAdjustmentInitDataDTO);
      }

      [HttpPost]
      public HttpResponseMessage PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
      //   var a = new AdjustmentDTO { AdjustmentAmount = 2, AdjustmentID = 1 };
      //   var b =  Request.RequestUri.GetLeftPart(System.UriPartial.Authority);
         IList <IAdjustmentDTO> aa = new List<IAdjustmentDTO>();
         foreach (AdjustmentDTO adj in ocAdjustmentDTO)
         {
            aa.Add(adj);
         }
       //  IList<IAdjustmentDTO> x = (IList<IAdjustmentDTO>) ocAdjustmentDTO;
         oAdjustmentsBO.UpdateAdjustments(aa);

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
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