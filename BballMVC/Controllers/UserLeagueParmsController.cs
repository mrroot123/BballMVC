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
    public class UserLeagueParmsController : Controller
    {
        private Entities2 db = new Entities2();

      // GET: UserLeagueParms
      public ActionResult IndexAll()
      {
         var x = db.UserLeagueParms.ToList();
         return View(x);
      }
      public ActionResult Index()
      {
         var LeagueName = "NBA";

         UserLeagueParms userLeagueParms =
            db.UserLeagueParms.SqlQuery(
               $"SELECT TOP (1) *  FROM UserLeagueParms  Where LeagueName = '{LeagueName}'  Order by StartDate desc")
               .FirstOrDefault<UserLeagueParms>();

         var x = new List<UserLeagueParms>();
         x.Add(userLeagueParms);
         return View(x);
      }

      // GET: UserLeagueParms/Details/5
      public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserLeagueParms userLeagueParms = db.UserLeagueParms.Find(id);
            if (userLeagueParms == null)
            {
                return HttpNotFound();
            }
            return View(userLeagueParms);
        }

        // GET: UserLeagueParms/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: UserLeagueParms/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "UserLeagueParmsID,UserName,LeagueName,StartDate,LgAvgStartDate,LgAvgGamesBack,TeamAvgGamesBack,TeamPaceGamesBack,TeamSeedGames,LoadRotationDaysAhead,GB1,GB2,GB3,WeightGB1,WeightGB2,WeightGB3,Threshold,BxScLinePct,BxScTmStrPct,TmStrAdjPct,RecentLgHistoryAdjPct,BothHome_Away,BoxscoresSpanSeasons")] UserLeagueParms userLeagueParms)
        {
            if (ModelState.IsValid)
            {
                db.UserLeagueParms.Add(userLeagueParms);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(userLeagueParms);
        }

        // GET: UserLeagueParms/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserLeagueParms userLeagueParms = db.UserLeagueParms.Find(id);
            if (userLeagueParms == null)
            {
                return HttpNotFound();
            }
            return View(userLeagueParms);
        }

        // POST: UserLeagueParms/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = 
           "UserLeagueParmsID,UserName,LeagueName,StartDate,LgAvgStartDate,LgAvgGamesBack,TeamAvgGamesBack,TeamPaceGamesBack,TeamSeedGames,LoadRotationDaysAhead,GB1,GB2,GB3,WeightGB1,WeightGB2,WeightGB3,Threshold,BxScLinePct,BxScTmStrPct,TmStrAdjPct,RecentLgHistoryAdjPct,BothHome_Away,BoxscoresSpanSeasons")]
               UserLeagueParms userLeagueParms)
        {
            if (ModelState.IsValid)
            {
                db.Entry(userLeagueParms).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(userLeagueParms);
        }

        // GET: UserLeagueParms/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserLeagueParms userLeagueParms = db.UserLeagueParms.Find(id);
            if (userLeagueParms == null)
            {
                return HttpNotFound();
            }
            return View(userLeagueParms);
        }

        // POST: UserLeagueParms/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            UserLeagueParms userLeagueParms = db.UserLeagueParms.Find(id);
            db.UserLeagueParms.Remove(userLeagueParms);
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
