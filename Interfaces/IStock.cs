using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Interfaces
{
    public interface IStock
    {
        TStock Get(int stockId);
        int Add(TStock stock);
        int Update(TStock stock);
        int Delete(int stockId);        
    }
}
