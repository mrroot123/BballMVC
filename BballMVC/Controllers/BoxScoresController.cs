using System;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web.Mvc;
using BballMVC.Models;
using Bball.BAL;

namespace BballMVC.Controllers
{
   public class BoxScoresController : Controller
   {
      private Entities2 db = new Entities2();



      // GET: BoxScore
      public ActionResult Index()
      {
         return View(db.BoxScores.ToList());
      }

      // GET: BoxScore/Details/5
      public ActionResult Details(int? id)
      {
         if (id == null)
         {
               return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
         }
         BoxScore boxScores = db.BoxScores.Find(id);
         if (boxScores == null)
         {
               return HttpNotFound();
         }
         return View(boxScores);
      }

      // GET: BoxScore/Create
      public ActionResult Create()
      {
         return View();
      }

      // POST: BoxScore/Create
      // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
      // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
      [HttpPost]
      [ValidateAntiForgeryToken]
      public ActionResult Create([Bind(Include = "BoxScoresID,Exclude,LeagueName,GameDate,RotNum,Team,Opp,Venue,GameTime,Season,SubSeason,MinutesPlayed,OtPeriods,ScoreReg,ScoreOT,ScoreRegUs,ScoreRegOp,ScoreOTUs,ScoreOTOp,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp,Source,LoadDate,LoadTimeSeconds")] BoxScore boxScores)
      {
         if (ModelState.IsValid)
         {
               db.BoxScores.Add(boxScores);
               db.SaveChanges();
               return RedirectToAction("Index");
         }

         return View(boxScores);
      }

      // GET: BoxScore/Edit/5
      public ActionResult Edit(int? id)
      {
         if (id == null)
         {
               return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
         }
         BoxScore boxScores = db.BoxScores.Find(id);
         if (boxScores == null)
         {
               return HttpNotFound();
         }
         return View(boxScores);
      }

      // POST: BoxScore/Edit/5
      // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
      // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
      [HttpPost]
      [ValidateAntiForgeryToken]
      public ActionResult Edit([Bind(Include = "BoxScoresID,Exclude,LeagueName,GameDate,RotNum,Team,Opp,Venue,GameTime,Season,SubSeason,MinutesPlayed,OtPeriods,ScoreReg,ScoreOT,ScoreRegUs,ScoreRegOp,ScoreOTUs,ScoreOTOp,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp,Source,LoadDate,LoadTimeSeconds")] BoxScore boxScores)
      {
         if (ModelState.IsValid)
         {
               db.Entry(boxScores).State = EntityState.Modified;
               db.SaveChanges();
               return RedirectToAction("Index");
         }
         return View(boxScores);
      }

      // GET: BoxScore/Delete/5
      public ActionResult Delete(int? id)
      {
         if (id == null)
         {
               return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
         }
         BoxScore boxScores = db.BoxScores.Find(id);
         if (boxScores == null)
         {
               return HttpNotFound();
         }
         return View(boxScores);
      }

      // POST: BoxScore/Delete/5
      [HttpPost, ActionName("Delete")]
      [ValidateAntiForgeryToken]
      public ActionResult DeleteConfirmed(int id)
      {
         BoxScore boxScores = db.BoxScores.Find(id);
         db.BoxScores.Remove(boxScores);
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
