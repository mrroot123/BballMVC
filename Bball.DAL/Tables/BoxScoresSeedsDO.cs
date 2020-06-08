
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class BoxScoresSeeds
   {
      const string TableName = "BoxScoresSeeds";
      const string TableColumns = "UserName,LeagueName,Season,GamesBack,Team,AdjustmentAmountScored,AdjustmentAmountAllowed,AwayShotsScoredPt1,AwayShotsScoredPt2,AwayShotsScoredPt3,AwayShotsAllowedPt1,AwayShotsAllowedPt2,AwayShotsAllowedPt3,AwayShotsAdjustedScoredPt1,AwayShotsAdjustedScoredPt2,AwayShotsAdjustedScoredPt3,AwayShotsAdjustedAllowedPt1,AwayShotsAdjustedAllowedPt2,AwayShotsAdjustedAllowedPt3,HomeShotsScoredPt1,HomeShotsScoredPt2,HomeShotsScoredPt3,HomeShotsAllowedPt1,HomeShotsAllowedPt2,HomeShotsAllowedPt3,HomeShotsAdjustedScoredPt1,HomeShotsAdjustedScoredPt2,HomeShotsAdjustedScoredPt3,HomeShotsAdjustedAllowedPt1,HomeShotsAdjustedAllowedPt2,HomeShotsAdjustedAllowedPt3,CreateDate,UpdateDate";

      DateTime _GameDate;
      ILeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      // Constructor
      public BoxScoresSeeds(DateTime GameDate, ILeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }

      #region GetRows
      public int GetRow(IBoxScoresSeedsDTO oBoxScoresSeedsDTO)
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), oBoxScoresSeedsDTO, populateDTOFromRdr);
         return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         IBoxScoresSeedsDTO oBoxScoresSeeds = (BoxScoresSeedsDTO)oRow;

         oBoxScoresSeeds.BoxScoresSeedID = (int)rdr["BoxScoresSeedID"];
         oBoxScoresSeeds.UserName = rdr["UserName"].ToString().Trim();
         oBoxScoresSeeds.LeagueName = rdr["LeagueName"].ToString().Trim();
         oBoxScoresSeeds.Season = rdr["Season"].ToString().Trim();
         oBoxScoresSeeds.GamesBack = (int)rdr["GamesBack"];
         oBoxScoresSeeds.Team = rdr["Team"].ToString().Trim();
         oBoxScoresSeeds.AdjustmentAmountScored = (double)rdr["AdjustmentAmountScored"];
         oBoxScoresSeeds.AdjustmentAmountAllowed = (double)rdr["AdjustmentAmountAllowed"];
         oBoxScoresSeeds.AwayShotsScoredPt1 = (double)rdr["AwayShotsScoredPt1"];
         oBoxScoresSeeds.AwayShotsScoredPt2 = (double)rdr["AwayShotsScoredPt2"];
         oBoxScoresSeeds.AwayShotsScoredPt3 = (double)rdr["AwayShotsScoredPt3"];
         oBoxScoresSeeds.AwayShotsAllowedPt1 = (double)rdr["AwayShotsAllowedPt1"];
         oBoxScoresSeeds.AwayShotsAllowedPt2 = (double)rdr["AwayShotsAllowedPt2"];
         oBoxScoresSeeds.AwayShotsAllowedPt3 = (double)rdr["AwayShotsAllowedPt3"];
         oBoxScoresSeeds.AwayShotsAdjustedScoredPt1 = (double)rdr["AwayShotsAdjustedScoredPt1"];
         oBoxScoresSeeds.AwayShotsAdjustedScoredPt2 = (double)rdr["AwayShotsAdjustedScoredPt2"];
         oBoxScoresSeeds.AwayShotsAdjustedScoredPt3 = (double)rdr["AwayShotsAdjustedScoredPt3"];
         oBoxScoresSeeds.AwayShotsAdjustedAllowedPt1 = (double)rdr["AwayShotsAdjustedAllowedPt1"];
         oBoxScoresSeeds.AwayShotsAdjustedAllowedPt2 = (double)rdr["AwayShotsAdjustedAllowedPt2"];
         oBoxScoresSeeds.AwayShotsAdjustedAllowedPt3 = (double)rdr["AwayShotsAdjustedAllowedPt3"];
         oBoxScoresSeeds.HomeShotsScoredPt1 = (double)rdr["HomeShotsScoredPt1"];
         oBoxScoresSeeds.HomeShotsScoredPt2 = (double)rdr["HomeShotsScoredPt2"];
         oBoxScoresSeeds.HomeShotsScoredPt3 = (double)rdr["HomeShotsScoredPt3"];
         oBoxScoresSeeds.HomeShotsAllowedPt1 = (double)rdr["HomeShotsAllowedPt1"];
         oBoxScoresSeeds.HomeShotsAllowedPt2 = (double)rdr["HomeShotsAllowedPt2"];
         oBoxScoresSeeds.HomeShotsAllowedPt3 = (double)rdr["HomeShotsAllowedPt3"];
         oBoxScoresSeeds.HomeShotsAdjustedScoredPt1 = (double)rdr["HomeShotsAdjustedScoredPt1"];
         oBoxScoresSeeds.HomeShotsAdjustedScoredPt2 = (double)rdr["HomeShotsAdjustedScoredPt2"];
         oBoxScoresSeeds.HomeShotsAdjustedScoredPt3 = (double)rdr["HomeShotsAdjustedScoredPt3"];
         oBoxScoresSeeds.HomeShotsAdjustedAllowedPt1 = (double)rdr["HomeShotsAdjustedAllowedPt1"];
         oBoxScoresSeeds.HomeShotsAdjustedAllowedPt2 = (double)rdr["HomeShotsAdjustedAllowedPt2"];
         oBoxScoresSeeds.HomeShotsAdjustedAllowedPt3 = (double)rdr["HomeShotsAdjustedAllowedPt3"];
         oBoxScoresSeeds.CreateDate = (DateTime)rdr["CreateDate"];
         oBoxScoresSeeds.UpdateDate = (DateTime)rdr["UpdateDate"];

      }
      private string getRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {TableName}  "
            + $"  Where LeagueName = '{_oLeagueDTO.LeagueName}'  And '{_GameDate}' = r.GameDate"
            + "   Order By RotNum"
            ;
         return Sql;
      }
      #endregion GetRows

      //#region InsertRow
      //public void InsertRow()
      //{
      //   BoxScoresSeeds oBoxScoresSeeds = populateDTO();
      //   //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
      //   SqlFunctions.DALInsertRow(TableName, TableColumns, oBoxScoresSeeds, populate_ocValuesForInsert, _ConnectionString);
      //}
      //private BoxScoresSeeds populateDTO()
      //{
      //   BoxScoresSeeds oBoxScoresSeeds = new BoxScoresSeeds();
      //   oBoxScoresSeeds.LeagueName = _oLeagueDTO.LeagueName;
      //   // ...
      //   return oBoxScoresSeeds;
      //}
      //static void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      //{
      //   BoxScoresSeeds oBoxScoresSeeds = (BoxScoresSeeds)DTO;

      //   ocValues.Add(oBoxScoresSeeds.GameDate.ToString());
      //   ocValues.Add(oBoxScoresSeeds.LeagueName.ToString());
      //}
      //#endregion InsertRow

   }  // class

}

