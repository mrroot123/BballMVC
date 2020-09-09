using System.Net;
using System.Net.Http;
using System.Reflection.Emit;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.ExceptionHandling;
/*
// https://stackoverflow.com/questions/21901808/need-a-complete-sample-to-handle-unhandled-exceptions-using-exceptionhandler-i

   In your WebApi config your need to add the line:
      config.Services.Replace(typeof (IExceptionHandler), new OopsExceptionHandler());
*/
namespace BballMVC.Classes
{
   public class ApiGlobalExceptionHandler : System.Web.Http.ExceptionHandling.ExceptionHandler
   {  
      // https://docs.microsoft.com/en-us/aspnet/web-api/overview/error-handling/web-api-global-error-handling
      //public override void HandleCore(ExceptionHandlerContext context)
      public override void Handle(ExceptionHandlerContext context)
      {
         context.Result = new TextPlainErrorResult
         {
            Request = context.ExceptionContext.Request,
            Content = "Pizza Down! We have an Error! Please call the parlor to complete your order."
         };
      }

      private class TextPlainErrorResult : IHttpActionResult
      {
         public HttpRequestMessage Request { get; set; }
         public string Content { get; set; }

         public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
         {
            HttpResponseMessage response =
                new HttpResponseMessage(HttpStatusCode.InternalServerError);
            response.Content = new StringContent(Content);
            response.RequestMessage = Request;
            return Task.FromResult(response);
         }
      }
   }
}