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
    public class RotationController : Controller
    {
      private Entities2 db = new Entities2();

      // GET: Rotation
      public ActionResult Index()
        {
            return View(db.Rotation.ToList());
        }

        // GET: Rotation/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Rotation rotation = db.Rotation.Find(id);
            if (rotation == null)
            {
                return HttpNotFound();
            }
            return View(rotation);
        }

        // GET: Rotation/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Rotation/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RotationID,LeagueName,GameDate,RotNum,Venue,Team,Opp,GameTime,TV,SideLine,TotalLine,TotalLineTeam,TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate,UpdateDate")] Rotation rotation)
        {
            if (ModelState.IsValid)
            {
                db.Rotation.Add(rotation);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(rotation);
        }

        // GET: Rotation/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Rotation rotation = db.Rotation.Find(id);
            if (rotation == null)
            {
                return HttpNotFound();
            }
            return View(rotation);
        }

        // POST: Rotation/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RotationID,LeagueName,GameDate,RotNum,Venue,Team,Opp,GameTime,TV,SideLine,TotalLine,TotalLineTeam,TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate,UpdateDate")] Rotation rotation)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rotation).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rotation);
        }

        // GET: Rotation/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Rotation rotation = db.Rotation.Find(id);
            if (rotation == null)
            {
                return HttpNotFound();
            }
            return View(rotation);
        }

        // POST: Rotation/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Rotation rotation = db.Rotation.Find(id);
            db.Rotation.Remove(rotation);
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
