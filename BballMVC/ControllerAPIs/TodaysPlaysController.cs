using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Bball.BAL;
using Bball.IBAL;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;
using TTI.Logger;

namespace BballMVC.ControllerAPIs
{
   // [ApiExceptionFilter]
   public class TodaysPlaysController : BaseApiController
   {

      //  TodaysPlaysBO oTodaysPlaysBO;
      //  IDataBO oDataBO = new DataBO();

      public TodaysPlaysController()
      {
         //oTodaysPlaysBO = new TodaysPlaysBO();
      }


      [HttpGet]
      public HttpResponseMessage GetTodaysPlays()
      {
         oBballInfoDTO.GameDate = DateTime.Today;
         oBballInfoDTO.UserName = "TodaysPlays";
         List<TodaysPlaysResults> ocTodaysPlaysResults = new List<TodaysPlaysResults>();
         try
         {
            new TodaysPlaysBO(oBballInfoDTO, ocTodaysPlaysResults);
         }
         catch (Exception ex)
         {
            throw new Exception($"Message: {ex.Message} - Stacktrace: {ex.StackTrace}");
         }

         return Request.CreateResponse(HttpStatusCode.OK, ocTodaysPlaysResults);
      }
   }

}