using BballMVC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BballMVC.Controllers
{
   public class BaseController : Controller
   {
     
      public Entities2 db { get; set; }
      // GET: Base
      public BaseController()
         {
         string EFname = System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"\HostingSpaces\") >= 0 ? "name=Arvixe" : "name=Entities2";
         db = new Entities2(getConnection());
      }
      string getConnection()
      {
         // If name="Override" exists in web.config
         //   THEN use it
         string con = System.Configuration.ConfigurationManager.ConnectionStrings["Override"].ConnectionString;
         if (con != "null")
            return "name=SmarterAsp";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"T:\BballMVC") >= 0)
            return "name=Entities2";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"\HostingSpaces\") >= 0)
            return "name=Arvixe";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"Test\mrroot123\mrroot123") >= 0)
            return "name=Entities2";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"\theroot-") >= 0)
            return "name=SmarterAsp";

         return "name=SmarterAsp";

      }

   }
}