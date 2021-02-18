using System;
using System.Collections.Generic;
using System.Data.SqlClient;

using BballMVC.DTOs;
using Bball.DataBaseFunctions;
using BballMVC.IDTOs;


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
         populateSeasonInfoDTO(oSeasonInfoDTO);
      }
      public SeasonInfoDO(IBballInfoDTO oBballInfoDTO)
      {
         this.GameDate = oBballInfoDTO.GameDate;
         _LeagueName = oBballInfoDTO.LeagueName;
         _ConnectionString = oBballInfoDTO.ConnectionString;
         populateSeasonInfoDTO(oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO);
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
               populateSeasonInfoDTO(oSeasonInfoDTO);
         }

         return GameDate;
      }
      // Load Today's & Tomorrows Rotation
      public bool RotationLoadedToDate() 
         => GameDate > DateTime.Today.AddDays(1);  // Is GameDate > Tomorrow

      private  void populateSeasonInfoDTO(ISeasonInfoDTO oSeasonInfoDTO)
      {
         // kdtodo - move SqlFunctions.GetConnectionString() to constructor 2b injected
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_ConnectionString, SeasonInfoRowSql()
                       ,  oSeasonInfoDTO, PopulateDTO);
         if (rows == 0)
            throw new Exception($"SeasonInfo row not found - League: {_LeagueName}  GameDate: {GameDate.ToShortDateString()}");
         oSeasonInfoDTO.SubSeasonPeriod = 0; // kdtodo call udf

         // private methods
         void PopulateDTO(object oRow, SqlDataReader rdr)
         {
            SeasonInfoDTO o = (SeasonInfoDTO)oRow;
            o.LeagueName = rdr["LeagueName"].ToString().Trim();
            o.StartDate = (DateTime)rdr["StartDate"];
            o.EndDate = (DateTime)rdr["EndDate"];
            o.Season = rdr["Season"].ToString().Trim();
            o.SubSeason = rdr["SubSeason"].ToString().Trim();
            o.Bypass = (bool)rdr["Bypass"];
            o.IncludePre = (bool)rdr["IncludePre"];
            o.IncludePost = (bool)rdr["IncludePost"];
            o.BoxscoreSource = rdr["BoxscoreSource"].ToString().Trim();
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
      }  // populateSeasonInfoDTO

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

     
   }
}
