using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Bball.BAL;
using Bball.IBAL;

using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace BballMVC.ControllerAPIs
{
   public class AdjustmentsController : ApiController
   {
      IAdjustmentsBO oAdjustmentsBO;
    //  IAdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();

      public AdjustmentsController()
      {
         oAdjustmentsBO = new AdjustmentsBO();
      }

      [HttpPost]
      public HttpResponseMessage PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         var a = new AdjustmentDTO { AdjustmentAmount = 2, AdjustmentID = 1 };
         var b =  Request.RequestUri.GetLeftPart(System.UriPartial.Authority);
         IList <IAdjustmentDTO> aa = new List<IAdjustmentDTO>();
         foreach (AdjustmentDTO adj in ocAdjustmentDTO)
         {
            aa.Add(adj);
         }
       //  IList<IAdjustmentDTO> x = (IList<IAdjustmentDTO>) ocAdjustmentDTO;
         oAdjustmentsBO.UpdateAdjustments(aa);

         return Request.CreateResponse(HttpStatusCode.OK, "Success");
      }

      [HttpGet]
      public HttpResponseMessage GetAdjustmentInfo(string LeagueName)
      {
         
         IAdjustmentInitDataDTO oAdjustmentInitDataDTO = oAdjustmentsBO.GetAdjustmentInfo(LeagueName);

         return Request.CreateResponse(HttpStatusCode.OK, oAdjustmentInitDataDTO);
      }

   }
}