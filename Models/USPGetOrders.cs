using System.ComponentModel.DataAnnotations;

namespace TKTradersWebApp.Models
{
    public class USPGetOrders
    {
        [Key]
        public int OrderId { get; set; }
        public string UserType { get; set; }
        public string Name { get; set; }
        public string Product { get; set; }
        public string TransportType { get; set; }
        public DateTime OrderDate { get; set; }
        public string StatusType { get; set; }
        public decimal TotalAmount { get; set; }
    }
}
