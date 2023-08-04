using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;
using TKTradersWebApp.Areas.Dashboard.Models;
using TKTradersWebApp.CommonModel;
using TKTradersWebApp.CommonServices;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Dashboard.Controllers
{
    [SessionTimeout]
    public class DefaultController : Controller
    {

        private readonly TKTradersDBContext tKTradersDBContext;
        private readonly IConfiguration configuration;
        public DefaultController(TKTradersDBContext tKTradersDBContext, IConfiguration configuration)
        {
            this.tKTradersDBContext = tKTradersDBContext;
            this.configuration = configuration;
        }
        private Common common
        {
            get { return new Common(tKTradersDBContext); }
        }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Configuration()
        {
            ViewBag.ddlTruckOwner = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && user.UserTypeId == 6).Select(user =>
            new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddTruck(Truck truck)
        {
            TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
            var _truck = tKTradersDBContext.TTrucks.Where(_truck => _truck.TruckNumber.Trim() == truck.TruckNumber.Trim()).FirstOrDefault();
            if(_truck==null)
            {
                if (truck.UserId == (int)Constant.Others)
                {
                    var _tuple = common.createTruck(truck.TruckNumber, truck.TruckOwnerMobile, truck.TruckOwnerName, null, loggedUser.Id, false);
                    if (_tuple.Item1 > 0)
                        return Json(new { statusCode = 1, statusMessage = "Truck details saved successfully...!" });
                    else
                        return Json(new { statusCode = -101, statusMessage = "Error in saving...!" });

                }
                else
                {
                    truck.CreatedDate = DateTime.Now;
                    truck.CreatedBy = loggedUser.Id;
                    if(truck.UserId == (int)Constant.OwnUserId)
                        truck.IsInternalTruck = true;
                    tKTradersDBContext.TTrucks.Add(truck);
                    if (tKTradersDBContext.SaveChanges() > 0)
                        return Json(new { statusCode = 1, statusMessage = "Truck details saved successfully...!" });
                    else
                        return Json(new { statusCode = -101, statusMessage = "Error in saving...!" });
                }
            }
            else
                return Json(new { statusCode = -101, statusMessage = "Truck is already exists...!" });

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddFuel(Truck truck)
        {
            TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
            var _truck = tKTradersDBContext.TTrucks.Where(_truck => _truck.TruckNumber.Trim() == truck.TruckNumber.Trim()).FirstOrDefault();
            if (_truck == null)
            {
                if (truck.UserId == (int)Constant.Others)
                {
                    var _tuple = common.createTruck(truck.TruckNumber, truck.TruckOwnerMobile, truck.TruckOwnerName, null, loggedUser.Id, false);
                    if (_tuple.Item1 > 0)
                        return Json(new { statusCode = 1, statusMessage = "Truck details saved successfully...!" });
                    else
                        return Json(new { statusCode = -101, statusMessage = "Error in saving...!" });

                }
                else
                {
                    truck.CreatedDate = DateTime.Now;
                    truck.CreatedBy = loggedUser.Id;
                    if (truck.UserId == (int)Constant.OwnUserId)
                        truck.IsInternalTruck = true;
                    tKTradersDBContext.TTrucks.Add(truck);
                    if (tKTradersDBContext.SaveChanges() > 0)
                        return Json(new { statusCode = 1, statusMessage = "Truck details saved successfully...!" });
                    else
                        return Json(new { statusCode = -101, statusMessage = "Error in saving...!" });
                }
            }
            else
                return Json(new { statusCode = -101, statusMessage = "Truck is already exists...!" });

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddDriver(TUserMaster userMaster)
        {
            TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
            var _userMaster = tKTradersDBContext.TUserMasters.Where(_userMaster => _userMaster.MobileNumber.Trim() == userMaster.MobileNumber.Trim()).FirstOrDefault();
            if (_userMaster == null)
            {
                userMaster.CreatedDateTime = DateTime.Now;
                userMaster.CreatedBy = loggedUser.Id;
                tKTradersDBContext.TUserMasters.Add(userMaster);
                if (tKTradersDBContext.SaveChanges() > 0)
                    return Json(new { statusCode = 1, statusMessage = "Driver details saved successfully...!" });
                else
                    return Json(new { statusCode = -101, statusMessage = "Error in saving...!" });
            }
            else
                return Json(new { statusCode = -101, statusMessage = "Driver is already exists...!" });

        }

        public IActionResult GetDashboard()
        {
            try
            {
                return Json(getDashboardData());
            }
            catch (Exception ex)
            {
                return Json("");
            }
        }

        private string getDashboardData()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "sSecurity.usp_GetDashBoard";
                        cmd.CommandType = CommandType.StoredProcedure;
                        
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);
                            return JsonConvert.SerializeObject(ds);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
