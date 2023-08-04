using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TStaticTransportType
    {
        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public bool IsObsolete { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int CreatedBy { get; set; }
    }
}
