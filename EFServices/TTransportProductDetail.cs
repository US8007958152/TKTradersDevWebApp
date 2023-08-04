using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TTransportProductDetail
    {
        public int TransportId { get; set; }
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        public decimal Quantity { get; set; }
        public int PaymentTypeId { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal PaidAmount { get; set; }

        public virtual TTransport Transport { get; set; } = null!;
    }
}
