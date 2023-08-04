using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TOrderDetail
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        public decimal Quantity { get; set; }
        public decimal Price { get; set; }

        public virtual TOrder Order { get; set; } = null!;
    }
}
