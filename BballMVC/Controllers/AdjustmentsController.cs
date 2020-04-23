using System;
using System.Collections.Generic;
using System.Web.Mvc;

using BballMVC.DTOs;
using BballMVC.IDTOs;
//using Bball.BAL;
using Bball.IBAL;
using System.Reflection;

namespace BballMVC.Controllers
{
   public class AdjustmentsController : Controller
   {
      IAdjustmentsBO oAdjustmentsBO;

      public AdjustmentsController(IAdjustmentsBO oAdjustmentsBO)
      {
         this.oAdjustmentsBO = oAdjustmentsBO;
         
      }
      // GET: Adjustments
      public ActionResult Index() =>  View();

      [HttpGet]
      public JsonResult GetAdjustments(string LeagueName)

      {
         var x = this.Request.RawUrl;
         // AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         List<IDTOs.IAdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(LeagueName);

         return Json(ocAdjustmentDTO, JsonRequestBehavior.AllowGet);
      }

      [HttpGet]
      public JsonResult GetAdjustmentInfo(string LeagueName)
      {
         //AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         IAdjustmentInitDataDTO oAdjustmentInitDataDTO = oAdjustmentsBO.GetAdjustmentInfo(LeagueName);

         return Json(oAdjustmentInitDataDTO, JsonRequestBehavior.AllowGet);
      }

      [HttpPost] //  [ValidateAntiForgeryToken]
      public JsonResult PostInsertAdjustment(DTOs.AdjustmentDTO oAdjustmentDTO)
      {
         try
         {
            oAdjustmentsBO.InsertNewAdjustment(oAdjustmentDTO);
         }
         catch (Exception ex)
         {
            var msg = ex.Message;
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - Error Message: {msg}");
         }
         return Json(oAdjustmentsBO, JsonRequestBehavior.AllowGet);
      }

      [HttpPost]
      public JsonResult PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         var x = (IList<IAdjustmentDTO>)ocAdjustmentDTO;
         //AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         try
         {
            oAdjustmentsBO.UpdateAdjustments(x);
         }
         catch (Exception ex)
         {
            var msg = ex.Message;
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - Error Message: {msg}");
         }

         return Json("Success");

         //  return Json(new { success = true, responseText = "Your message successfuly sent!" }, JsonRequestBehavior.AllowGet);

      }

   }
}
