using System.ComponentModel.DataAnnotations;

namespace TKTradersWebApp.Areas.Securities.Models
{
    public class Invoice
    {
        public IQueryable<USPGetInvoiceByUserId> _USPGetInvoiceByUserId { get; set; }
        public UserDetails _UserDetails { get; set; }
    }
    public class USPGetInvoiceByUserId
    {
        [Key]
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public int SupplierId { get; set; }
        public int CustomerId { get; set; }
        public int TruckOwnerId { get; set; }
        public DateTime OrderDate { get; set; }
        public string ProductName { get; set; }
        public int TransportTypeId { get; set; }
        public string TransportType { get; set; }
        public decimal Quantity { get; set; }
        public decimal TotalAmount { get; set; }

    }
    public class UserDetails
    {
        public string UserName { get; set; }
        public string UserType { get; set; }
        public string Address { get; set; }
        public string MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string OtherAddress { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal SendAmount { get; set; }
        public decimal ReceivedAmount { get; set; }
        public decimal FinalAmount { get; set; }
    }
}
