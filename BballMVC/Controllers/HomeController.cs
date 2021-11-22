using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace BballMVC.Controllers
{
	public class HomeController : BaseController
	{
		public ActionResult Index()
		{
			return View();
		}

		public ActionResult About()
		{
         callMe();
			ViewBag.Message = "Your application description page.";
         Foo o = new Foo { AA = 1, BB = "bbb", CC = "keith" };
         StringBuilder sb = new StringBuilder("");
         string p = "?";
         foreach(var prop in o.GetType().GetProperties())
         {
            sb.Append(String.Format("{0}{1}={2}", p, prop.Name, prop.GetValue(o, null)));
            p = "&";
         }

			return View();
		}

      void callMe()
      {
         StackTrace stackTrace = new StackTrace();
         var x = stackTrace.GetFrame(1).GetMethod().Name;
         var xx = stackTrace.GetFrame(1).GetMethod();

      }
		public ActionResult Contact()
		{
			ViewBag.Message = "Your contact page.";

			return View();
		}
      class Foo
      {
         public int AA { get; set; }
         public string BB { get; set; }
         public string CC { get; set; }
      }
   }
}