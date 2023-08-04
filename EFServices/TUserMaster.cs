using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUserMaster
    {
        public TUserMaster()
        {
            TTruckFuels = new HashSet<TTruckFuel>();
            TUserSites = new HashSet<TUserSite>();
        }

        public int UserId { get; set; }
        public int UserTypeId { get; set; }
        public string Name { get; set; } = null!;
        public string MobileNumber { get; set; } = null!;
        public string? EmailId { get; set; }
        public string? Address { get; set; }
        public string? Company { get; set; }
        public int CityId { get; set; }
        public int DistrictId { get; set; }
        public int StateId { get; set; }
        public string? Password { get; set; }
        public bool IsObsolete { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? UpdateDateTime { get; set; }
        public int? UpdatedBy { get; set; }
        public bool IsInternalDriver { get; set; }

        public virtual ICollection<TTruckFuel> TTruckFuels { get; set; }
        public virtual ICollection<TUserSite> TUserSites { get; set; }
    }
}
