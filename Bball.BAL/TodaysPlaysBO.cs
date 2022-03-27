using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.VbClasses.Bball.VbClasses;
using Bball.DAL.Functions;

namespace Bball.BAL
{
   public class TodaysPlaysBO
   {
      #region constructors
      // Prod
      public TodaysPlaysBO(IBballInfoDTO oBballInfoDTO, List<TodaysPlaysResults> ocTodaysPlaysResults)
      {

         IList<ITodaysPlaysDTO> ocTodaysPlays = new List<ITodaysPlaysDTO>();
         getTodaysPlays(oBballInfoDTO, ocTodaysPlays);

         CalcTodaysPlays(oBballInfoDTO, ocTodaysPlaysResults, ocTodaysPlays);
      }

      // Inject ocTodaysPlays, CoversDTO>> ocRotations for Testing
      public TodaysPlaysBO(IBballInfoDTO oBballInfoDTO, List<TodaysPlaysResults> ocTodaysPlaysResults
               , IList<ITodaysPlaysDTO> ocTodaysPlays, List<SortedList<string, CoversDTO>> ocRotations)
      {
         if (ocTodaysPlays == null)
         {
            ocTodaysPlays = new List<ITodaysPlaysDTO>();
            getTodaysPlays(oBballInfoDTO, ocTodaysPlays);
         }

         CalcTodaysPlays(oBballInfoDTO, ocTodaysPlaysResults, ocTodaysPlays);
      }
      #endregion constructors

//      public void CalcTodaysPlays(IBballInfoDTO oBballInfoDTO, List<TodaysPlaysResults> ocTodaysPlaysResults
      private void CalcTodaysPlays(IBballInfoDTO oBballInfoDTO, List<TodaysPlaysResults> ocTodaysPlaysResults, IList<ITodaysPlaysDTO> ocTodaysPlays)
      {
         if (ocTodaysPlays.Count == 0)
            return;

         #region defineLocals
         TodaysPlaysResults oTodaysPlaysResults = null;
         ITodaysPlaysDTO oTodaysPlays = null;
         SortedList<string, CoversDTO> ocRotation = null;
         CoversDTO oCoversDTO = null;
         oBballInfoDTO.LeagueName = "";
         oBballInfoDTO.GameDate = new DateTime();
         LeagueDTO oLeagueDTO = null;
         int? ScoreAway = 0;
         int? ScoreHome = 0;
         int GameStatus;
         #endregion defineLocals

         foreach (var oTP in ocTodaysPlays)
         {
            oTodaysPlays = oTP;
            if (oTodaysPlays.GameDate < DateTime.Today && oTodaysPlays.ScoreAway != null) // Previous Plays
            {
               ScoreAway = oTodaysPlays.ScoreAway; // kdtodo get scores from SP for Qtrs?
               ScoreHome = oTodaysPlays.ScoreHome;
               GameStatus = (int)CoversRotation.GameStatus.Final;
            }
            else
            { 
               if (oTodaysPlays.LeagueName != oBballInfoDTO.LeagueName || oTodaysPlays.GameDate != oBballInfoDTO.GameDate)
               {
                  oBballInfoDTO.LeagueName = oTodaysPlays.LeagueName;
                  oBballInfoDTO.GameDate = oTodaysPlays.GameDate;
                  oLeagueDTO = new LeagueDTO();
                  new LeagueInfoDO(oTodaysPlays.LeagueName, oLeagueDTO, oBballInfoDTO.ConnectionString, oTodaysPlays.GameDate);  // Init _oLeagueDTO
                  ocRotation = new SortedList<string, CoversDTO>();
                  getRotation(ocRotation, oBballInfoDTO, oLeagueDTO);

               }
               oCoversDTO = ocRotation[oTodaysPlays.RotNum.ToString()];
               ScoreAway = oCoversDTO.ScoreAway;
               ScoreHome = oCoversDTO.ScoreHome;
               GameStatus = oCoversDTO.GameStatus;
            }
            //          Columns           
            // Row  1     2      3    4     5         6
            //     Rot # Teams Line Score Status   Info
            //  1  Rot#  TmAw  Un/Ov ScAw  Time    UnOvStatus
            //  2  Time  TmHm  Line  ScHm Current
            // Populate common TodaysPlaysResults props
            oTodaysPlaysResults = new TodaysPlaysResults();
            oTodaysPlaysResults.LeagueName = oTodaysPlays.LeagueName;
            oTodaysPlaysResults.RotNum = oTodaysPlays.RotNum;
            oTodaysPlaysResults.GameDate = oTodaysPlays.GameDate.ToShortDateString();
            oTodaysPlaysResults.GameTime = oTodaysPlays.GameTime.ToString().Substring(0, 5);
            oTodaysPlaysResults.TeamAway = oTodaysPlays.TeamAway;
            oTodaysPlaysResults.TeamHome = oTodaysPlays.TeamHome;
            oTodaysPlaysResults.PlayDirection = oTodaysPlays.PlayDirection;
            oTodaysPlaysResults.Line = oTodaysPlays.Line;
            oTodaysPlaysResults.Score = (double)(ScoreAway + ScoreHome);
            oTodaysPlaysResults.ScoreAway = (double)ScoreAway;
            oTodaysPlaysResults.ScoreHome = (double)ScoreHome;
            oTodaysPlaysResults.Info = oTodaysPlays.Info;
            oTodaysPlaysResults.Result = 0;

            switch (GameStatus)
            {
               case (int)CoversRotation.GameStatus.InProgress:
               {
                  calcInProgress();
                  break;
               }
               case (int)CoversRotation.GameStatus.Final:
               {
                  calcFinal();
                  break;
               };
               case (int)CoversRotation.GameStatus.NotStarted:
               {
                  calcNotStarted();
                  break;
               }
               case (int)CoversRotation.GameStatus.Canceled:
               {
                  calcCanceled();
                  break;
               }
            }  // switch
            ocTodaysPlaysResults.Add(oTodaysPlaysResults);
         }  // Foreach
         

         #region localMethods
         void calcInProgress()
         {
            double minsPerGame = (double)(oLeagueDTO.MinutesPerPeriod * oLeagueDTO.Periods);
            double ptsPerMinute = oTodaysPlays.Line / minsPerGame;

            int periodsLeft = oLeagueDTO.Periods - oCoversDTO.Period;
            periodsLeft = periodsLeft < 0 ? 0 : periodsLeft;   // If in OT, make zero
            // =(gsPeriodsLeft*gsMinsPerPeriod)+gsMins+ csSecs/60
            double minsLeft = (double)(periodsLeft * oLeagueDTO.MinutesPerPeriod)
                            + ((double)oCoversDTO.SecondsLeftInPeriod / 60.0);
            double gamePace = (double)(oCoversDTO.ScoreAway + oCoversDTO.ScoreHome) + minsLeft * ptsPerMinute;
            double OvUnAmt = gamePace - oTodaysPlays.Line;

            calcTimeStatus();
            calcCurrentStatus();
            calcOvUnStatus();

            void calcTimeStatus()   // (4) 6:20 / (OT 1) 6:20
            {
               string period;
               if (oCoversDTO.Period > oLeagueDTO.Periods)
                  period = "OT " + (oCoversDTO.Period - oLeagueDTO.Periods).ToString();
               else
                  period = oCoversDTO.Period.ToString();
               int mins =  ((int)(oCoversDTO.SecondsLeftInPeriod / 60));
               string secs = (oCoversDTO.SecondsLeftInPeriod % 60).ToString();
               secs = secs.Length == 1 ? "0" + secs : secs;
               oTodaysPlaysResults.TimeStatus = $"({period}) {mins}:{secs}";
            }
            void calcCurrentStatus()   // 105 (-15)
            {
               if (oTodaysPlaysResults.Score > oTodaysPlays.Line)
                  oTodaysPlaysResults.CurrentStatus = "OVER";
               else
                  oTodaysPlaysResults.CurrentStatus = $"{oTodaysPlaysResults.Score} ({oTodaysPlays.Line - oTodaysPlaysResults.Score})";
            }
            void calcOvUnStatus()   // Ov 10  
            {
               OvUnAmt = Math.Round(OvUnAmt, 1);
               if (OvUnAmt > 0)
                  oTodaysPlaysResults.OvUnStatus = $"Ov {OvUnAmt}";
               else if (OvUnAmt < 0)
                  oTodaysPlaysResults.OvUnStatus = $"Un {OvUnAmt * (-1)}";
               else
                  oTodaysPlaysResults.OvUnStatus = "Even";
            }
         }  // calcInProgress
         void calcFinal()
         {
            string playResult;
            oTodaysPlaysResults.TimeStatus = $"Final {oTodaysPlaysResults.Score}";
            calcCurrentStatus(); // Col 5  Row 2
            calcOvUnStatus();    // Col 6  Row 1
            calcInfo();          // Col 6  Row 2

            void calcCurrentStatus()   // Col 5  Row 2
            {
               if (oTodaysPlaysResults.Score > oTodaysPlays.Line)
                  playResult = "OVER";
               else if (oTodaysPlaysResults.Score < oTodaysPlays.Line)
                  playResult = "UNDER";
               else playResult = "PUSH";

               oTodaysPlaysResults.CurrentStatus = $"{playResult} {oTodaysPlays.Line} ({oTodaysPlaysResults.Score - oTodaysPlaysResults.Line})";
            }  // calcCurrentStatus
            void calcOvUnStatus()   // WIN / LOSS / Push // Col 6  Row 1
            {
               if (playResult == "PUSH")
                  oTodaysPlaysResults.OvUnStatus = "PUSH";
               else if (playResult.ToLower() == oTodaysPlays.PlayDirection.ToLower())
               {
                  oTodaysPlaysResults.OvUnStatus = "WIN";
                  oTodaysPlaysResults.Result = 1;
               }
               else
               {
                  oTodaysPlaysResults.OvUnStatus = "LOSS";
                  oTodaysPlaysResults.Result = -1;
               }
               if (oTodaysPlays.OtAffacted != 0)
               {
                  oTodaysPlaysResults.OvUnStatus = "OT " + oTodaysPlaysResults.OvUnStatus;
               }
            }  // calcOvUnStatus
            void calcInfo()   // Col 6  Row 2
            {
               oTodaysPlaysResults.Info = oTodaysPlays.Juice.ToString();
               if (oTodaysPlays.PlayWeight != 1.0)
                  oTodaysPlaysResults.Info += " Wt: " + oTodaysPlays.PlayWeight.ToString();
            }  // calcInfo
         }  // calcFinal

         void calcNotStarted()
         {
            oTodaysPlaysResults.TimeStatus = "";
            oTodaysPlaysResults.CurrentStatus = "";
            oTodaysPlaysResults.Info = oTodaysPlays.GameTime.ToString().Substring(0, 5);
            oTodaysPlaysResults.OvUnStatus = "Game";
            
         }  // calcNotStartedl
         void calcCanceled()
         {
            oTodaysPlaysResults.TimeStatus = "";
            oTodaysPlaysResults.CurrentStatus = "";
            oTodaysPlaysResults.Info = "Canceled";
            oTodaysPlaysResults.OvUnStatus = "";
         }  // calcCanceled
         #endregion localMethods
      }  // CalcTodaysPlays

