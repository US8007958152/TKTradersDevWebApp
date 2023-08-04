using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TProductType
    {
        public int Id { get; set; }
        public int? ProductId { get; set; }
        public string Title { get; set; } = null!;
        public bool IsObsolete { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; } = null!;
        public DateTime? UpdatedDate { get; set; }
        public string? UpdateBy { get; set; }
        public string? ImagePath { get; set; }
        public string? ColorCode { get; set; }
        public int ViewId { get; set; }

        public virtual TProduct? Product { get; set; }
    }
}
