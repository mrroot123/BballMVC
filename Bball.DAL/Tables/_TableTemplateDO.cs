
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   //public 
   class TableTemplate
   {
      const string TableName = "TableTemplate";
      const string TableColumns = "~cols ...";

      DateTime _GameDate;
      LeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      // Constructor
      public TableTemplate(DateTime GameDate, LeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }

      #region GetRows
      public int GetRow(ThisDTO oThisDTO)
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), oThisDTO, populateDTOFromRdr);
         return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         // Column Updates Procedure
         // 1) Update Table Columns
         // 2) Select 1000, Cut Column names, Insert in Textpad, run Sql Columns macro, Replace {table}Columns with macro Op
         // 3) Use CodeGeneration.xlsm to generate populateBoxScoreValues entries
         // 4) Update CoversBoxScore.PopulateBoxScoresDTO

         ThisDTO oLeagueDTO = (ThisDTO)oRow;

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

      #region InsertRow
      public void InsertRow()
      {
         ThisDTO oThisDTO = populateDTO();
         //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
         SqlFunctions.DALInsertRow(TableName, TableColumns, oThisDTO, populate_ocValuesForInsert, _ConnectionString);
      }
      private ThisDTO populateDTO()
      {
         ThisDTO oThisDTO = new ThisDTO();
         oThisDTO.LeagueName = _oLeagueDTO.LeagueName;
         // ...
         return oThisDTO;
      }
      static void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      {
         ThisDTO oThisDTO = (ThisDTO)DTO;

         ocValues.Add(oThisDTO.GameDate.ToString());
         ocValues.Add(oThisDTO.LeagueName.ToString());
      }
      #endregion InsertRow

   }  // class

   class ThisDTO
   {
      public string LeagueName { get; set; }
      public DateTime GameDate { get; set; }
      public int RotNum { get; set; }
}
}

