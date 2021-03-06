﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using BballMVC.Models;
using BballMVC.Controllers;

namespace BballMVC.Controllers
{
    public class ParmTablesController : Controller
    {
        private BballEntities1 db = new BballEntities1();

        // GET: ParmTables
        public ActionResult Index()
        {
            return View(db.ParmTables.ToList());
        }

        // GET: ParmTables/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ParmTable parmTable = db.ParmTables.Find(id);
            if (parmTable == null)
            {
                return HttpNotFound();
            }
            return View(parmTable);
        }

        // GET: ParmTables/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: ParmTables/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ParmTableID,ParmName,ParmValue,DotNetType,Description,Scope,CreateUser,CreateDate,UpdateUser,UpdateDate")] ParmTable parmTable)
        {
            if (ModelState.IsValid)
            {
                db.ParmTables.Add(parmTable);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(parmTable);
        }

        // GET: ParmTables/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ParmTable parmTable = db.ParmTables.Find(id);
            if (parmTable == null)
            {
                return HttpNotFound();
            }
            return View(parmTable);
        }

        // POST: ParmTables/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ParmTableID,ParmName,ParmValue,DotNetType,Description,Scope,CreateUser,CreateDate,UpdateUser,UpdateDate")] ParmTable parmTable)
        {
            if (ModelState.IsValid)
            {
                db.Entry(parmTable).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(parmTable);
        }

        // GET: ParmTables/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ParmTable parmTable = db.ParmTables.Find(id);
            if (parmTable == null)
            {
                return HttpNotFound();
            }
            return View(parmTable);
        }

        // POST: ParmTables/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            ParmTable parmTable = db.ParmTables.Find(id);
            db.ParmTables.Remove(parmTable);
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
