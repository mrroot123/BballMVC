using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using BballMVC.Models;
using BballMVC.DTOs;
using Bball.BAL;

namespace BballMVC.Controllers
{
   public class AdjustmentsController : Controller
   {
      // GET: Adjustments
      public ActionResult Index() =>  View();

      [HttpGet]
      public JsonResult GetAdjustments(string LeagueName)
      {
         AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         List<AdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(LeagueName);

         return Json(ocAdjustmentDTO, JsonRequestBehavior.AllowGet);
      }

      [HttpGet]
      public JsonResult GetAdjustmentInfo(string LeagueName)
      {
         AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         AdjustmentInitDataDTO oAdjustmentInitDataDTO = oAdjustmentsBO.GetAdjustmentInfo(LeagueName);

         return Json(oAdjustmentInitDataDTO, JsonRequestBehavior.AllowGet);
      }

      [HttpPost] //  [ValidateAntiForgeryToken]
      public JsonResult PostInsertAdjustment(AdjustmentDTO oAdjustmentDTO)
      {
         AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         oAdjustmentsBO.InsertNewAdjustment(oAdjustmentDTO);

         return Json(oAdjustmentsBO, JsonRequestBehavior.AllowGet);
      }

      [HttpPost]
      public JsonResult PostProcessUpdates(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
         oAdjustmentsBO.UpdateAdjustments(ocAdjustmentDTO);
         return Json("Success");

         //  return Json(new { success = true, responseText = "Your message successfuly sent!" }, JsonRequestBehavior.AllowGet);

      }

   }
}
