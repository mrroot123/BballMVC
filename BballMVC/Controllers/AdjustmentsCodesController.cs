using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using BballMVC.Models;

namespace BballMVC.Controllers
{
    public class AdjustmentsCodesController : Controller
    {
        private BballEntities1 db = new BballEntities1();

        // GET: AdjustmentsCodes
        public ActionResult Index()
        {
            return View(db.AdjustmentsCodes.ToList());
        }

        // GET: AdjustmentsCodes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AdjustmentsCodes adjustmentsCodes = db.AdjustmentsCodes.Find(id);
            if (adjustmentsCodes == null)
            {
                return HttpNotFound();
            }
            return View(adjustmentsCodes);
        }

        // GET: AdjustmentsCodes/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: AdjustmentsCodes/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "AdjustmentsCodesID,Type,Description,Range")] AdjustmentsCodes adjustmentsCodes)
        {
            if (ModelState.IsValid)
            {
                db.AdjustmentsCodes.Add(adjustmentsCodes);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(adjustmentsCodes);
        }

        // GET: AdjustmentsCodes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AdjustmentsCodes adjustmentsCodes = db.AdjustmentsCodes.Find(id);
            if (adjustmentsCodes == null)
            {
                return HttpNotFound();
            }
            return View(adjustmentsCodes);
        }

        // POST: AdjustmentsCodes/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "AdjustmentsCodesID,Type,Description,Range")] AdjustmentsCodes adjustmentsCodes)
        {
            if (ModelState.IsValid)
            {
                db.Entry(adjustmentsCodes).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(adjustmentsCodes);
        }

        // GET: AdjustmentsCodes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AdjustmentsCodes adjustmentsCodes = db.AdjustmentsCodes.Find(id);
            if (adjustmentsCodes == null)
            {
                return HttpNotFound();
            }
            return View(adjustmentsCodes);
        }

        // POST: AdjustmentsCodes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            AdjustmentsCodes adjustmentsCodes = db.AdjustmentsCodes.Find(id);
            db.AdjustmentsCodes.Remove(adjustmentsCodes);
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