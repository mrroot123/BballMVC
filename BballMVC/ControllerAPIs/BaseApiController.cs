using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace BballMVC.ControllerAPIs
{
   public class BaseApiController : ApiController
   {
      public IBballInfoDTO oBballInfoDTO { get; set; }

      public string BaseDir { get; set; }
      const string LogName = "TTILog";
      public BaseApiController()
      {
         BaseDir = System.AppDomain.CurrentDomain.BaseDirectory;
         oBballInfoDTO = new BballInfoDTO();
         oBballInfoDTO.ConnectionString = GetConnectionString();
         oBballInfoDTO.LogName = LogName;
      }
      protected string GetUser()
      {
         return "Test";
      }
      protected string GetConnectionString()
      {
         const string SqlServerConnectionStringLOCAL =
            @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";

         const string SqlServerConnectionStringARVIXE =
            @"Data Source=Localhost\;     Initial Catalog=00TTI_LeagueScores;Integrated Security=false;User ID=theroot;Password=788788kd";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"\HostingSpaces\") >= 0)
            return SqlServerConnectionStringARVIXE;

         return SqlServerConnectionStringLOCAL;
      }
   }
}

