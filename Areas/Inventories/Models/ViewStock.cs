namespace TKTradersWebApp.Areas.Inventories.Models
{
    public class StockView
    {
        public int InvestmentId { get; set; }
        public int StockId { get; set; }
        public string Title { get; set; }
        public int ProductTypeId { get; set; }
        public string ProductName { get; set; }
        public decimal Quantity { get; set; }
        public decimal Amount { get; set; }
    }
}
