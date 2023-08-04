using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TNotification
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int UserTypeId { get; set; }
        public int StatusTypeId { get; set; }
        public string MobileNumber { get; set; } = null!;
        public string Message { get; set; } = null!;
        public DateTime CreatedDateTime { get; set; }
    }
}
