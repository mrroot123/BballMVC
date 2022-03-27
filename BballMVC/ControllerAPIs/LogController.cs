using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Web.Http;

//using Bball.BAL;
using Bball.IBAL;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using TTI.Logger;


namespace BballMVC.ControllerAPIs
{
   public class LogController : BaseApiController
   {
      
      // localhost:60679/api/Log/LogMessage
      [HttpPost]
      public HttpResponseMessage LogMessage(TTILogMessage oTTILogMessage)
      {
         oTTILogMessage.TS = oBballInfoDTO.TS;
         var rc = Helper.LogMessage(oTTILogMessage, oBballInfoDTO.ConnectionString, oBballInfoDTO.LogName);
         return Request.CreateResponse(HttpStatusCode.OK, rc);
      }
      [HttpGet]
      public HttpResponseMessage GetMessage(string s)
      {
         s += System.AppDomain.CurrentDomain.BaseDirectory + " / " + oBballInfoDTO.ConnectionString;
         return Request.CreateResponse(HttpStatusCode.OK, s);
      }

   }
}
