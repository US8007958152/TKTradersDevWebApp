using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using TKTradersWebApp.Areas.Securities.Controllers;
using TKTradersWebApp.Areas.Transports.Models;
using TKTradersWebApp.CommonServices;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Transports.Controllers
{
    [SessionTimeout]
    public class TransportController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;

        private readonly IConfiguration configuration;
        private Common common
        {
            get { return new Common(tKTradersDBContext); }
        }

        public TransportController(TKTradersDBContext tKTradersDBContext, IConfiguration configuration)
        {
            this.tKTradersDBContext = tKTradersDBContext;
            this.configuration = configuration;
        }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult GetTransports()
        {
            IEnumerable<Transport> Transports = getTransports();
            return View(Transports);
        }
        public IActionResult Create()
        {
            loadDropdowns(0);
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Transport transport)
        {
            try
            {
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                loadDropdowns(transport.TTransportProductDetail.ProductId);
                if (transport != null)
                {
                    var tuple = validate(transport);
                    if(!tuple.Item1)
                        return Json(new { statusCode = -101, statusMessage = tuple.Item2 });
                    if (transport.SupplierId == -111)
                        transport.TransportTypeId = 6;
                    else
                        transport.TransportTypeId = 5;

                    if (transport.SupplierId == -999)
                    {
                        int supplierId = common.createUser(5, transport.SupplierMobile, transport.SupplierName, transport.SupplierAddress, loggedUser.Id);
                        if (supplierId > 0)
                            transport.SupplierId = supplierId;
                        else
                            transport.SupplierId = 0;
                    }
                    if (transport.SupplierId == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please select supplier" });
                    if (transport.CustomerId == -999)
                    {
                        int customerId = common.createUser(2, transport.CustomerMobile, transport.CustomerName, transport.CustomerAddress, loggedUser.Id);
                        if (customerId > 0)
                            transport.CustomerId = customerId;
                        else
                            transport.CustomerId = 0;

                    }
                    if (transport.CustomerId == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please select customer" });

                    if (transport.DriverId == -999)
                    {
                        int driverId = common.createUser(4, transport.DriverMobile, transport.DriverName, null, loggedUser.Id, false);
                        if (driverId > 0)
                            transport.DriverId = driverId;
                        else
                            transport.DriverId = 0;                        
                    }
                    else
                    transport.IsInternalDriver= tKTradersDBContext.TUserMasters.Where(user => user.UserId == transport.DriverId).Select(driver => driver.IsInternalDriver).FirstOrDefault(); ;
                    if (transport.DriverId == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please select driver" });

                    if (transport.TruckId == -999)
                    {
                        var _tuple = common.createTruck(transport.TruckNumber, transport.TruckOwnerMobile, transport.TruckOwnerName, null, loggedUser.Id, false);
                        if (_tuple.Item1 > 0)
                        {
                            transport.TruckId = _tuple.Item1;
                            transport.TTransportTruckDetail.TruckOwnerId = _tuple.Item2;
                        }   
                        else
                            transport.TruckId = 0;
                    }
                    else
                    {
                        var _truckDetails= tKTradersDBContext.TTrucks.Where(truck => truck.Id == truck.Id).FirstOrDefault();
                        transport.IsInternalTruck = _truckDetails.IsInternalTruck;
                        transport.TTransportTruckDetail.TruckOwnerId = Convert.ToInt32(_truckDetails.UserId);
                    }
                     
                    if (transport.TruckId == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please select truck" });

                    transport.StatusTypeId = 2;
                    transport.TransportDate= DateTime.Now;
                    transport.CreateDateTime = DateTime.Now;
                    transport.CreatedBy = loggedUser.Id;
                    if (transport.TTransportProductDetail.TotalAmount == transport.TTransportProductDetail.PaidAmount)
                        transport.TTransportProductDetail.PaymentTypeId = 3;
                    else if (transport.TTransportProductDetail.PaidAmount>0 && transport.TTransportProductDetail.TotalAmount != transport.TTransportProductDetail.PaidAmount)
                        transport.TTransportProductDetail.PaymentTypeId = 2;
                    else
                        transport.TTransportProductDetail.PaymentTypeId = 1;

                    if (transport.TTransportTruckDetail.TotalAmount == transport.TTransportTruckDetail.PaidAmount)
                        transport.TTransportTruckDetail.PaymentTypeId = 3;
                    else if (transport.TTransportTruckDetail.PaidAmount > 0 && transport.TTransportTruckDetail.TotalAmount != transport.TTransportTruckDetail.PaidAmount)
                        transport.TTransportTruckDetail.PaymentTypeId = 2;
                    else
                        transport.TTransportTruckDetail.PaymentTypeId = 1;

                    tKTradersDBContext.TTransports.Add(transport);

                    if (tKTradersDBContext.SaveChanges() > 0)
                    {
                        TStock stock = new TStock();
                        stock.OrderId = transport.TransportId;
                        stock.TransportTypeId = transport.TransportTypeId;
                        stock.ProductId = transport.TTransportProductDetail.ProductId;
                        stock.ProductTypeId = transport.TTransportProductDetail.ProductTypeId;
                        stock.Quantity = transport.TTransportProductDetail.Quantity;
                        stock.CreatedDate = DateTime.Now;
                        stock.CreatedBy = loggedUser.Id;
                        tKTradersDBContext.TStocks.Add(stock);
                        tKTradersDBContext.SaveChanges();
                        return Json(new { statusCode = 1, statusMessage = "Transport created Successfully...!" });
                    }
                                    
                }
            }
            catch (Exception ex)
            {
                ViewData["ErrorMessage"] = "Something went wrong, Please contact to administrator";
                tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                tKTradersDBContext.SaveChanges();
                return Json(new { statusCode = -101, statusMessage = "Something went wrong, Please contact to administrator" });
            }
            return Json(new { statusCode = -101, statusMessage = "Error In Data" });
        }

        public IActionResult Edit(int transportId)
        {
            Transport transport1 = new Transport();
            TTransport transport = tKTradersDBContext.TTransports.Where(transport => transport.TransportId == transportId).FirstOrDefault();
            if(transport!=null)
            {

                transport1.SupplierId = transport.SupplierId;
                transport1.CustomerId = transport.CustomerId;
                transport1.TransportId = transport.TransportId;
                transport1.StatusTypeId = transport.StatusTypeId;
                transport1.TruckId = transport.TruckId;
                transport1.DriverId = transport.DriverId;
                transport1.IsInternalTruck = transport.IsInternalTruck;
                transport1.IsInternalDriver = transport.IsInternalDriver;
                transport1.IsObsolete = transport.IsObsolete;
                transport1.Comments = transport.Comments;
                transport1.TTransportProductDetail = tKTradersDBContext.TTransportProductDetails.Where(productDetails => productDetails.TransportId == transport1.TransportId).FirstOrDefault();
                transport1.TTransportTruckDetail = tKTradersDBContext.TTransportTruckDetails.Where(truckDetails => truckDetails.TransportId == transport1.TransportId).FirstOrDefault();
                if (!transport.IsInternalDriver)
                {
                    var _driverDetails = tKTradersDBContext.TUserMasters.Where(_user => _user.UserId == transport1.DriverId).FirstOrDefault();
                    transport1.DriverMobile = _driverDetails.MobileNumber;
                    transport1.DriverName = _driverDetails.Name;
                }
                if (!transport.IsInternalTruck)
                {
                    var _truckOwnerDetails = tKTradersDBContext.TTrucks.Where(_truck => _truck.Id == transport1.TruckId).Join(tKTradersDBContext.TUserMasters,
                        truck => truck.UserId, user => user.UserId, (truck, user) => new { TruckNumber = truck.TruckNumber, MobileNumber = user.MobileNumber, TruckOwnerName = user.Name }).FirstOrDefault();
                    transport1.TruckNumber = _truckOwnerDetails.TruckNumber;
                    transport1.TruckOwnerMobile = _truckOwnerDetails.MobileNumber;
                    transport1.TruckOwnerName = _truckOwnerDetails.TruckOwnerName;
                }
            }
            loadDropdowns(transport1.TTransportProductDetail == null ? 0 : transport1.TTransportProductDetail.ProductId);
            return View(transport1);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int supplierId,Transport transport)
        {
            try
            {
                if (transport.TTransportProductDetail.Quantity == 0)
                    return Json(new { statusCode = -101, statusMessage = "Please Enter Quantity" });
                if (transport.SupplierId == -111 && getAvailableStock(transport.TTransportProductDetail.ProductId, transport.TTransportProductDetail.ProductTypeId) < transport.TTransportProductDetail.Quantity)
                    return Json(new { statusCode = -101, statusMessage = "Quantity can not be more than available stock." });
                if (transport.SupplierId == -111 && transport.TTransportProductDetail.TotalAmount == 0)
                    return Json(new { statusCode = -101, statusMessage = "Please Enter Total Amount" });
                if (transport.SupplierId == -111 && transport.TTransportProductDetail.TotalAmount < transport.TTransportProductDetail.PaidAmount)
                    return Json(new { statusCode = -101, statusMessage = "Paid amount should not be more that total amount" });
                if (transport.TruckId == -999 && transport.TTransportTruckDetail == null)
                    return Json(new { statusCode = -101, statusMessage = "Please Provide Truck Details" });
                if (transport.TruckId == -999 && transport.TTransportTruckDetail.TotalAmount == 0)
                    return Json(new { statusCode = -101, statusMessage = "Please Enter Truck Rent" });
                if (transport.TruckId == -999 && transport.TTransportTruckDetail.TotalAmount < transport.TTransportTruckDetail.PaidAmount)
                    return Json(new { statusCode = -101, statusMessage = "Paid amount should not be more that total amount" });

                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                var _transport = tKTradersDBContext.TTransports.Where(_transport => _transport.TransportId == transport.TransportId).FirstOrDefault();
               
                loadDropdowns(transport.TTransportProductDetail.ProductId);
                if (transport != null && _transport != null)
                {
                    _transport.TTransportProductDetail = tKTradersDBContext.TTransportProductDetails.Where(_transport => _transport.TransportId == transport.TransportId).FirstOrDefault();
                    _transport.TTransportProductDetail.Quantity = transport.TTransportProductDetail.Quantity;
                    _transport.TTransportProductDetail.TotalAmount = transport.TTransportProductDetail.TotalAmount;
                    _transport.TTransportProductDetail.PaidAmount = transport.TTransportProductDetail.PaidAmount;                    

                    _transport.TTransportTruckDetail = tKTradersDBContext.TTransportTruckDetails.Where(_truck => _truck.TransportId == transport.TransportId).FirstOrDefault();

                    if (transport.TruckId == -999 && _transport.TTransportTruckDetail!=null)
                    {
                        _transport.TTransportTruckDetail.TotalAmount = transport.TTransportTruckDetail.TotalAmount;
                        _transport.TTransportTruckDetail.PaidAmount = transport.TTransportTruckDetail.PaidAmount;

                        if (transport.TTransportTruckDetail.TotalAmount == transport.TTransportTruckDetail.PaidAmount)
                            _transport.TTransportTruckDetail.PaymentTypeId = 3;
                        else if (transport.TTransportTruckDetail.PaidAmount > 0 && transport.TTransportTruckDetail.TotalAmount != transport.TTransportTruckDetail.PaidAmount)
                            _transport.TTransportTruckDetail.PaymentTypeId = 2;
                        else
                            _transport.TTransportTruckDetail.PaymentTypeId = 1;
                    }
                    _transport.Comments = transport.Comments;
                    _transport.UpdatedDateTime = DateTime.Now;
                    _transport.UpdatedBy = loggedUser.Id;

                    if (transport.TTransportProductDetail.TotalAmount == transport.TTransportProductDetail.PaidAmount)
                        _transport.TTransportProductDetail.PaymentTypeId = 3;
                    else if (transport.TTransportProductDetail.PaidAmount > 0 && transport.TTransportProductDetail.TotalAmount != transport.TTransportProductDetail.PaidAmount)
                        _transport.TTransportProductDetail.PaymentTypeId = 2;
                    else
                        _transport.TTransportProductDetail.PaymentTypeId = 1;                   

                    tKTradersDBContext.TTransports.Update(_transport);

                    if (tKTradersDBContext.SaveChanges() > 0)
                    {
                        TStock stock = tKTradersDBContext.TStocks.Where(_stock => _stock.OrderId == _transport.TransportId).FirstOrDefault();
                        if (stock == null)
                        {
                            stock = new TStock();
                            stock.OrderId = transport.TransportId;
                            stock.TransportTypeId = transport.TransportTypeId;
                            stock.ProductId = transport.TTransportProductDetail.ProductId;
                            stock.ProductTypeId = transport.TTransportProductDetail.ProductTypeId;
                            stock.Quantity = transport.TTransportProductDetail.Quantity;
                            stock.CreatedDate = DateTime.Now;
                            stock.CreatedBy = loggedUser.Id;
                            tKTradersDBContext.TStocks.Add(stock);

                        }
                        else
                        {
                            stock.Quantity = transport.TTransportProductDetail.Quantity;
                            tKTradersDBContext.TStocks.Update(stock);
                        }
                        tKTradersDBContext.SaveChanges();
                        TempData["SuccessMessage"] = "Transport Updated Successfully...!";
                        return Json(new { statusCode = 1, statusMessage = "Transport Updated Successfully...!" });
                    }
                        
                }
            }
            catch (Exception ex)
            {
                ViewData["ErrorMessage"] = "Something went wrong, Please contact to administrator";
                tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                tKTradersDBContext.SaveChanges();
                return Json(new { statusCode = -101, statusMessage = "Something went wrong, Please contact to administrator" });
            }
            ViewData["ErrorMessage"] = "Error In Data";
            return Json(new { statusCode = -101, statusMessage = "Error In Data" });
        }

        public IActionResult Delete(int transportId)
        {
            
            TTransport transport = tKTradersDBContext.TTransports.Where(transport => transport.TransportId == transportId).FirstOrDefault();
            TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
            if (transport != null)
            {
                transport.IsObsolete = true;
                transport.UpdatedDateTime = DateTime.Now;
                transport.UpdatedBy = loggedUser.Id;
                tKTradersDBContext.TTransports.Update(transport);

                if (tKTradersDBContext.SaveChanges() > 0)
                {
                    TStock stock = tKTradersDBContext.TStocks.Where(_stock => _stock.OrderId == transport.TransportId).FirstOrDefault();
                    stock.IsObsolete = true;
                    tKTradersDBContext.TStocks.Update(stock);
                    tKTradersDBContext.SaveChanges();
                    TempData["SuccessMessage"] = "Transport Deleted Successfully..!";
                }                    
                else
                    TempData["ErrorMessage"] = "Error in deleting data";               
                
            }
            return RedirectToAction("GetTransports");
        }
        private void loadDropdowns(int productId)
        {
            CommonController commonController = new CommonController(tKTradersDBContext);
            ViewBag.ddlSupplier = commonController.GetSuppliers();
            ViewBag.ddlCustomer = commonController.GetCustomers();
            ViewBag.ddlProduct = commonController.GetProducts();
            ViewBag.ddlProductType = commonController.GetProductTypes(productId);
            ViewBag.ddlTruck = commonController.GetTrucks();
            ViewBag.ddlDriver = commonController.GetDrivers();
        }

        private Tuple<bool, string> validate(Transport transport)
        {
            if (transport.SupplierId == 0)
                return new Tuple<bool, string>(false, "Please Select Supplier");
            if (transport.SupplierId == -9999)
            {
                if (string.IsNullOrEmpty(transport.SupplierMobile))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Mobile");
                else if (string.IsNullOrEmpty(transport.SupplierName))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Name");
                else if (string.IsNullOrEmpty(transport.SupplierAddress))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Address");
            }
            if (transport.CustomerId == 0)
                return new Tuple<bool, string>(false, "Please Select Customer");
            if (transport.CustomerId == -9999)
            {
                if (string.IsNullOrEmpty(transport.CustomerMobile))
                    return new Tuple<bool, string>(false, "Please Enter Customer Mobile");
                else if (string.IsNullOrEmpty(transport.CustomerName))
                    return new Tuple<bool, string>(false, "Please Enter Customer Name");
                else if (string.IsNullOrEmpty(transport.CustomerAddress))
                    return new Tuple<bool, string>(false, "Please Enter Customer Address");
            }
            if (transport.TTransportProductDetail == null)
                return new Tuple<bool, string>(false, "Please Provide Product Details");
            if (transport.TTransportProductDetail.ProductId == 0)
                return new Tuple<bool, string>(false, "Please Select Product");
            if (transport.TTransportProductDetail.ProductTypeId == 0)
                return new Tuple<bool, string>(false, "Please Select Product Type");
            if (transport.TTransportProductDetail.Quantity == 0)
                return new Tuple<bool, string>(false, "Please Enter Quantity");
            if(transport.SupplierId == -111 && getAvailableStock(transport.TTransportProductDetail.ProductId, transport.TTransportProductDetail.ProductTypeId)< transport.TTransportProductDetail.Quantity)
                return new Tuple<bool, string>(false, "Quantity can not be more than available stock.");
            if (transport.SupplierId==-111 && transport.TTransportProductDetail.TotalAmount == 0)
                return new Tuple<bool, string>(false, "Please Enter Total Amount");
            if (transport.SupplierId == -111 && transport.TTransportProductDetail.TotalAmount < transport.TTransportProductDetail.PaidAmount)
                return new Tuple<bool, string>(false, "Paid amount should not be more that total amount");

            if (transport.TruckId == 0)
                return new Tuple<bool, string>(false, "Please Select Truck");
            if (transport.TruckId == -9999)
            {
                if (string.IsNullOrEmpty(transport.TruckNumber))
                    return new Tuple<bool, string>(false, "Please Enter Truck Number");
                else if (string.IsNullOrEmpty(transport.TruckOwnerMobile))
                    return new Tuple<bool, string>(false, "Please Enter Truck Owner Mobile");
                else if (string.IsNullOrEmpty(transport.TruckOwnerName))
                    return new Tuple<bool, string>(false, "Please Enter Truck Owner Name");
            }
            if (transport.TTransportTruckDetail == null)
                return new Tuple<bool, string>(false, "Please Provide Truck Details");
            if (transport.TTransportTruckDetail.TotalAmount == 0)
                return new Tuple<bool, string>(false, "Please Enter Truck Rent");
            if (transport.TTransportTruckDetail.TotalAmount < transport.TTransportTruckDetail.PaidAmount)
                return new Tuple<bool, string>(false, "Paid amount should not be more that total amount");

            if (transport.DriverId == 0)
                return new Tuple<bool, string>(false, "Please Select Driver");
            if (transport.DriverId == -9999)
            {
                if (string.IsNullOrEmpty(transport.DriverMobile))
                    return new Tuple<bool, string>(false, "Please Enter Driver Mobile");
                else if (string.IsNullOrEmpty(transport.DriverName))
                    return new Tuple<bool, string>(false, "Please Enter Driver Name");
            }

            return new Tuple<bool, string>(true, "Success");
        }

        private int getAvailableStock(int productId, int productTypeId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[sInventory].[usp_GetAvailableStock]";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@rProductId", productId);
                        cmd.Parameters.AddWithValue("@rProductTypeId", productTypeId);
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);
                            if (ds != null && ds.Tables.Count>0 && ds.Tables[0].Rows.Count > 0)
                                return Convert.ToInt32(ds.Tables[0].Rows[0]["Stock"]);
                            else
                                return 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private IEnumerable<Transport> getTransports()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[sTransport].[usp_GetTransports]";
                        cmd.CommandType = CommandType.StoredProcedure;
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                                return ds.Tables[0].AsEnumerable().Select(transport => new Transport
                                {
                                    TransportId = transport.Field<Int32>("TransportId"),
                                    SupplierName = transport.Field<string>("SupplierName"),
                                    CustomerName = transport.Field<string>("CustomerName"),
                                    ProductName = transport.Field<string>("ProductName"),
                                    TransportTypeId = transport.Field<Int32>("TransportTypeId"),
                                    TransportDate = transport.Field<DateTime>("TransportDate")
                                });
                            else
                                return new List<Transport>();
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
