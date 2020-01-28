using System;
using System.Collections.Generic;
using System.Linq;
using Bball.VbClasses.Bball.VbClasses;
//using Bball.VbClassesInterfaces.Bball.VbClassesInterfaces;
using Bball.DataBaseFunctions;

using BballMVC.DTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class DailySummary
   {
      public const string DailySummaryTable = "DailySummary";
      private const string ColumnNames = "GameDate,LeagueName,Season,SubSeason,SubSeasonPeriod,NumOfMatchups,LgAvgStartDate,LgAvgGamesBack,LgAvgScoreAway,LgAvgScoreHome,LgAvgScoreFinal,LgAvgShotsMadeAwayPt1,LgAvgShotsMadeAwayPt2,LgAvgShotsMadeAwayPt3,LgAvgShotsMadeHomePt1,LgAvgShotsMadeHomePt2,LgAvgShotsMadeHomePt3,LgAvgLastMinPts,LgAvgLastMinPt1,LgAvgLastMinPt2,LgAvgLastMinPt3";
 
      DateTime _GameDate;
      LeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      public DailySummary(DateTime GameDate, LeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }

      #region GetRows
      public int GetRow(DailySummaryDTO oDailySummaryDTO)
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, getRowSql(), null, oDailySummaryDTO, LoadReadRowToDTO);
         return rows;
      }
      private string getRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {DailySummaryTable} r "
            + $"  Where r.LeagueName = '{_oLeagueDTO.LeagueName}'  And '{_GameDate}' = r.GameDate"
            + "   Order By r.RotNum"
            ;
         return Sql;
      }

      static void LoadReadRowToDTO(List<object> ocRows, object oRow, SqlDataReader rdr)
      {
         DailySummaryDTO oDailySummaryDTO = (DailySummaryDTO)oRow;

         oDailySummaryDTO.DailySummaryID = (int)rdr["DailySummaryID"];
         oDailySummaryDTO.GameDate = (DateTime)rdr["GameDate"];
         oDailySummaryDTO.LeagueName = rdr["LeagueName"].ToString().Trim();
         oDailySummaryDTO.Season = rdr["Season"].ToString().Trim(); ;
         oDailySummaryDTO.SubSeason = rdr["SubSeason"].ToString().Trim();
         oDailySummaryDTO.SubSeasonPeriod = (int)rdr["SubSeasonPeriod"];
         oDailySummaryDTO.NumOfMatchups = (int)rdr["NumOfMatchups"];
      }
      static void LoadLgAvgStatsToDTO(List<object> ocRows, object oRow, SqlDataReader rdr)
      {
         DailySummaryDTO oDailySummaryDTO = (DailySummaryDTO)oRow;

         oDailySummaryDTO.LgAvgStartDate = (DateTime)rdr["LgAvgStartDate"];
         oDailySummaryDTO.LgAvgGamesBack = (int)rdr["LgAvgGamesBack"];

         oDailySummaryDTO.LgAvgScoreAway = (double)rdr["LgAvgScoreAway"];
         oDailySummaryDTO.LgAvgScoreHome = (double)rdr["LgAvgScoreHome"];
         oDailySummaryDTO.LgAvgScoreFinal = (double)rdr["LgAvgScoreFinal"];

         oDailySummaryDTO.LgAvgShotsMadeAwayPt1 = (double)rdr["LgAvgShotsMadeAwayPt1"];
         oDailySummaryDTO.LgAvgShotsMadeAwayPt2 = (double)rdr["LgAvgShotsMadeAwayPt2"];
         oDailySummaryDTO.LgAvgShotsMadeAwayPt3 = (double)rdr["LgAvgShotsMadeAwayPt3"];

         oDailySummaryDTO.LgAvgShotsMadeHomePt1 = (double)rdr["LgAvgShotsMadeHomePt1"];
         oDailySummaryDTO.LgAvgShotsMadeHomePt2 = (double)rdr["LgAvgShotsMadeHomePt2"];
         oDailySummaryDTO.LgAvgShotsMadeHomePt3 = (double)rdr["LgAvgShotsMadeHomePt3"];

         oDailySummaryDTO.LgAvgLastMinPts = (double)rdr["LgAvgLastMinPts"];
         oDailySummaryDTO.LgAvgLastMinPt1 = (double)rdr["LgAvgLastMinPt1"];
         oDailySummaryDTO.LgAvgLastMinPt2 = (double)rdr["LgAvgLastMinPt2"];
         oDailySummaryDTO.LgAvgLastMinPt3 = (double)rdr["LgAvgLastMinPt3"];

      }

      #endregion GetRows

      #region InsertRows
      public void RefreshRow(int NumOfMatchups)
      {
         deleteDailySummary();
         //                            TableName     ColNames (csv)     DTO                     Insert into DTO Method
         SqlFunctions.DALInsertRow(DailySummaryTable, ColumnNames, populateDTO(NumOfMatchups), populateoDailySummaryValuesForInsert, _ConnectionString);
      }
      private void deleteDailySummary()
      {
         string strSql = $"DELETE From {DailySummaryTable} Where LeagueName = '{_oLeagueDTO.LeagueName}' AND GameDate = '{_GameDate.ToShortDateString()}'";
         int rows = SysDAL.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      }
      private DailySummaryDTO populateDTO(int NumOfMatchups)
      {
         SeasonInfo oSeasonInfo = new SeasonInfo(_GameDate, _oLeagueDTO.LeagueName);

         // Populate Basic columns
         DailySummaryDTO oDailySummaryDTO = new DailySummaryDTO()
         {
              GameDate = _GameDate
            , LeagueName = _oLeagueDTO.LeagueName
            , Season = oSeasonInfo.oSeasonInfoDTO.Season
            , SubSeason = oSeasonInfo.oSeasonInfoDTO.SubSeason
            , SubSeasonPeriod = oSeasonInfo.CalcSubSeasonPeriod()
            , NumOfMatchups = NumOfMatchups
         };

         // Calc Averages and Populate rest of DTO
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName", "Season", "SubSeason" };
         List<object> SqlParmValues = new List<object>()
            { _GameDate.ToShortDateString(), _oLeagueDTO.LeagueName, oSeasonInfo.oSeasonInfoDTO.Season, oSeasonInfo.oSeasonInfoDTO.SubSeason };

         SysDAL.DALfunctions.ExecuteStoredProcedureQuery(_ConnectionString, "uspQueryLeagueAverages"
                             , SqlParmNames, SqlParmValues, null, oDailySummaryDTO, LoadLgAvgStatsToDTO);
         return oDailySummaryDTO;
      }

      static void populateoDailySummaryValuesForInsert(List<string> ocValues, object DTO)
      {
         DailySummaryDTO oDailySummaryDTO = (DailySummaryDTO)DTO;

         ocValues.Add(oDailySummaryDTO.GameDate.ToString());
         ocValues.Add(oDailySummaryDTO.LeagueName.ToString());
         ocValues.Add(oDailySummaryDTO.Season.ToString());
         ocValues.Add(oDailySummaryDTO.SubSeason.ToString());
         ocValues.Add(oDailySummaryDTO.SubSeasonPeriod.ToString());
         ocValues.Add(oDailySummaryDTO.NumOfMatchups.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgStartDate.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgGamesBack.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgScoreAway.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgScoreHome.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgScoreFinal.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeAwayPt1.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeAwayPt2.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeAwayPt3.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeHomePt1.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeHomePt2.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgShotsMadeHomePt3.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgLastMinPts.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgLastMinPt1.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgLastMinPt2.ToString());
         ocValues.Add(oDailySummaryDTO.LgAvgLastMinPt3.ToString());

      }
      #endregion InsertRows
   }  // class
}  // namespace
