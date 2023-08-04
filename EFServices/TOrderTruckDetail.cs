using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TOrderTruckDetail
    {
        public int OrderId { get; set; }
        public int TruckOwnerId { get; set; }
        public int PaymentTypeId { get; set; }
        public decimal TruckRent { get; set; }
        public decimal PaidRent { get; set; }

        public virtual TOrder Order { get; set; } = null!;
    }
}
