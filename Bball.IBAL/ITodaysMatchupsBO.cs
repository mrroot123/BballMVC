using System.Collections.Generic;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface ITodaysMatchupsBO
   {
      void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO);
   }
}
