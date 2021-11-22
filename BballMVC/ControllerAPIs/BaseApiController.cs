using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using TTI.Logger;
using SysDAL.Functions;


namespace BballMVC.ControllerAPIs
{
   public class BaseApiController : ApiController
   {
      public IBballInfoDTO oBballInfoDTO { get; set; }

      public string BaseDir { get; set; }
      const string LogName = "TTILog";
      protected Stopwatch stopwatch = new Stopwatch();
      public BaseApiController()
      {
         stopwatch.Start();
         BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;
         oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.ConnectionString = DALfunctions.GetConnectionString();
         oBballInfoDTO.BaseDirectory = System.AppDomain.CurrentDomain.BaseDirectory;
         oBballInfoDTO.LogName = LogName;
         // oBballInfoDTO.oBballDataDTO.BaseDir = BaseDir;  kdtodo delete all BaseDir references
         oBballInfoDTO.TS = GetNowEst();

      }
      protected DateTime GetNowEst()
      {
         var timeUtc = DateTime.UtcNow;
         TimeZoneInfo easternZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
         return TimeZoneInfo.ConvertTimeFromUtc(timeUtc, easternZone);
      }
      protected string GetUser()
      {
         return "Test";
      }

   }
}

