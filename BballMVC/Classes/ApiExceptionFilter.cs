using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http.ExceptionHandling;
using System.Web.Http.Filters;
using System.Web.Http.Results;
using BballMVC.Log;

namespace BballMVC.Classes
{
   public class ApiExceptionFilter : ExceptionFilterAttribute
   {

      public override void OnException(HttpActionExecutedContext context)
      {
         var exception = context.Exception as Exception;
         if (exception != null)
         {
            var x = context.ActionContext.ControllerContext.Controller as System.Web.Http.ApiController;
            var y = x.ToString();
            
            Helper.LogMessage(context);
            context.Response = context.Request.CreateErrorResponse( System.Net.HttpStatusCode.BadRequest, exception.Message);
          
         }
      }

   }
}