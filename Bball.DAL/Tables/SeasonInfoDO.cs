using System;
using System.Collections.Generic;
using System.Data.SqlClient;

using BballMVC.DTOs;
using Bball.DataBaseFunctions;


namespace Bball.DAL.Tables
{

   public class SeasonInfoDO
   {
      public const string SeasonInfoTable = "SeasonInfo";
      public static DateTime DefaultDate = Convert.ToDateTime("1/1/2000");

      public SeasonInfoDTO oSeasonInfoDTO = new SeasonInfoDTO();

      public DateTime GameDate { get; set; }
      private readonly string _LeagueName;
      private readonly string _ConnectionString;

      // constructor
      public SeasonInfoDO(DateTime GameDate, String LeagueName, string ConnectionString)
      {
         this.GameDate = GameDate;
         _LeagueName = LeagueName;
         _ConnectionString = ConnectionString;
         populateSeasonInfoDTO();

      }
      public DateTime GetNextGameDate()
      {
         GameDate = GameDate.AddDays(1);

         while (true)
         {
            if ((GameDate <= oSeasonInfoDTO.EndDate && oSeasonInfoDTO.Bypass == false) || RotationLoadedToDate())
               break;
            // kdtodo finish
            //Get next SeasonInfo row
            // 
            GameDate = oSeasonInfoDTO.EndDate.AddDays(1);
            if (!RotationLoadedToDate())
               populateSeasonInfoDTO();
         }

         return GameDate;
      }
      // Load Today's & Tomorrows Rotation
      public bool RotationLoadedToDate() 
         => GameDate > DateTime.Today.AddDays(1);  // Is GameDate > Tomorrow

      private  void populateSeasonInfoDTO()
      {
         // kdtodo - move SqlFunctions.GetConnectionString() to constructor 2b injected
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_ConnectionString, SeasonInfoRowSql()
                       ,  oSeasonInfoDTO, PopulateDTO);
         if (rows == 0)
            throw new Exception($"SeasonInfo row not found - League: {_LeagueName}  GameDate: {GameDate.ToShortDateString()}");
         oSeasonInfoDTO.SubSeasonPeriod = 0; // kdtodo call udf
      }
      public int CalcSubSeasonPeriod(BballInfoDTO oBballInfoDTO)
         => CalcSubSeasonPeriod(oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName);

      public static int CalcSubSeasonPeriod(string ConnectionString, DateTime GameDate, string LeagueName)
      {
         // All ints
         // Get TotalDays rounded down to mul of 4
         // DaysPerPeriod DPP - TD / 4
         // Day in Season DIS - GameDate - StartDate
         // Period = Floor{ [ (DIS + DPP-1) / DPP ], 1}
         
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>() { GameDate, LeagueName };
         var SubSeasonPeriod =             
            SysDAL.Functions.DALfunctions.ExecuteStoredProcedureQueryReturnSingleParm(
               ConnectionString, "udfCalcSubSeasonPeriod", SqlParmNames, SqlParmValues);

         return Int32.Parse(SubSeasonPeriod);
      }
      string SeasonInfoRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {SeasonInfoTable} s "
            + $"  Where s.LeagueName = '{_LeagueName}'  And '{GameDate}' >= s.StartDate  And '{GameDate}' <= s.EndDate"
            + "   Order By s.StartDate DESC"
            ;
         return Sql;
      }
      static void PopulateDTO(object oRow, SqlDataReader rdr)
      {
         SeasonInfoDTO oSeasonInfoDTO = (SeasonInfoDTO)oRow;
         oSeasonInfoDTO.LeagueName = rdr["LeagueName"].ToString().Trim();
         oSeasonInfoDTO.StartDate = (DateTime)rdr["StartDate"];
         oSeasonInfoDTO.EndDate = (DateTime)rdr["EndDate"];
         oSeasonInfoDTO.Season = rdr["Season"].ToString().Trim();
         oSeasonInfoDTO.SubSeason = rdr["SubSeason"].ToString().Trim();
         oSeasonInfoDTO.Bypass = (bool)rdr["Bypass"];
         oSeasonInfoDTO.IncludePre = (bool)rdr["IncludePre"];
         oSeasonInfoDTO.IncludePost = (bool)rdr["IncludePost"];
         oSeasonInfoDTO.BoxscoreSource = rdr["BoxscoreSource"].ToString().Trim();

      }
   }
}
