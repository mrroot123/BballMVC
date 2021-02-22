using System;
using System.Collections.Generic;
using System.Linq;
using BballMVC.DTOs;
using Bball.DataBaseFunctions;
using Bball.DAL.Parsing;
using SysDAL.Functions;
//using Bball.VbClasses.Bball.VbClasses;

namespace Bball.DAL.Tables
{
   public class BoxScoreDO
   {
      #region Notes
      // Dynamically Accessprops in class
      /*
       * https://stackoverflow.com/questions/8151888/c-sharp-iterate-through-class-properties
       * Record record = new Record();

         PropertyInfo[] properties = typeof(Record).GetProperties();
         foreach (PropertyInfo property in properties)
         {
             property.SetValue(record, value);
         }
         */
      #endregion Notes

      const string BoxScoresTable = "BoxScores";
      const string BoxScoresColumns = "Exclude,LeagueName,GameDate,RotNum,Team,Opp,Venue,GameTime,Season,SubSeason,MinutesPlayed,OtPeriods,ScoreReg,ScoreOT,ScoreRegUs,ScoreRegOp,ScoreOTUs,ScoreOTOp,ScoreQ1Us,ScoreQ1Op,ScoreQ2Us,ScoreQ2Op,ScoreQ3Us,ScoreQ3Op,ScoreQ4Us,ScoreQ4Op,ShotsActualMadeUsPt1,ShotsActualMadeUsPt2,ShotsActualMadeUsPt3,ShotsActualMadeOpPt1,ShotsActualMadeOpPt2,ShotsActualMadeOpPt3,ShotsActualAttemptedUsPt1,ShotsActualAttemptedUsPt2,ShotsActualAttemptedUsPt3,ShotsActualAttemptedOpPt1,ShotsActualAttemptedOpPt2,ShotsActualAttemptedOpPt3,ShotsMadeUsRegPt1,ShotsMadeUsRegPt2,ShotsMadeUsRegPt3,ShotsMadeOpRegPt1,ShotsMadeOpRegPt2,ShotsMadeOpRegPt3,ShotsAttemptedUsRegPt1,ShotsAttemptedUsRegPt2,ShotsAttemptedUsRegPt3,ShotsAttemptedOpRegPt1,ShotsAttemptedOpRegPt2,ShotsAttemptedOpRegPt3,TurnOversUs,TurnOversOp,OffRBUs,OffRBOp,AssistsUs,AssistsOp,Source,LoadDate,LoadTimeSeconds";

      const string BoxScoresLast5MinTable = "BoxScoresLast5Min";
      const string BoxScoresLast5MinColumns = "LeagueName,GameDate,RotNum,Team,Opp,Venue,Q4Last5MinScore,Q4Last1MinScore,Q4Score,Q4Last1MinScoreUs,Q4Last1MinScoreOp,Q4Last1MinWinningTeam,Q4Last1MinUsPts,Q4Last1MinOpPts,Q4Last1MinUsPt1,Q4Last1MinUsPt2,Q4Last1MinUsPt3,Q4Last1MinOpPt1,Q4Last1MinOpPt2,Q4Last1MinOpPt3,Source,LoadDate";

      delegate  void  PopulateDTOValues(List<string> ocValues, object DTO);

      #region BoxScoreInsert
      public static void InsertBoxScores(BoxScoresDTO oBoxScoresDTO, string ConnectionString)
         => insertRowPrep(ConnectionString, BoxScoresTable, BoxScoresColumns, oBoxScoresDTO, populate_ocValues);

