using System.ComponentModel.DataAnnotations.Schema;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Inventories.Models
{
    public class Order:TOrder
    {
        [NotMapped]
        public string SupplierMobile { get; set; }
        [NotMapped]
        public string SupplierName { get; set; }
        [NotMapped]
        public string SupplierAddress { get; set; }
        [NotMapped]
        public string CustomerMobile { get; set; }
        [NotMapped]
        public string CustomerName { get; set; }
        [NotMapped]
        public string CustomerAddress { get; set; }
        [NotMapped]
        public string TruckOwnerMobile { get; set; }
        [NotMapped]
        public string TruckOwnerName { get; set; }
        [NotMapped]
        public string TruckNumber { get; set; }
        [NotMapped]
        public string DriverMobile { get; set; }
        [NotMapped]
        public string DriverName { get; set; }
        [NotMapped]
        public string ProductName { get; set; }
        [NotMapped]
        public decimal Quantity { get; set; }
        [NotMapped]
        public decimal Amount { get; set; }
        [NotMapped]
        public string TransportType { get; set; }
       
    }
}
