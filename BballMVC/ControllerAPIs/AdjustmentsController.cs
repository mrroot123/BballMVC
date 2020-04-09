using BballMVC.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Bball.BAL;

namespace BballMVC.ControllerAPIs
{
   public class AdjustmentsController : ApiController
   {
      [HttpPost]
      public HttpResponseMessage PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
 
         AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         oAdjustmentsBO.UpdateAdjustments(ocAdjustmentDTO);
         return Request.CreateResponse(HttpStatusCode.OK, "Success");

         //  return Json(new { success = true, responseText = "Your message successfuly sent!" }, JsonRequestBehavior.AllowGet);

      }

      // GET api/<controller>
      public IEnumerable<string> Get()
      {
         return new string[] { "value1", "value2" };
      }

      // GET api/<controller>/5
      public string Get(int id)
      {
         return "value";
      }

      // POST api/<controller>
      public void Post([FromBody]string value)
      {
      }

      // PUT api/<controller>/5
      public void Put(int id, [FromBody]string value)
      {
      }

      // DELETE api/<controller>/5
      public void Delete(int id)
      {
      }
   }
}