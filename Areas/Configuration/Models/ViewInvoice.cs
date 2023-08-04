using TKTradersWebApp.Areas.Securities.Models;

namespace TKTradersWebApp.Areas.Configuration.Models
{
    public class ViewInvoice
    {
       public IQueryable<ViewFuel> viewFuels { get; set; }
        public string UserName { get; set; }
        public string UserMobile { get; set; }
        public string UserAddress { get; set; }
        public string EmailAddress { get; set; }
        public string DateRange { get; set; }
        public decimal FuelAmount { get; set; }
        public decimal SentAmount { get; set; }
        public decimal FinalAmount { get; set; }
    }
}