      void  getTodaysPlays(IBballInfoDTO oBballInfoDTO, IList<ITodaysPlaysDTO> ocTodaysPlays)
           => new TodaysPlaysDO(oBballInfoDTO).GetTodaysPlays(ocTodaysPlays);


      void getRotation(SortedList<string, CoversDTO> ocRotation, IBballInfoDTO oBballInfoDTO, LeagueDTO oLeagueDTO)
      {
         //ocRotation = new SortedList<string, CoversDTO>();
         try
         {
            SeasonInfoDO oSeasonInfoDO = new SeasonInfoDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString);
            oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = oSeasonInfoDO.oSeasonInfoDTO;
           // ocRotation = new SortedList<string, CoversDTO>();
            oLeagueDTO = new LeagueDTO();
            new LeagueInfoDO(oBballInfoDTO.LeagueName, oLeagueDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate);  // Init _oLeagueDTO

            RotationDO.PopulateRotation(ocRotation, oBballInfoDTO, oLeagueDTO);
         }
         catch (Exception ex)
         {

            throw new Exception(DALFunctions.StackTraceFormat("Covers Rotation Error {oBballInfoDTO.GameDate} " , ex, ""));
         }
      }

      int xgetRotation(List<SortedList<string, CoversDTO>> ocRotations, string LeagueName)
      {
         int i = 0;
         foreach (var x in ocRotations)
         {
            var y = x.Values;
            if (y[0].LeagueName == LeagueName)
            {
               return i;
            }
            i++;
         }
         return i;
      }

      //public class TodaysPlaysResults
      //{
      //   public DateTime GameDate { get; set; }
      //   public int RotNum { get; set; }
      //   public string GameTime { get; set; }
      //   public string TeamAway { get; set; }
      //   public string TeamHome { get; set; }
      //   public string PlayDirection { get; set; } // 3A - 3+
      //   public double TotalLine { get; set; }     // 3B - 3+
      //   public double Score { get; set; }         // 5B+- 4
      //   public double ScoreAway { get; set; }     // 4A
      //   public double ScoreHome { get; set; }     // 4B
      //   // Calced props
      //   public string TimeStatus { get; set; }    // 5A - 5   (4) 6:20 / (OT 1) 6:20
      //   public string CurrentStatus { get; set; } // 5B       105 (-15)
      //   public string Info { get; set; }          // 6A
      //   public string OvUnStatus { get; set; }    // 6B - 6   Ov 10    
      //}
   }
}
