using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace BballMVC.ControllerAPIs
{
   public class BaseApiController : ApiController
   {
      protected string GetUser()
      {
         return "Test";
      }
      protected string GetConnectionString()
      {
         return @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
      }
      protected IBballInfoDTO BindBballInfoDTO(bballInfoDTO obballInfoDTO)
      {
         IBballInfoDTO oBballInfoDTO = new BballInfoDTO()
         {
            UserName = obballInfoDTO.UserName,
            GameDate = obballInfoDTO.GameDate,
            LeagueName = obballInfoDTO.LeagueName,
            ConnectionString = obballInfoDTO.ConnectionString,
            oSeasonInfoDTO = obballInfoDTO.oSeasonInfoDTO == null ? new SeasonInfoDTO() : obballInfoDTO.oSeasonInfoDTO
         };
         oBballInfoDTO.oBballDataDTO = new BballDataDTO();

         //oBballInfoDTO.oBballDataDTO.ocAdjustments = obballInfoDTO.oBballDataDTO.ocAdjustments as IList<IAdjustmentDTO>;

        // oBballInfoDTO.oBballDataDTO.ocLeagueNames = obballInfoDTO.oBballDataDTO.ocLeagueNames as IList<IDropDown>;

         if (obballInfoDTO.oBballDataDTO != null)

         {
            copyDropDownElements(obballInfoDTO.oBballDataDTO.ocAdjustmentNames, oBballInfoDTO.oBballDataDTO.ocAdjustmentNames);
            copyDropDownElements(obballInfoDTO.oBballDataDTO.ocLeagueNames, oBballInfoDTO.oBballDataDTO.ocLeagueNames);
            copyDropDownElements(obballInfoDTO.oBballDataDTO.ocTeams, oBballInfoDTO.oBballDataDTO.ocTeams);

         }

         return oBballInfoDTO;
      }

      void copyAdjustmentsElements(List<AdjustmentDTO> _in, IList<IAdjustmentDTO> _out)
      {
         if (_in == null) return;
         foreach (var ele in _in)
            _out.Add((AdjustmentDTO)ele.ShallowCopy());
      }
      //void copyTodaysMatchupsDTOElements(List<TodaysMatchupsDTO> _in, IList<ITodaysMatchupsDTOdorake3 
      //   > _out)
      //{
      //   if (_in == null)     return;
      //   foreach (var ele in _in)
      //      _out.Add((TodaysMatchupsDTO)ele.ShallowCopy());
      //}
      void copyDropDownElements(List<DropDown> _in, IList<IDropDown> _out)
      {
         if (_in == null)
            return;

         foreach(var dd in _in)
         {
            //IDropDown idd = new DropDown() { Value = dd.Value, Text = dd.Text };
            _out.Add(new DropDown() { Value = dd.Value, Text = dd.Text });
         }
      }
   }
   public class bballInfoDTO 
   {
      public string UserName { get; set; }
      public DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public string ConnectionString { get; set; }
      public SeasonInfoDTO oSeasonInfoDTO { get; set; }
      public bballDataDTO oBballDataDTO { get; set; }

   }
   public class bballDataDTO
   {
      public List<AdjustmentDTO> ocAdjustments { get; set; }
      public List<DropDown> ocAdjustmentNames { get; set; }
      public List<DropDown> ocTeams { get; set; }
      public List<DropDown> ocLeagueNames { get; set; }
      public List<TodaysMatchupsDTO> ocTodaysMatchupsDTO { get; set; }
   }
}
