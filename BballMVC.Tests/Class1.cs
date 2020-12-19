using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BballMVC.DTOs;

using NUnit.Framework;

using Bball.DAL.Parsing;



namespace BballMVC.Tests
{
   [TestFixture]
   public class Class1
   {
      [Test]
      public void Test1()
      {
         // 1) Arrange
         const string abc = nameof(abc);
    
         var n = 01;
         // 2) Act
         n++;

         // 3) Assert
         Assert.AreNotEqual(n , 1);
      }
      [Test]
      public void Test2()
      {
         Assert.That(1 == 1);
      }
   }

   [TestFixture]
   public class Class_Test_BoxScoresLast5Min
   {
      [Test]
      public void Test_BuildBoxScoresLast5MinUrl()
      {
         // 1) Arrange
         BoxScoresLast5MinDTO oLast5MinDTO = new BoxScoresLast5MinDTO()
         {
            GameDate = DateTime.Parse("10/06/2020"),
            LeagueName = "NBA",
            Source = "BasketballReference", 
            Team = "BOS"
         };
         const string urlExpected = "https://www.basketball-reference.com/boxscores/pbp/202010060BOS.html";
 
         // 2) Act
         var url = BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTO);

         // 3) Assert
         Assert.AreEqual(urlExpected , url);
      }
      int n;
      [Test]
      [SetUp]
      public void TestSetup()
      {
         n = 0;
      }   
      [TestCase(2,3,6)]
      [TestCase(2, 2, 4)]
      public void Test3(int n1, int n2, int expectedResult)
      {
         n = multiplyNums(n1, n2);
         Assert.AreEqual(expectedResult, n);
      }
      int multiplyNums(int n1, int n2) =>  n1 * n2;   

   }
}