      static string insertRowPrep(string ConnectionString, string TableName, string ColumnNames, object DTO, PopulateDTOValues delPopulateDTOValues)
      {
         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         List<string> ocValues = new List<string>();
         delPopulateDTOValues(ocValues, DTO);   // Execute Delegate
       //  string ConnectionString = SqlFunctions.GetConnectionString();
         string SQL = SysDAL.Functions.DALfunctions.GenSql(TableName, ocColumns);
         return DALfunctions.InsertRow(ConnectionString, SQL, ocColumns, ocValues);
      }
      static void populate_ocValues(List<string> ocValues, object DTO)
      {
         // Column Updates Procedure
         // 1) Update Table Columns
         // 2) Select 1000, Cut Column names, Insert in Textpad, run Sql Columns macro, Replace {table}Columns with macro Op
         // 3) Use CodeGeneration.xlsm to generate populate_ocValues entries
         // 4) Update CoversBoxScore.PopulateBoxScoresDTO
         BoxScoresDTO oBoxScoresDTO = (BoxScoresDTO)DTO;
         #region pastedBoxScoresRows

         ocValues.Add(oBoxScoresDTO.Exclude.ToString());
         ocValues.Add(oBoxScoresDTO.LeagueName.ToString());
         ocValues.Add(oBoxScoresDTO.GameDate.ToString());
         ocValues.Add(oBoxScoresDTO.RotNum.ToString());
         ocValues.Add(oBoxScoresDTO.Team.ToString());
         ocValues.Add(oBoxScoresDTO.Opp.ToString());
         ocValues.Add(oBoxScoresDTO.Venue.ToString());
         ocValues.Add(oBoxScoresDTO.GameTime.ToString());
         ocValues.Add(oBoxScoresDTO.Season.ToString());
         ocValues.Add(oBoxScoresDTO.SubSeason.ToString());
         ocValues.Add(oBoxScoresDTO.MinutesPlayed.ToString());
         ocValues.Add(oBoxScoresDTO.OtPeriods.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreReg.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreOT.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreRegUs.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreRegOp.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreOTUs.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreOTOp.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ1Us.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ1Op.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ2Us.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ2Op.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ3Us.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ3Op.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ4Us.ToString());
         ocValues.Add(oBoxScoresDTO.ScoreQ4Op.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeUsPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeUsPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeUsPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeOpPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeOpPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualMadeOpPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedUsPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedUsPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedUsPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedOpPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedOpPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsActualAttemptedOpPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeUsRegPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeUsRegPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeUsRegPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeOpRegPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeOpRegPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsMadeOpRegPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedUsRegPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedUsRegPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedUsRegPt3.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedOpRegPt1.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedOpRegPt2.ToString());
         ocValues.Add(oBoxScoresDTO.ShotsAttemptedOpRegPt3.ToString());
         ocValues.Add(oBoxScoresDTO.TurnOversUs.ToString());
         ocValues.Add(oBoxScoresDTO.TurnOversOp.ToString());
         ocValues.Add(oBoxScoresDTO.OffRBUs.ToString());
         ocValues.Add(oBoxScoresDTO.OffRBOp.ToString());
         ocValues.Add(oBoxScoresDTO.AssistsUs.ToString());
         ocValues.Add(oBoxScoresDTO.AssistsOp.ToString());
         ocValues.Add(oBoxScoresDTO.Source.ToString());
         ocValues.Add(oBoxScoresDTO.LoadDate.ToString());
         ocValues.Add(oBoxScoresDTO.LoadTimeSeconds.ToString());
         #endregion pastedBoxScoresRows
      }  // populate_ocValues
      #endregion BoxScoreInsert

      public static void DeleteBoxScoresByDate(String ConnectionString, string LeagueName, DateTime GameDate)
      {
         string strSql = $"Delete BoxScores Where LeagueName = '{LeagueName}' AND GameDate = '{GameDate.ToShortDateString()}'";
         DALfunctions.ExecuteSqlNonQuery(ConnectionString, strSql);
      }
      public static void DeleteBoxScoresLast5MinByDate(String ConnectionString, string LeagueName, DateTime GameDate)
      {
         string strSql = $"Delete BoxScoresLast5Min Where LeagueName = '{LeagueName}' AND GameDate = '{GameDate.ToShortDateString()}'";
         DALfunctions.ExecuteSqlNonQuery(ConnectionString, strSql);
      }
      #region BoxScoresLast5Min
      public static void InsertAwayHomeRowsBoxScoresLast5Min(BoxScoresLast5MinDTO oLast5MinDTOHome, string ConnectionString, BoxScoresLast5Min oLast5Min)
      {  // kd 12/15/2020 Injected oLast5Min
         string url = Bball.DAL.Parsing.BoxScoresLast5Min.BuildBoxScoresLast5MinUrl(oLast5MinDTOHome);  // Get Bb-ref Play by Play url
         oLast5Min = new BoxScoresLast5Min(url);
         oLast5Min.ParseBoxScoresLast5Min(oLast5MinDTOHome);
         InsertBoxScoresLast5Min(oLast5MinDTOHome, ConnectionString);   // Insert Home 

         BoxScoresLast5MinDTO oLast5MinDTOAway = new BoxScoresLast5MinDTO();
         populateAwayBoxScoreLast5MinDTOValues(oLast5MinDTOHome, oLast5MinDTOAway);
         InsertBoxScoresLast5Min(oLast5MinDTOAway, ConnectionString);   // Insert Away 
      }

