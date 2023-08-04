using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TstateTemp
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public int? CountryId { get; set; }
        public bool? IsObsolete { get; set; }
    }
}
