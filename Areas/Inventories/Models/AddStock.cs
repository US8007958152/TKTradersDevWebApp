using System.ComponentModel.DataAnnotations.Schema;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Inventories.Models
{
    public class AddStock: TStock
    {
        [NotMapped]
        public decimal TotalAmount { get; set; }
    }
}
