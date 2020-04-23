﻿using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Http;
using WebApplication;
using Bball.Unity;


namespace BballMVC
{
   public class MvcApplication : System.Web.HttpApplication
	{
		protected void Application_Start()
		{
         Bball.Unity.UnityConfig.RegisterTypes();
         var x = UnityConfig.Container;
			AreaRegistration.RegisterAllAreas();
			FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
         GlobalConfiguration.Configure(WebApiConfig.Register);
         RouteConfig.RegisterRoutes(RouteTable.Routes);
			BundleConfig.RegisterBundles(BundleTable.Bundles);
		}
	}
}
