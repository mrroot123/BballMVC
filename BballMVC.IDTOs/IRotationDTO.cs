using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.IDTOs
{
   public interface IRotationDTO
   {
      string BoxScoreSource { get; set; }
      string BoxScoreUrl { get; set; }
      DateTime CreateDate { get; set; }
      DateTime GameDate { get; set; }
      string GameTime { get; set; }
      string LeagueName { get; set; }
      double? OpenTotalLine { get; set; }
      string Opp { get; set; }
      int RotationID { get; set; }
      int RotNum { get; set; }
      string Season { get; set; }
      double? SideLine { get; set; }
      string SubSeason { get; set; }
      int? SubSeasonPeriod { get; set; }
      string Team { get; set; }
      double? TotalLine { get; set; }
      double? TotalLineOpp { get; set; }
      double? TotalLineTeam { get; set; }
      string TV { get; set; }
      DateTime? UpdateDate { get; set; }
      string Venue { get; set; }
   }
}
