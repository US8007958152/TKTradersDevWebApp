using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using TKTradersWebApp.CommonModel;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Securities.Controllers
{
    [SessionTimeout]
    public class CommonController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;

        public CommonController(TKTradersDBContext tKTradersDBContext)
        {
            this.tKTradersDBContext = tKTradersDBContext;
        }
        [HttpGet]
        public IActionResult GetProductsDropdown()
        {
            try
            {               
                return Json(GetProducts());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpGet]
        public IActionResult GetProductTypesDropdown(int productId)
        {
            try
            {              
                return Json(GetProductTypes(productId));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpGet]
        public IActionResult GetDealersDropdown()
        {
            try
            {               
                return Json(GetDealers());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpGet]
        public IActionResult GetDriversDropdown()
        {
            try
            {               
                return Json(GetDrivers());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpGet]
        public IActionResult GetTrucksDropdown(int truckType)
        {
            try
            {               
                return Json(GetTrucks(truckType));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<SelectListItem> GetProducts()
        {
            List<SelectListItem> dropdowns = tKTradersDBContext.TProducts.Where(product => product.IsObsolete == false)
                    .Select(product => new SelectListItem { Value = product.Id.ToString(), Text = product.Title }).ToList();
            return dropdowns;
        }
        public List<SelectListItem> GetProductTypes(int productId)
        {
            List<SelectListItem> dropdowns = tKTradersDBContext.TProductTypes.Where(productType => productType.IsObsolete == false && (productType.ProductId == productId || productId == -1))
                    .Select(product => new SelectListItem { Value = product.Id.ToString(), Text = product.Title }).ToList();
            return dropdowns;
        }
        public List<SelectListItem> GetInvestmentProductTypes(int productId)
        {
            List<SelectListItem> dropdowns =tKTradersDBContext.TProducts.Where(product => product.IsObsolete == false && (product.Id == productId || productId == -1)).Join(tKTradersDBContext.TProductTypes,
                x=>x.Id,y=>y.ProductId,(x,y)=> new SelectListItem { Value = y.Id.ToString(), Text = y.Title+" "+x.Title })
                    .ToList();
            return dropdowns;
        }

        public List<SelectListItem> GetCity(int districtId)
        {
            List<SelectListItem> dropdowns = tKTradersDBContext.TCities.Where(city => city.IsObsolete == false && city.DistrictId == districtId)
                    .Select(product => new SelectListItem { Value = product.Id.ToString(), Text = product.Name }).ToList();
            return dropdowns;
        }
        public IQueryable<SelectListItem> GetUser(int userTypeId)
        {
            try
            {
                return tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.UserTypeId == userTypeId)
                    .Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IQueryable<SelectListItem> GetDealers()
        {
            try
            {
                return  tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false && user.UserTypeId == 3)
                    .Select(user => new SelectListItem { Value = user.Id.ToString(), Text = user.Name });
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IQueryable<SelectListItem> GetTrucks(int truckType=0)
        {
            try
            {
                if (truckType == 1)
                    return tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false && truck.IsInternalTruck)
                       .Select(truck => new SelectListItem { Value = truck.Id.ToString(), Text = truck.TruckNumber, Disabled = truck.IsInternalTruck });
                else if (truckType == 2)
                    return tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false && truck.IsInternalTruck == false)
                   .Select(truck => new SelectListItem { Value = truck.Id.ToString(), Text = truck.TruckNumber, Disabled = truck.IsInternalTruck });
                else
                    return tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false)
                   .Select(truck => new SelectListItem { Value = truck.Id.ToString(), Text = truck.TruckNumber, Disabled = truck.IsInternalTruck }) ;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IQueryable<SelectListItem> GetDrivers()
        {
            try
            {
                IQueryable<SelectListItem> selectListItems = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.UserTypeId == 4)
                   .Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name,Disabled=user.IsInternalDriver });
               // selectListItems.ToList().Add(new SelectListItem { Value = "-999", Text = "Other Diver" });
                return selectListItems;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public IQueryable<SelectListItem> GetAllUser()
        {
            try
            {
                IQueryable<SelectListItem> selectListItems = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false)
                   .Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });
                return selectListItems;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IQueryable<SelectListItem> GetSuppliers()
        {
            try
            {
                IQueryable<SelectListItem> selectListItems= tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && (user.UserTypeId== 3 || user.UserTypeId == 5))
                   .Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });
                //selectListItems.ToList().Add(new SelectListItem { Value = "-999", Text = "Other Supplier" });
                return selectListItems;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IQueryable<SelectListItem> GetCustomers()
        {
            try
            {
                IQueryable<SelectListItem> selectListItems = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && (user.UserTypeId == 2 || user.UserTypeId == 3 || user.UserTypeId == 5))
                   .Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });
                //selectListItems.ToList().Add(new SelectListItem { Value = "-999", Text = "Other Customer" });
                return selectListItems;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public JsonResult GetSites(int userId)
        {
            try
            {
                int UserTypeId = tKTradersDBContext.TUserMasters.Where(user=>user.UserId==userId).Select(user=>user.UserTypeId).FirstOrDefault();
                if (UserTypeId == 3 || UserTypeId == 5)
                {
                    IQueryable<SelectListItem> selectListItems = GetSitesByUser(userId);
                    return Json(new {statusCode=1, selectListItems = selectListItems });
                }
                else
                    return Json(new { statusCode = -404 });
            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -101 });
            }
        }
        public IQueryable<SelectListItem> GetSitesByUser(int userId)
        {
            IQueryable<SelectListItem> selectListItems = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.UserId == userId).Join(tKTradersDBContext.TUserSites, userMaster => userMaster.UserId, userSites => userSites.UserId,
                        (userMaster, userSite) => new SelectListItem { Value = userSite.SiteId.ToString(), Text = userSite.SiteAddress });
            return selectListItems;
        }
        public CommonDataOut GetOtherDrivers(string mobileNumber)
        {
            try
            {
                return tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.IsInternalDriver==false && user.UserTypeId == 4 && user.MobileNumber== mobileNumber)
                   .Select(user => new CommonDataOut { MobileNumber = user.MobileNumber, Name = user.Name,Address=user.Address }).FirstOrDefault();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CommonDataOut GetOtherSuppliers(string mobileNumber)
        {
            try
            {
                return tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false &&  (user.UserTypeId == 3 || user.UserTypeId == 5) && user.MobileNumber==mobileNumber)
                   .Select(user => new CommonDataOut { MobileNumber = user.MobileNumber, Name = user.Name, Address = user.Address }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CommonDataOut GetOtherCustomers(string mobileNumber)
        {
            try
            {
                return tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && (user.UserTypeId == 2 || user.UserTypeId == 3 || user.UserTypeId == 5) && user.MobileNumber== mobileNumber)
                   .Select(user => new CommonDataOut { MobileNumber = user.MobileNumber, Name = user.Name, Address = user.Address }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CommonDataOut GetOtherTrucks(string truckNumber,string mobileNumber)
        {
            try
            {
                TTruck truck= tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false && truck.IsInternalTruck == false && truck.TruckNumber == truckNumber).FirstOrDefault();
                TUserMaster userMaster= null;
                if (truck != null)
                    userMaster = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete==false && user.UserId == truck.UserId).FirstOrDefault();
                if (userMaster != null)
                    return new CommonDataOut { MobileNumber = userMaster.MobileNumber, Name = userMaster.Name, Address = userMaster.Address };
                else
                    return GetUserByMobile(mobileNumber);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CommonDataOut GetUserByMobile(string mobileNumber)
        {
            TUserMaster userMaster = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.MobileNumber == mobileNumber).FirstOrDefault();
            if (userMaster != null)
                return new CommonDataOut { MobileNumber = userMaster.MobileNumber, Name = userMaster.Name, Address = userMaster.Address };
            else
                return new CommonDataOut();
        }

        }
}
