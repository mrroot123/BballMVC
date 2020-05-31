using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace BballMVC.ControllerAPIs
{
   public class BaseApiController : ApiController
   {
      protected string GetUser()
      {
         return "Test";
      }
      protected string GetConnectionString()
      {
         return @"Data Source=Localhost\SQLEXPRESS2012;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
      }
   }
}
