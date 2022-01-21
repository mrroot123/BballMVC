using System;
//using Microsoft.VisualStudio.TestTools.UnitTesting;

using System.Collections.Generic;

using BballMVC.DTOs;
using BballMVC.IDTOs;
//using Bball.VbClasses.Bball.VbClasses;

using Bball.DAL;
using Bball.DAL.Tables;
using Bball.DataBaseFunctions;
//using Newtonsoft.Json.Linq;
using NUnit.Framework;
using SysDAL.Functions;
using StringExtensionMethods;

namespace UnitTest_CS
{
   // [TestFixture]
   public class UnitTest1
   {
      [Test]
      public void TestOr()
      {
         var expected = true;
         var x = "a";
        
         var result = x.Or( "b", "c", "a");
         Assert.AreEqual(expected, result);
      }

      //[Test]
      //public void TestMethod1b)
      //{
      //   int i = 1;
      //   Assert.AreEqual(i, 2);
      //   //Assert.AreNotEqual(1, 1);
      //}
   }  // default class

 //  [TestFixture]
   //public class UnitTest_SQL
   //{
   //   [Test]
   //   public void Test_ExecuteDynamicSqlQuery()
   //   {
   //      string ConnectionString = DALfunctions.GetConnectionString();
   //      string strSql = "SELECT top 3 * FROM UserLeagueParms Where LeagueName = 'nba'   order by StartDate desc";
   //      List<JObject> ocJObject = new List<JObject>();
   //      SysDAL.Functions.DALfunctions.ExecuteDynamicSqlQuery(ConnectionString, strSql, ocJObject);
   //      var x = ocJObject.ToString();
   //      int i = 1;
   //     // var y = ocJObject.CopyTo.ToString();
   //      Assert.AreEqual(i, 1);
   //     // Assert.AreNotEqual(1, 1);
   //   }
   //}  // default class

   //[TestClass]
   public class UnitTest_DailySummary
   {
     LeagueDTO _oLeagueDTO;

      const string _ConnectionString =
         @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";

      DateTime _GameDate;
      string _strLoadDateTime  = DateTime.Today.AddDays(-2).ToString();


      [Test]
      public void Test_GetUserLeagueParmsJson()
      {
        
         // 1) Arrange
         string UserName = "Test";
         string LeagueName = "NBA";
         DateTime GameDate = DateTime.Today;    //.AddDays(-2);
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
         {
            ConnectionString = _ConnectionString,
            LeagueName = LeagueName,
            GameDate = GameDate,
            UserName = UserName
         };

         DataDO oDataDO = new DataDO();
         oDataDO.GetUserLeagueParmsJson(oBballInfoDTO);


         // 2) Act
         DailySummaryDTO oDailySummaryDTO = new DailySummaryDTO();
         // DailySummaryDO oDailySummary = new DailySummaryDO(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime, UserName);
         //oDailySummary.RefreshRow(5);
         //int rows = oDailySummary.GetRow(oDailySummaryDTO);

         // 3) Assert
         // Assert.AreEqual(1, rows);

      }
      //[Test]
      //public void Test_DailySummary_GetRow()
      //{
      //   // 12/26/2020 - DailySummaryDO was decommissioned to DataDO - so this test is ng
      //   // 1) Arrange
      //   string UserName = "Test";
      //   string LeagueName = "NBA";
      //   DateTime GameDate = DateTime.Today.AddDays(-2);
      //   initAll(GameDate, LeagueName);

      // //  SeasonInfoDTO oSeasonInfoDTO = new SeasonInfoDTO();
      //   SeasonInfoDO oSeasonInfo = new SeasonInfoDO(_GameDate, _oLeagueDTO.LeagueName);
      //  // oSeasonInfo.PopulateSeasonInfoDTO(oSeasonInfoDTO);
      //   if (oSeasonInfo.oSeasonInfoDTO.Bypass) return;

      //   // 2) Act
      //   DailySummaryDTO oDailySummaryDTO = new DailySummaryDTO();
      //  // DailySummaryDO oDailySummary = new DailySummaryDO(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime, UserName);
      //   //oDailySummary.RefreshRow(5);
      //   //int rows = oDailySummary.GetRow(oDailySummaryDTO);

      //   // 3) Assert
      //  // Assert.AreEqual(1, rows);

      //}
      void initAll(DateTime GameDate, string LeagueName)
      {
         _GameDate = GameDate;
         _strLoadDateTime = GameDate.ToString();
      //   _oLeagueDTO = LeagueInfo.LeagueInfoGetByLeagueName(LeagueName);

      }
   }  // default class

}  // namespace
