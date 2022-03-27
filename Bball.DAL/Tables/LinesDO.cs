
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;
using SysDAL.Functions;
using System.Threading.Tasks;

namespace Bball.DAL.Tables
{
   public class LinesDO
   {
      const string TableName = "Lines";
      const string TableColumns = "LeagueName,GameDate,RotNum,TeamAway,TeamHome,Line,PlayType,PlayDuration,CreateDate,LineSource";

      DateTime _GameDate;
      ILeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      // Constructor
      public LinesDO(DateTime GameDate, ILeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }

      public async Task InsertLinesFromRotationAsync()
      {
         // call SP to Read Rotation by Lg & GameDate and writeLines
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>()
            { _GameDate.ToShortDateString(), _oLeagueDTO.LeagueName };
        // // kdtodo                                                               make constant
         await Task.Run(() =>
         {
            SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(_ConnectionString, "uspInsertLinesFromRotation", SqlParmNames, SqlParmValues);
         });

      }
      public void InsertLinesFromRotation()
      {
         // call SP to Read Rotation by Lg & GameDate and writeLines
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>()
            { _GameDate.ToShortDateString(), _oLeagueDTO.LeagueName };
         // kdtodo                                                               make constant
         SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(_ConnectionString, "uspInsertLinesFromRotation", SqlParmNames, SqlParmValues);

      }

      #region GetRows

      public static double GetOpenTotalLine(string ConnectionString, DateTime GameDate, int RotNum)
      {
         string strSql = "Select Isnull("
            +  "(SELECT Top 1 IsNull(l.Line, 0) as OpenTotalLine "
            + "FROM Lines l "
            + $"Where l.GameDate >= '{GameDate.ToShortDateString()}' and l.RotNum = {RotNum}  AND l.PlayType = 'Tot' AND l.PlayDuration = 'Game' "
            + "order by l.CreateDate) , 0)  as OpenTotalLine";

         var x = DALfunctions.ExecuteSqlQueryReturnSingleParm(ConnectionString, strSql, "OpenTotalLine");
         return (double)x;
      }

      public int GetRow(LinesDTO oLinesDTO)
      {
         // 2/13/2021 - NOTE: not accessed - and will got ALL rows for GameDate
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), oLinesDTO, populateDTOFromRdr);
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

