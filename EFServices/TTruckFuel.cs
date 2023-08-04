using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TTruckFuel
    {
        public int Id { get; set; }
        public int FuelTypeId { get; set; }
        public int PetrolPumpUserId { get; set; }
        public int TruckId { get; set; }
        public decimal Quantity { get; set; }
        public decimal Rate { get; set; }
        public decimal CurrentReading { get; set; }
        public decimal Amount { get; set; }
        public string? Comments { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public virtual TUserMaster PetrolPumpUser { get; set; } = null!;
        public virtual TTruck Truck { get; set; } = null!;
    }
}
