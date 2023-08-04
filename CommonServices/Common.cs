using TKTradersWebApp.CommonModel;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.CommonServices
{
    public class Common
    {
        private readonly TKTradersDBContext tKTradersDBContext;

        public Common(TKTradersDBContext tKTradersDBContext)
        {
            this.tKTradersDBContext = tKTradersDBContext;
        }

       public int createUser(int userTypeId,string mobileNumber,string name,string address,int loggedInUserId,bool isInternalDriver=false)
        {            
            TUserMaster userMaster = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.MobileNumber == mobileNumber).FirstOrDefault();
            if (userMaster == null)
            {
                userMaster = new TUserMaster();
                userMaster.MobileNumber = mobileNumber;
                userMaster.Name = name;
                userMaster.Address = address;
                userMaster.UserTypeId = userTypeId;
                userMaster.IsInternalDriver= isInternalDriver;
                userMaster.CreatedDateTime = DateTime.Now;
                userMaster.CreatedBy = loggedInUserId;
                tKTradersDBContext.TUserMasters.Add(userMaster);
                if (tKTradersDBContext.SaveChanges() > 0)
                    return userMaster.UserId;
            }
            else
            {
                return userMaster.UserId;
                //userMaster.Name = name;
                //userMaster.Address = address;
                //userMaster.UserTypeId = userTypeId;
                //userMaster.IsInternalDriver = isInternalDriver;
                //userMaster.UpdateDateTime = DateTime.Now;
                //userMaster.UpdatedBy = loggedInUserId;
                //tKTradersDBContext.TUserMasters.Update(userMaster);
                //if (tKTradersDBContext.SaveChanges() > 0)
                //    return userMaster.UserId;
            }
            return 0;
        }
        public Tuple<int,int> createTruck(string truckNumber, string mobileNumber, string name, string address, int loggedInUserId, bool isInternalTruck = false)
        {
            TTruck truck = tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false && truck.TruckNumber == truckNumber).FirstOrDefault();
            if (truck == null)
            {
                truck = new TTruck();
                truck.TruckNumber = truckNumber;
                truck.UserId = createUser(6,mobileNumber,name,address, loggedInUserId);
                truck.IsInternalTruck = isInternalTruck;
                truck.CreatedDate = DateTime.Now;
                truck.CreatedBy= loggedInUserId;
                tKTradersDBContext.TTrucks.Add(truck);
                if (tKTradersDBContext.SaveChanges() > 0)
                    return new Tuple<int, int>(truck.Id,Convert.ToInt32(truck.UserId));
            }
            else
            {
                return new Tuple<int, int>(truck.Id, Convert.ToInt32(truck.UserId));
                //truck.TruckNumber = truckNumber;
                //truck.UserId = createUser(6, mobileNumber, name, address, loggedInUserId);
                //truck.IsInternalTruck = isInternalTruck;
                //truck.CreatedDate = DateTime.Now;
                //tKTradersDBContext.TTrucks.Update(truck);
                //if (tKTradersDBContext.SaveChanges() > 0)
                //    return truck.Id;
            }
            return new Tuple<int, int>(0,0);
        }
    }
}
