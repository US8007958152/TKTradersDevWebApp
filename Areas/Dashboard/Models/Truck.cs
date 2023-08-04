using System.ComponentModel.DataAnnotations.Schema;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Dashboard.Models
{
    public class Truck:TTruck
    {
        [NotMapped]
        public string TruckOwnerMobile { get; set; }
        [NotMapped]
        public string TruckOwnerName { get; set; }
        
    }
}
