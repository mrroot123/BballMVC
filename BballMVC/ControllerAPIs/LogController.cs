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
using BballMVC.Log;


namespace BballMVC.ControllerAPIs
{
   public class LogController : BaseApiController
   {
      const string TTILogTable = "TTILog";
      // localhost:60679/api/Log/LogMessage
      [HttpPost]
      public HttpResponseMessage LogMessage(TTILogMessage oTTILogMessage)
      {
         var rc = Helper.LogMessage(oTTILogMessage, oBballInfoDTO.ConnectionString, TTILogTable);
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
