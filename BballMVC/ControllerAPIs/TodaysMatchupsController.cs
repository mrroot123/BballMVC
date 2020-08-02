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
   public class TodaysMatchupsController : BaseApiController
   {
      //IAdjustmentsBO oAdjustmentsBO;

      [HttpGet]
      public HttpResponseMessage GetTodaysMatchups(DateTime GameDate, string LeagueName)
      {
         BballInfoDTO oBballInfoDTO = new BballInfoDTO()
            { UserName = GetUser(),  GameDate = GameDate, LeagueName = LeagueName, ConnectionString = GetConnectionString() };

         TodaysMatchupsBO oTodaysMatchupsBO = new TodaysMatchupsBO(oBballInfoDTO);

         IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         oTodaysMatchupsBO.GetTodaysMatchups(ocTodaysMatchupsDTO);

         return Request.CreateResponse(HttpStatusCode.OK, ocTodaysMatchupsDTO);
      }
      [HttpGet]
      public HttpResponseMessage LoadBoxScores(DateTime GameDate, string LeagueName)
      {
         new LoadBoxScores(LeagueName, GameDate).LoadTodaysRotation();

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }
   }
}
