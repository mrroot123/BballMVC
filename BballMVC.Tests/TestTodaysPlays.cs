

using Bball.BAL;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Collections.Generic;
using System;

using NUnit.Framework;

namespace BballMVC.Tests
{
/*
attributes
SetUp - init method
TearDown - last method
 *  */ 
   [TestFixture]
   public class TestTodaysPlays
   {
      const string SqlServerConnectionStringLOCAL =
          @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";

      const string _LeagueName = "NBA";

      BballInfoDTO oBballInfoDTO = new BballInfoDTO()
         { LeagueName = _LeagueName, GameDate = DateTime.Today, ConnectionString = SqlServerConnectionStringLOCAL };
      List<TodaysPlaysResults> ocTodaysPlaysResults = new List<TodaysPlaysResults>();

      IList<ITodaysPlaysDTO> ocTodaysPlays = null;
      List<SortedList<string, CoversDTO>> ocRotations = new List<SortedList<string, CoversDTO>>(); // = null;

      [Category("RunOnlyThis")]
      [Test]
      public void Test_InProgress()
      {
         // 1) Arrange
         populate_InProgressData();
 
         // 2) Act
         TodaysPlaysBO oTodaysPlaysBO = new TodaysPlaysBO(oBballInfoDTO, ocTodaysPlaysResults, ocTodaysPlays, ocRotations);

         // 3) Assert
         Assert.AreEqual(1, ocTodaysPlaysResults.Count);
         Assert.AreEqual("Ov 1", ocTodaysPlaysResults[0].OvUnStatus);

      }
      void populate_InProgressData()
      {
         CoversDTO oCoversDTO = initCoversDTO();
         oCoversDTO.RotNum = 533;

         oCoversDTO.GameStatus = 1; // InProgress
         oCoversDTO.ScoreAway = 50;
         oCoversDTO.ScoreHome = 68;
         oCoversDTO.Period = 2;
         oCoversDTO.SecondsLeftInPeriod = 0;

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         ocRotation.Add(oCoversDTO.RotNum.ToString(), oCoversDTO);

         ocRotations.Add(ocRotation);

      }

      CoversDTO initCoversDTO()
         => new CoversDTO()  {LeagueName = _LeagueName,  GameDate = DateTime.Today,  GameTime = "7:05" };
      

   }

}
