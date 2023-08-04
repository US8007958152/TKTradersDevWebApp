using System.Data;

namespace TKTradersWebApp.CommonModel
{
    public class ListCollection
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        public string ProductName { get; set; }
        public string ImagePath { get; set; }
        public decimal Stock { get; set; }
        public int ItemCount { get; set; }
        public int TransportTypeId { get; set; }
        public string TransportTypeName { get; set; }
        public DateTime CreatedDate { get; set; }
        public int InvestedItemCount { get; set; }
    }
}
