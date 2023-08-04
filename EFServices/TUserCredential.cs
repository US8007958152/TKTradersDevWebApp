using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUserCredential
    {
        public int UserId { get; set; }
        public string? OldPassword { get; set; }
        public string NewPassword { get; set; } = null!;
        public int LoginAttempts { get; set; }

        public virtual TUser User { get; set; } = null!;
    }
}
