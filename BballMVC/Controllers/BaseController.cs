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
         db = new Entities2(EFname);
      }
   }
}