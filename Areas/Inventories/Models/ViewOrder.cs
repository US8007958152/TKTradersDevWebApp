using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Inventories.Models
{
    public class ViewOrder
    {
        public TUserMaster Supplier { get; set; }
        public TUserMaster Customer { get; set; }
        public string PickupLocation { get; set; }
        public string DropLocation { get; set; }
        public TUserMaster TruckOwner { get; set; }
        public TUserMaster Driver { get; set; }
        public string TruckNumber { get; set; }
        public int OrderId { get; set; }
        public int TransportTypeId { get; set; }
        public string TransportType { get; set; }
        public string Product { get; set; }
        public DateTime OrderDate { get; set; }
        public string Status { get; set; }
        public decimal Quantity { get; set; }
        public decimal SellAmount { get; set; }
        public decimal TruckRent { get; set; }
        public decimal PaidRent { get; set; }
        public decimal BuyAmount { get; set; }
        public decimal ReceivedAmount { get; set; }
        public decimal Profit { get; set; }
    }
}
