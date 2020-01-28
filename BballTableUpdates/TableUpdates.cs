using System;
using Bball.BAL;

namespace BballTableUpdates
{
   class TableUpdates
   {
      static void Main(string[] args)
      {  
         DateTime StartGameDate = Convert.ToDateTime("10/22/2019");
         LoadBoxScores l = new LoadBoxScores("NBA", DateTime.Now.ToString(), StartGameDate);
         l.LoadBoxScoreRange();  

       }
   }
}
