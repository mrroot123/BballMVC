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
        private BballEntities1 db = new BballEntities1();

        // GET: Adjustments
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public JsonResult GetAdjustments(string LeagueName)
        {
            AdjustmentsBO oAdjustmentsBO = new AdjustmentsBO();
            List<AdjustmentDTO> ocAdjustmentDTO = oAdjustmentsBO.GetTodaysAdjustments(LeagueName);

            return Json(ocAdjustmentDTO, JsonRequestBehavior.AllowGet);
        }

        //Keith needs to revisit this
        [HttpPost]
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

        // GET: Adjustments/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Adjustments adjustments = db.Adjustments.Find(id);
            if (adjustments == null)
            {
                return HttpNotFound();
            }
            return View(adjustments);
        }

        // GET: Adjustments/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Adjustments/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "AdjustmentID,LeagueName,StartDate,EndDate,Team,AdjustmentType,AdjustmentAmount,Player,Description,TS")] Adjustments adjustments)
        {
            if (ModelState.IsValid)
            {
                db.Adjustments.Add(adjustments);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(adjustments);
        }

        // GET: Adjustments/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Adjustments adjustments = db.Adjustments.Find(id);
            if (adjustments == null)
            {
                return HttpNotFound();
            }
            return View(adjustments);
        }

        // POST: Adjustments/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "AdjustmentID,LeagueName,StartDate,EndDate,Team,AdjustmentType,AdjustmentAmount,Player,Description,TS")] Adjustments adjustments)
        {
            if (ModelState.IsValid)
            {
                db.Entry(adjustments).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(adjustments);
        }

        // GET: Adjustments/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Adjustments adjustments = db.Adjustments.Find(id);
            if (adjustments == null)
            {
                return HttpNotFound();
            }
            return View(adjustments);
        }

        // POST: Adjustments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Adjustments adjustments = db.Adjustments.Find(id);
            db.Adjustments.Remove(adjustments);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
