using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TOrder
    {
        public int OrderId { get; set; }
        public int TransportTypeId { get; set; }
        public int SupplierId { get; set; }
        public int CustomerId { get; set; }
        public DateTime OrderDate { get; set; }
        public int StatusTypeId { get; set; }
        public int TruckId { get; set; }
        public int DriverId { get; set; }
        public bool IsInternalTruck { get; set; }
        public bool IsInternalDriver { get; set; }
        public bool IsObsolete { get; set; }
        public string? Comments { get; set; }
        public DateTime CreateDateTime { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int? UpdatedBy { get; set; }
        public int SenderSiteId { get; set; }
        public int ReceiverSiteId { get; set; }

        public virtual TOrderProductDetail TOrderProductDetail { get; set; } = null!;
        public virtual TOrderTruckDetail TOrderTruckDetail { get; set; } = null!;
        public virtual TStock TStock { get; set; } = null!;
    }
}
