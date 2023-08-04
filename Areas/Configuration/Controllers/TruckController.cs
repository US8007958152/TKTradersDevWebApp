using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Globalization;
using TKTradersWebApp.Areas.Configuration.Models;
using TKTradersWebApp.Areas.Securities.Controllers;
using TKTradersWebApp.CommonModel;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Configuration.Controllers
{
    [SessionTimeout]
    public class TruckController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;
        private CommonController commonController
        {
            get { return new CommonController(tKTradersDBContext); }
        }
        public TruckController(TKTradersDBContext tKTradersDBContext)
        {
            this.tKTradersDBContext = tKTradersDBContext;
        }
        public IActionResult Trucks()
        {
            IQueryable<TruckView> fTruckView = tKTradersDBContext.TTrucks.Select(truck=> new TruckView { TruckNumber = truck.TruckNumber, Id = truck.Id, IsInternalTruck = truck.IsInternalTruck, TruckOwnerName = truck.UserId == (int)Constant.OwnUserId?"TK Traders": tKTradersDBContext.TUserMasters.Where(x=>x.UserId==truck.UserId).First().Name });
            ;
            return View(fTruckView);
        }
        public IActionResult GetTrucks()
        {
            IQueryable<TruckView> fTruckView = tKTradersDBContext.TTrucks.Join(tKTradersDBContext.TUserMasters,
                truck => truck.UserId, user => user.UserId, (truck, user) => new TruckView { TruckNumber = truck.TruckNumber, Id = truck.Id, IsInternalTruck = truck.IsInternalTruck, TruckOwnerName = user.Name });
            return View();
        }
        public IActionResult GetFuels()
        {
            IQueryable<ViewFuel> fuels = from fuel in tKTradersDBContext.TTruckFuels
                                         join fuelType in tKTradersDBContext.TStaticFuelTypes on fuel.FuelTypeId equals fuelType.Id
                                         join user in tKTradersDBContext.TUserMasters on fuel.PetrolPumpUserId equals user.UserId
                                         join truck in tKTradersDBContext.TTrucks on fuel.TruckId equals truck.Id
                                         select new ViewFuel { Id = fuel.Id, FuelType = fuelType.Title, PetrolPumpName = user.Name, TruckNumber = truck.TruckNumber, Quantity = fuel.Quantity, Rate = fuel.Rate, CurrentReading = fuel.CurrentReading,Amount=fuel.Amount, CreatedDateTime = fuel.CreatedDateTime };
            return View(fuels);
        }
        public IActionResult AddTruck()
        {
            return View();
        }
        [HttpGet]
        public IActionResult AddFuel()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddFuel(TTruckFuel truckFuel)
        {
            try
            {
                var tuple = validate(truckFuel);
                if (!tuple.Item1)
                    return Json(new { statusCode = -101, statusMessage = tuple.Item2 });
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                truckFuel.CreatedDateTime = DateTime.Now;
                truckFuel.CreatedBy = loggedUser.Id;
                tKTradersDBContext.TTruckFuels.Add(truckFuel);
                if (tKTradersDBContext.SaveChanges() > 0)
                    return Json(new { statusCode = 1, statusMessage = "Fuel saved successfully...!" });
                else
                    return Json(new { statusCode = -101, statusMessage = "Error in saving." });
            }
            catch(Exception ex)
            {
                return Json(new { statusCode = -101, statusMessage = "Something went wrong. Please contact to administrator." });
            }
        }

        [HttpGet]
        public IActionResult EditFuel(int fuelId)
        {
            TTruckFuel truckFuel = tKTradersDBContext.TTruckFuels.Where(fuel => fuel.Id == fuelId).FirstOrDefault();
            ViewBag.ddlPetrolPump = commonController.GetUser(7);
            ViewBag.ddlTruck =   tKTradersDBContext.TTrucks.Where(truck => truck.IsObsolete == false && truck.IsInternalTruck)
                       .Select(truck => new SelectListItem { Value = truck.Id.ToString(), Text = truck.TruckNumber});
            return View(truckFuel);
        }
        public IActionResult Delete(int fuelId)
        {
            if (fuelId > 0)
            {              
                    try
                    {

                        TTruckFuel truckFuel = tKTradersDBContext.TTruckFuels.Where(fuel => fuel.Id == fuelId).FirstOrDefault();
                        if (truckFuel != null)
                            tKTradersDBContext.TTruckFuels.Remove(truckFuel);
                        tKTradersDBContext.SaveChanges();
                        TempData["SuccessMessage"] = "Fuel Deleted Successfully..!";
                    }
                    catch (Exception ex)
                    {   
                        TempData["ErrorMessage"] = "Error in deleting data";
                        tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                        tKTradersDBContext.SaveChanges();
                    }
                
            }
            else
                TempData["ErrorMessage"] = "Error in deleting data";
            return RedirectToAction("GetFuels");
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult EditFuel(TTruckFuel truckFuel)
        {
            try
            {
                if (truckFuel.Id == 0)
                    return Json(new { statusCode = -101, statusMessage = "Error in data" });
                var tuple = validate(truckFuel);
                if (!tuple.Item1)
                    return Json(new { statusCode = -101, statusMessage = tuple.Item2 });
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                TTruckFuel truckFuel1= tKTradersDBContext.TTruckFuels.Where(fuel => fuel.Id == truckFuel.Id).FirstOrDefault();
                if(truckFuel1==null)
                    return Json(new { statusCode = -101, statusMessage = "Error in data" });
                truckFuel1.FuelTypeId = truckFuel.FuelTypeId;
                truckFuel1.PetrolPumpUserId = truckFuel.PetrolPumpUserId;
                truckFuel1.TruckId = truckFuel.TruckId;
                truckFuel1.Quantity = truckFuel.Quantity;
                truckFuel1.Rate = truckFuel.Rate;
                truckFuel1.CurrentReading = truckFuel.CurrentReading;
                truckFuel1.Amount = truckFuel.Amount;
                truckFuel1.Comments = truckFuel.Comments;
                truckFuel1.UpdatedDateTime = DateTime.Now;
                truckFuel1.UpdatedBy = loggedUser.Id;
                tKTradersDBContext.TTruckFuels.Update(truckFuel1);
                if (tKTradersDBContext.SaveChanges() > 0)
                    return Json(new { statusCode = 1, statusMessage = "Fuel saved successfully...!" });
                else
                    return Json(new { statusCode = -101, statusMessage = "Error in saving." });
            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -101, statusMessage = "Something went wrong. Please contact to administrator." });
            }
        }

        public IActionResult GetInvoice()
        {
            return View();
        }
        [HttpPost]
        public IActionResult GetInvoice(int PetrolPumpUserId,string FromDate,string ToDate)
        {
            try
            {
                if (PetrolPumpUserId == 0)
                {
                    TempData["ErrorMessage"] = "Please Select Petrol Pump";
                    return View();
                }
                TUserMaster userMaster = tKTradersDBContext.TUserMasters.Where(x => x.UserId == PetrolPumpUserId && x.UserTypeId == 7).FirstOrDefault();
                if (userMaster == null)
                {
                    TempData["ErrorMessage"] = "Please Select Valid Petrol Pump";
                    return View();
                }
                DateTime _FromDate, _ToDate;
                if (string.IsNullOrEmpty(FromDate))
                    _FromDate = Convert.ToDateTime("01/01/1900");
                else
                {
                    var _fromdate = FromDate.Split("/", StringSplitOptions.RemoveEmptyEntries);
                    _FromDate = new DateTime(Convert.ToInt32(_fromdate[2]), Convert.ToInt32(_fromdate[1]), Convert.ToInt32(_fromdate[0]));
                }
                if (string.IsNullOrEmpty(ToDate))
                    _ToDate = Convert.ToDateTime("01/01/9999");
                else
                {
                    var _todate = ToDate.Split("/", StringSplitOptions.RemoveEmptyEntries);
                    _ToDate = new DateTime(Convert.ToInt32(_todate[2]), Convert.ToInt32(_todate[1]), Convert.ToInt32(_todate[0]));
                }

                ViewInvoice viewInvoice = new ViewInvoice();
                viewInvoice.UserName = userMaster.Name;
                viewInvoice.UserAddress = userMaster.Address + " " + getAddress(userMaster.CityId, userMaster.DistrictId, userMaster.StateId);
                viewInvoice.UserMobile = userMaster.MobileNumber;
                viewInvoice.EmailAddress = userMaster.EmailId;
                viewInvoice.DateRange = FromDate + " to " + ToDate;
                var totalsentamount = tKTradersDBContext.TUserTransactions.Where(x => x.UserId == PetrolPumpUserId && x.TransactionTypeId == 1 && x.CreatedDate.Date >= _FromDate.Date && x.CreatedDate.Date <= _ToDate.Date).Sum(x => x.Amount);
                var totalFuelAmount = tKTradersDBContext.TTruckFuels.Where(x => x.PetrolPumpUserId == PetrolPumpUserId && x.CreatedDateTime.Date >= _FromDate.Date && x.CreatedDateTime.Date <= _ToDate.Date).Sum(x => x.Amount);
                var finalAmount = totalFuelAmount - totalsentamount;
                viewInvoice.FuelAmount = totalFuelAmount;
                viewInvoice.SentAmount = totalsentamount;
                viewInvoice.FinalAmount = finalAmount;
                IQueryable<ViewFuel> fuels = from fuel in tKTradersDBContext.TTruckFuels.Where(x => x.PetrolPumpUserId == PetrolPumpUserId && x.CreatedDateTime.Date >= _FromDate.Date && x.CreatedDateTime.Date <= _ToDate.Date)
                                             join fuelType in tKTradersDBContext.TStaticFuelTypes on fuel.FuelTypeId equals fuelType.Id
                                             join user in tKTradersDBContext.TUserMasters on fuel.PetrolPumpUserId equals user.UserId
                                             join truck in tKTradersDBContext.TTrucks on fuel.TruckId equals truck.Id
                                             select new ViewFuel { Id = fuel.Id, FuelType = fuelType.Title, PetrolPumpName = user.Name, TruckNumber = truck.TruckNumber, Quantity = fuel.Quantity, Rate = fuel.Rate, CurrentReading = fuel.CurrentReading, Amount = fuel.Amount, CreatedDateTime = fuel.CreatedDateTime };
                viewInvoice.viewFuels = fuels;
                return View(viewInvoice);
            }
            catch(Exception ex)
            {
                TempData["ErrorMessage"] = "Error in data. Please contact to administrator";
                return View();
            }
           
        }
        private string getAddress(int cityId, int districtId, int stateId)
        {
            string address = string.Empty;
            address = (from city in tKTradersDBContext.TCities.Where(city => city.Id == cityId)
                       join district in tKTradersDBContext.TDistricts.Where(district => district.Id == districtId) on city.DistrictId equals district.Id
                       join state in tKTradersDBContext.TStates.Where(state => stateId == state.Id) on district.StateId equals state.Id
                       select city.Name + ", " + district.Name + " -" + state.Name).FirstOrDefault()??"";
            return address;
        }
        private Tuple<bool, string> validate(TTruckFuel truckFuel)
        {
            if (truckFuel==null)
                return new Tuple<bool, string>(false, "Please Enter Valid Details");
            if (truckFuel.FuelTypeId == 0)
                return new Tuple<bool, string>(false, "Please Select Fuel Type");
            if (truckFuel.PetrolPumpUserId == 0)
                return new Tuple<bool, string>(false, "Please Select Petrolpump");
            if (truckFuel.TruckId == 0)
                return new Tuple<bool, string>(false, "Please Select Truck");
            //if (truckFuel.Quantity == 0)
            //    return new Tuple<bool, string>(false, "Please Enter Quantity");
            //if (truckFuel.Rate == 0)
            //    return new Tuple<bool, string>(false, "Please Enter Rate Per Litre");
            //if (truckFuel.Amount != RoundUp(truckFuel.Quantity * truckFuel.Rate))
            //    return new Tuple<bool, string>(false, "Please Enter Valid Quantity");
            //if (truckFuel.CurrentReading == 0)
            //    return new Tuple<bool, string>(false, "Please Enter Current Reading");
            if (truckFuel.Amount == 0)
                return new Tuple<bool, string>(false, "Please Enter Amount");

            return new Tuple<bool, string>(true, "Success");
        }
        public decimal RoundUp(decimal input)
        {
            double inputNumber=Convert.ToDouble(input);
            double multiplier = Math.Pow(10, 2);
            return Convert.ToDecimal(Math.Ceiling(inputNumber * multiplier) / multiplier);
        }
    }
}
