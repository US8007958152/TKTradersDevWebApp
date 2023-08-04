using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TcityTemp
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public int StateId { get; set; }
        public int DistrictId { get; set; }
        public bool? IsObsolete { get; set; }
    }
}
