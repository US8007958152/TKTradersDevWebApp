using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUser
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string MobileNumber { get; set; } = null!;
        public string? EmailId { get; set; }
        public int UserTypeId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int? UpdatedBy { get; set; }
        public bool IsObsolete { get; set; }

        public virtual TUserCredential TUserCredential { get; set; } = null!;
    }
}
