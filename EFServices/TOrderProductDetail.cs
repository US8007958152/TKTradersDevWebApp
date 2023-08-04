using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TOrderProductDetail
    {
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        public decimal Quantity { get; set; }
        public int PaymentTypeId { get; set; }
        public decimal BuyAmount { get; set; }
        public decimal SellAmount { get; set; }
        public decimal SellPaidAmount { get; set; }
        public int? StockTypeId { get; set; }
        public decimal RemainingQuantity { get; set; }
        public string? ReferredOrders { get; set; }
        public string? InvestmenOrderIds { get; set; }

        public virtual TOrder Order { get; set; } = null!;
    }
}
