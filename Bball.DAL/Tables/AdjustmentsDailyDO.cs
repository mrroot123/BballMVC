using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BballMVC.DTOs;
using System.Data.SqlClient;
using Bball.DataBaseFunctions;

namespace Bball.DAL.Tables
{
   public class AdjustmentsDailyDO
   {
      const string TableName = "AdjustmentsDaily";
      const string ColumnNames = "LeagueName,GameDate,RotNum,Team,AdjustmentAmount";

      DateTime _GameDate;
      LeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      #region Constructors
      // Constructors
      public AdjustmentsDailyDO(string ConnectionString)
      {
         _ConnectionString = ConnectionString;
      }
      public AdjustmentsDailyDO(DateTime GameDate, LeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }
      #endregion Constructors

      public void InsertRow(AdjustmentsDailyDTO oAdjustmentsDailyDTO)
      {
         SqlFunctions.DALInsertRow(TableName, ColumnNames, oAdjustmentsDailyDTO, populateDTO, _ConnectionString);
      }

      static void populateDTO(List<string> ocValues, object DTO)
      {
         // Column Updates Procedure
         // 1) Update Table Columns
         // 2) Select 1000, Cut Column names, Insert in Textpad, run Sql Columns macro, Replace {table}Columns with macro Op
         // 3) Use CodeGeneration.xlsm to generate populateBoxScoreValues entries
         // 4) Update CoversBoxScore.PopulateBoxScoresDTO
         AdjustmentsDailyDTO oAdjustmentsDailyDTO = (AdjustmentsDailyDTO)DTO;

         ocValues.Add(oAdjustmentsDailyDTO.LeagueName.ToString());
         ocValues.Add(oAdjustmentsDailyDTO.GameDate.ToString());
         ocValues.Add(oAdjustmentsDailyDTO.RotNum.ToString());
         ocValues.Add(oAdjustmentsDailyDTO.Team.ToString());
         ocValues.Add(oAdjustmentsDailyDTO.AdjustmentAmount.ToString());
      }

      public void DeleteDailyAdjustments(DateTime GameDate, string LeagueName)
      {
         string strSql = $"DELETE From {TableName} Where LeagueName = '{LeagueName}' AND GameDate = '{GameDate.ToShortDateString()}'";
         int rows = SysDAL.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      }
      //public int GetRow(DailySummaryDTO oDailySummaryDTO)
      //{
      //   int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), null, oDailySummaryDTO, LoadReadRowToDTO);
      //   return rows;
      //}

   }  // class


}
