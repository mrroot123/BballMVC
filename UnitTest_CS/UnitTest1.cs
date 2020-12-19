using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using System.Collections.Generic;

using BballMVC.DTOs;
//using Bball.VbClasses.Bball.VbClasses;

using Bball.DAL;
using Bball.DAL.Tables;
using Bball.DataBaseFunctions;


namespace UnitTest_CS
{
  // [TestClass]
   public class UnitTest1
   {
      [TestMethod]
      public void TestMethod1()
      {
         Assert.AreEqual(1, 1);
         Assert.AreNotEqual(1, 1);
      }
   }  // default class

   //[TestClass]
   public class UnitTest_DailySummary
   {
     LeagueDTO _oLeagueDTO;

      string _ConnectionString = SqlFunctions.GetConnectionString();
      DateTime _GameDate;
      string _strLoadDateTime  = DateTime.Today.AddDays(-2).ToString();


      [TestMethod]
      public void Test_DailySummary_GetRow()
      {
         // 1) Arrange
         string LeagueName = "NBA";
         DateTime GameDate = DateTime.Today.AddDays(-2);
         initAll(GameDate, LeagueName);

       //  SeasonInfoDTO oSeasonInfoDTO = new SeasonInfoDTO();
         SeasonInfoDO oSeasonInfo = new SeasonInfoDO(_GameDate, _oLeagueDTO.LeagueName);
        // oSeasonInfo.PopulateSeasonInfoDTO(oSeasonInfoDTO);
         if (oSeasonInfo.oSeasonInfoDTO.Bypass) return;

         // 2) Act
         DailySummaryDTO oDailySummaryDTO = new DailySummaryDTO();
         DailySummaryDO oDailySummary = new DailySummaryDO(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime);
         oDailySummary.RefreshRow(5);
         int rows = oDailySummary.GetRow(oDailySummaryDTO);

         // 3) Assert
         Assert.AreEqual(1, rows);

      }
      void initAll(DateTime GameDate, string LeagueName)
      {
         _GameDate = GameDate;
         _strLoadDateTime = GameDate.ToString();
      //   _oLeagueDTO = LeagueInfo.LeagueInfoGetByLeagueName(LeagueName);

      }
   }  // default class

}  // namespace
