using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUserDetail
    {
        public int UserId { get; set; }
        public string? Address { get; set; }
        public string? Company { get; set; }
        public int? CityId { get; set; }
        public int? DistrictId { get; set; }
        public int? StateId { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedBy { get; set; }

        public virtual TUser User { get; set; } = null!;
    }
}
