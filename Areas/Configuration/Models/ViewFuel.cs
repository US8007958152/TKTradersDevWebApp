using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Configuration.Models
{
    public class ViewFuel:TTruckFuel
    {
        public string PetrolPumpName { get; set; }
        public string FuelType { get; set; }
        public string TruckNumber { get; set; }

    }
}
