﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;

using BballMVC.DTOs;
using Bball.DataBaseFunctions;


namespace Bball.DAL.Tables
{

   public class SeasonInfoDO
   {
      public const string SeasonInfoTable = "SeasonInfo";
      public SeasonInfoDTO oSeasonInfoDTO = new SeasonInfoDTO();


      public DateTime GameDate { get; set; }
      String _LeagueName;

      public SeasonInfoDO(DateTime GameDate, String LeagueName)
      {
         this.GameDate = GameDate;
         _LeagueName = LeagueName;
         populateSeasonInfoDTO();
      }
      public DateTime GetNextGameDate()
      {
         GameDate = GameDate.AddDays(1);

         while (true)
         {
            if (GameDate <= oSeasonInfoDTO.EndDate && oSeasonInfoDTO.Bypass == false)
               break;
            // kdtodo finish
            //Get next SeasonInfo row
            // 
            GameDate = oSeasonInfoDTO.EndDate.AddDays(1);
            populateSeasonInfoDTO();
         }

         return GameDate;
      }
      private  void populateSeasonInfoDTO()
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(SqlFunctions.GetConnectionString(), SeasonInfoRowSql()
                       , null, oSeasonInfoDTO, PopulateDTO);
         if (rows == 0)
            throw new Exception($"SeasonInfo row not found - League: {_LeagueName}  GameDate: {GameDate}");
      }
      public int CalcSubSeasonPeriod()
      {
         // All ints
         // Get TotalDays rounded down to mul of 4
         // DaysPerPeriod DPP - TD / 4
         // Day in Season DIS - GameDate - StartDate
         // Period = Floor{ [ (DIS + DPP-1) / DPP ], 1}
         return 0;   // kdtodo
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
      static void PopulateDTO(List<object> ocRows, object oRow, SqlDataReader rdr)
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
