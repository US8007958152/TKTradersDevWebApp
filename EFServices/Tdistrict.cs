using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TDistrict
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public int StateId { get; set; }
        public bool? IsObsolete { get; set; }
    }
}