      static void InsertBoxScoresLast5Min(BoxScoresLast5MinDTO oBoxScoresLast5MinDTO, string ConnectionString) 
         => insertRowPrep(ConnectionString, BoxScoresLast5MinTable, BoxScoresLast5MinColumns, oBoxScoresLast5MinDTO, populateBoxScoreLast5MinDTOValues);

      static void populateAwayBoxScoreLast5MinDTOValues(BoxScoresLast5MinDTO oHomeDTO, BoxScoresLast5MinDTO oAwayDTO)
      {
         //  Populate AWAY L5Min - reverse HOME info to AWAY info
         oAwayDTO.LeagueName = oHomeDTO.LeagueName;
         oAwayDTO.GameDate = oHomeDTO.GameDate;
         oAwayDTO.RotNum = oHomeDTO.Venue == "Home" ? --oHomeDTO.RotNum : ++oHomeDTO.RotNum;
         oAwayDTO.Team = oHomeDTO.Opp;
         oAwayDTO.Opp = oHomeDTO.Team;
         oAwayDTO.Venue = oHomeDTO.Venue == "Home" ? "Away" : "Home";
         oAwayDTO.Q4Last5MinScore = oHomeDTO.Q4Last5MinScore;
         oAwayDTO.Q4Last1MinScore = oHomeDTO.Q4Last1MinScore;
         oAwayDTO.Q4Score = oHomeDTO.Q4Score;
         oAwayDTO.Q4Last1MinScoreUs = oHomeDTO.Q4Last1MinScoreOp;
         oAwayDTO.Q4Last1MinScoreOp = oHomeDTO.Q4Last1MinScoreUs;
         oAwayDTO.Q4Last1MinWinningTeam = oHomeDTO.Q4Last1MinWinningTeam;
         // Move OP info to US & Vise versa
         oAwayDTO.Q4Last1MinUsPts = oHomeDTO.Q4Last1MinOpPts;
         oAwayDTO.Q4Last1MinOpPts = oHomeDTO.Q4Last1MinUsPts;

         oAwayDTO.Q4Last1MinUsPt1 = oHomeDTO.Q4Last1MinOpPt1;
         oAwayDTO.Q4Last1MinUsPt2 = oHomeDTO.Q4Last1MinOpPt2;
         oAwayDTO.Q4Last1MinUsPt3 = oHomeDTO.Q4Last1MinOpPt3;
         oAwayDTO.Q4Last1MinOpPt1 = oHomeDTO.Q4Last1MinUsPt1;
         oAwayDTO.Q4Last1MinOpPt2 = oHomeDTO.Q4Last1MinUsPt2;
         oAwayDTO.Q4Last1MinOpPt3 = oHomeDTO.Q4Last1MinUsPt3;

         oAwayDTO.Source = oHomeDTO.Source;
         oAwayDTO.LoadDate = oHomeDTO.LoadDate;
      }

      static void populateBoxScoreLast5MinDTOValues(List<string> ocValues, object DTO)
      {
         BoxScoresLast5MinDTO oLast5MinDTO = (BoxScoresLast5MinDTO)DTO;
         ocValues.Add(oLast5MinDTO.LeagueName.ToString());
         ocValues.Add(oLast5MinDTO.GameDate.ToString());
         ocValues.Add(oLast5MinDTO.RotNum.ToString());
         ocValues.Add(oLast5MinDTO.Team.ToString());
         ocValues.Add(oLast5MinDTO.Opp.ToString());
         ocValues.Add(oLast5MinDTO.Venue.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last5MinScore.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinScore.ToString());
         ocValues.Add(oLast5MinDTO.Q4Score.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinScoreUs.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinScoreOp.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinWinningTeam.ToString());

         ocValues.Add(oLast5MinDTO.Q4Last1MinUsPts.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinOpPts.ToString());

         ocValues.Add(oLast5MinDTO.Q4Last1MinUsPt1.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinUsPt2.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinUsPt3.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinOpPt1.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinOpPt2.ToString());
         ocValues.Add(oLast5MinDTO.Q4Last1MinOpPt3.ToString());

         ocValues.Add(oLast5MinDTO.Source.ToString());
         ocValues.Add(oLast5MinDTO.LoadDate.ToString());

      }
      #endregion BoxScoresLast5Min

      public static DateTime GetMaxBoxScoresGameDate(string ConnectionString, string LeagueName, DateTime DefaultDate)
      {
         DateTime GameDate = SqlFunctions.GetMaxGameDate(ConnectionString,  LeagueName, BoxScoresTable, DefaultDate);
         return GameDate;
      }
    } // class
}  // namespace
