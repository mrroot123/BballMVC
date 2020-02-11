
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class LinesDO
   {
      const string TableName = "Lines";
      const string TableColumns = "LeagueName,GameDate,RotNum,TeamAway,TeamHome,Line,PlayType,PlayDuration,CreateDate,LineSource";

      DateTime _GameDate;
      LeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      // Constructor
      public LinesDO(DateTime GameDate, LeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }

      public void InsertLinesFromRotation()
      {
         // call SP to writeLines
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>()
            { _GameDate.ToShortDateString(), _oLeagueDTO.LeagueName };
         // kdtodo                                                               make constant
         SysDAL.DALfunctions.ExecuteStoredProcedureNonQuery(_ConnectionString, "uspInsertLinesFromRotation", SqlParmNames, SqlParmValues);

      }

      #region GetRows
      public int GetRow(LinesDTO oLinesDTO)
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), oLinesDTO, populateDTOFromRdr);
         return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         // Column Updates Procedure
         // 1) Update Table Columns
         // 2) Select 1000, Cut Column names, Insert in Textpad, run Sql Columns macro, Replace {table}Columns with macro Op
         // 3) Use CodeGeneration.xlsm to generate populateBoxScoreValues entries
         // 4) Update CoversBoxScore.PopulateBoxScoresDTO

         LinesDTO oLeagueDTO = (LinesDTO)oRow;

         oLeagueDTO.LeagueName = rdr["LeagueName"].ToString().Trim();
         oLeagueDTO.RotNum = (int)rdr["RotNum"];
         // DateTime double
         //  oLeagueDTO.MultiYearLeague = (bool)rdr["MultiYearLeague"];
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

      public void InsertRow()
      {
         List<string> ocValues = new List<string>();
         LinesDTO oLinesDTO = populateDTO();
         populate_ocValuesForInsert(ocValues, oLinesDTO);

         //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
         SqlFunctions.DALInsertRow(TableName, TableColumns, ocValues,  _ConnectionString);
      }
      private LinesDTO populateDTO()
      {
         LinesDTO oLinesDTO = new LinesDTO();
         oLinesDTO.LeagueName = _oLeagueDTO.LeagueName;
         // ...
         return oLinesDTO;
      }
      private void populate_ocValuesForInsert(List<string> ocValues, LinesDTO oLinesDTO)
      {
         ocValues.Add(oLinesDTO.LeagueName.ToString());
         ocValues.Add(oLinesDTO.GameDate.ToString());
         ocValues.Add(oLinesDTO.RotNum.ToString());
         ocValues.Add(oLinesDTO.TeamAway.ToString());
         ocValues.Add(oLinesDTO.TeamHome.ToString());
         ocValues.Add(oLinesDTO.Line.ToString());
         ocValues.Add(oLinesDTO.PlayType.ToString());
         ocValues.Add(oLinesDTO.PlayDuration.ToString());
         ocValues.Add(oLinesDTO.CreateDate.ToString());
         ocValues.Add(oLinesDTO.LineSource.ToString());

      }


   }  // class

}

