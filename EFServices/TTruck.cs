using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TTruck
    {
        public TTruck()
        {
            TTruckFuels = new HashSet<TTruckFuel>();
        }

        public int Id { get; set; }
        public int? UserId { get; set; }
        public string TruckNumber { get; set; } = null!;
        public bool IsInternalTruck { get; set; }
        public bool IsObsolete { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedBy { get; set; }

        public virtual ICollection<TTruckFuel> TTruckFuels { get; set; }
    }
}
