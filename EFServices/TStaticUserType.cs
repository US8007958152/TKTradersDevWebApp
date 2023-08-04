using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TStaticUserType
    {
        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public bool IsObsolete { get; set; }
        public DateTime CreateDate { get; set; }
    }
}
