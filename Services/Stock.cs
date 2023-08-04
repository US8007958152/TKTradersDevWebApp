using TKTradersWebApp.EFServices;
using TKTradersWebApp.Interfaces;

namespace TKTradersWebApp.Services
{
    public class Stock : IStock
    {
        private readonly IConfiguration configuration;
        public Stock(IConfiguration configuration)
        {
            this.configuration = configuration;
        }
        public int Add(TStock stock)
        {

            throw new NotImplementedException();
        }

        public int Delete(int stockId)
        {
            throw new NotImplementedException();
        }

        public TStock Get(int stockId)
        {
            throw new NotImplementedException();
        }

        public int Update(TStock stock)
        {
            throw new NotImplementedException();
        }
    }
}
