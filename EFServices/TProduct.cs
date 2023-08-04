using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TProduct
    {
        public TProduct()
        {
            TProductTypes = new HashSet<TProductType>();
        }

        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public bool IsObsolete { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; } = null!;
        public DateTime? UpdatedDate { get; set; }
        public string? UpdateBy { get; set; }

        public virtual ICollection<TProductType> TProductTypes { get; set; }
    }
}
