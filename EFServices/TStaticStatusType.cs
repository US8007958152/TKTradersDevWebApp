using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TStaticStatusType
    {
        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public bool IsObsolete { get; set; }
    }
}
