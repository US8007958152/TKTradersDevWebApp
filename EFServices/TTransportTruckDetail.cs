using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TTransportTruckDetail
    {
        public int TransportId { get; set; }
        public int TruckOwnerId { get; set; }
        public int PaymentTypeId { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal PaidAmount { get; set; }

        public virtual TTransport Transport { get; set; } = null!;
    }
}
