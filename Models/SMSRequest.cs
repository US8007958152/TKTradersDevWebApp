namespace TKTradersWebApp.Models
{
    public  class SMSRequest
    {
        public  string MobileNumber { get; set; }
        public  string MessageBody { get; set; }

    }
    public class OrderMessage
    {
        public string SupplierName { get; set; }
        public string CustomerName { get; set; }
        public string ProductType { get; set; }
        public string Product { get; set; }
        public string OrderDate { get; set; }
        public decimal Quantity { get; set; }
        public decimal BuyAmount { get; set; }
        public decimal SellAmount { get; set; }
        public decimal SellPaidAmount { get; set; }
    }
}
