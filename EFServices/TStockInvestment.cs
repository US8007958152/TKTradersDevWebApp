using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TStockInvestment
    {
        public int Id { get; set; }
        public int StockId { get; set; }
        public int ProductTypeId { get; set; }
        public decimal Quantity { get; set; }
        public decimal Amount { get; set; }
        public string? ReferredOrders { get; set; }

        public virtual TStock Stock { get; set; } = null!;
    }
}
