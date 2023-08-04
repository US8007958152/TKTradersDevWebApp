using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUserSite
    {
        public int SiteId { get; set; }
        public int? UserId { get; set; }
        public string? SiteAddress { get; set; }

        public virtual TUserMaster? User { get; set; }
    }
}
