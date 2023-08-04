using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TLogError
    {
        public int Id { get; set; }
        public string? ErrorMessage { get; set; }
        public string? StackTrace { get; set; }
        public DateTime? CreateDate { get; set; }
    }
}
