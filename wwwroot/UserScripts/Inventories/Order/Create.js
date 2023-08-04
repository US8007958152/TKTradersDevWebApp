$(document).ready(function () {
    showOrHideUserDetails('hide');
    showOrHideTruckDetails('hide');
    showOrHideDriverDetails('hide');
    loadStocks();
    $("#ddlTransportType").change(function () {
        changeTransportTypeEvent();
    });
    $("#ddlSupplier").change(function () {
        if ($(this).val() == '-999')
            showOrHideSupplierDetails('show');
        else
            showOrHideSupplierDetails('hide');

    });
    $("#ddlCustomer").change(function () {
        if ($(this).val() == '-999')
            showOrHideCustomerDetails('show');
        else
            showOrHideCustomerDetails('hide');
    });
    $("#ddlTruck").change(function () {
        if ($(this).val() == '-999')
            showOrHideTruckDetails('show');
        else
            showOrHideTruckDetails('hide');
    });
    $("#ddlDriver").change(function () {
        if ($(this).val() == '-999')
            showOrHideDriverDetails('show');
        else
            showOrHideDriverDetails('hide');
    });

    $('#SupplierMobile,#CustomerMobile,#TruckOwnerMobile,#DriverMobile').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $('#productTotalAmount,#productPaidAmount,#Quantity,#truckTotalAmount,#truckPaidAmount').on('paste', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });

    $("#SupplierMobile").change(function () {
        if ($(this).val().length == 10)
            getOtherSupplier($(this).val());
        else {

            $("#SupplierName").val('');
            $("#SupplierAddress").val('');
        }
    });
    $("#CustomerMobile").change(function () {
        if ($(this).val().length == 10)
            getOtherCustomer($(this).val());
        else {

            $("#CustomerName").val('');
            $("#CustomerAddress").val('');
        }
    })
    $("#DriverMobile").change(function () {
        if ($(this).val().length == 10)
            getOtherDriver($(this).val());
        else {
            $("#DriverName").val('');
        }
    })
    $("#TruckOwnerMobile,#TruckNumber").change(function () {
        if ($("#TruckNumber").val() != "" || $("#TruckOwnerMobile").val().length == 10)
            getOtherTruck($("#TruckNumber").val(), $("#TruckOwnerMobile").val());
        else {

            $("#TruckOwnerName").val('');
            $("#TruckOwnerAddress").val('');
        }
    });
    $("#ddlProduct").change(function () {
        loadProductTypes();
    });

    $("#btnSave").click(function () {
        if (validateForm()) {
            createTransport();
        }
    });

    $("#productPaidAmount").keyup(function () {
        if (parseFloat($(this).val()) > parseFloat($("#productTotalAmount").val())) {
            toastr.error("Paid amount should not be more that total amount");
            return false;
        }
    })
    $("#truckPaidAmount").keyup(function () {
        if (parseFloat($(this).val()) > parseFloat($("#truckTotalAmount").val())) {
            toastr.error("Paid amount should not be more that total amount");
            return false;
        }
    });
    $("#ddlSupplier").change(function () {
        $("#ddlProduct").val('');
        $("#ddlProductType").val('');
        loadStocks();
    });
    $("#ddlProductType").change(function () {
        loadStocks();
    });
    $("#Quantity").keyup(function () {
        if ($("#ddlTransportType").val() == "2" && parseFloat($("#hdnAvailableStock").val()) < parseFloat($(this).val()))
        {
            var quantity = $(this).val();            
            quantity = quantity.slice(0, -1);
            $("#Quantity").val(quantity);
            toastr.error('Available ' + $("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock: ' + $("#hdnAvailableStock").val());
            return false;
        }
    });
    $("#btnReset").click(function () {
        ResetForm();
    })
});
function changeTransportTypeEvent() {
    if ($("#ddlTransportType").val() == '1') {
        $("#ddlCustomer").val('');
        $("#ddlCustomer").removeAttr('required');
        $("#ddlCustomer").closest('.j-unit').hide();
        showOrHideCustomerDetails('hide');
        $("#ddlSupplier").attr('required', true);
        $("#ddlSupplier").closest('.j-unit').show();
    }
    else if ($("#ddlTransportType").val() == '2') {
        $("#ddlSupplier").val('');
        $("#ddlSupplier").removeAttr('required');
        $("#ddlSupplier").closest('.j-unit').hide();
        showOrHideSupplierDetails('hide');
        $("#ddlCustomer").attr('required', true);
        $("#ddlCustomer").closest('.j-unit').show();
    }
    else {
        $("#ddlCustomer").val('');
        $("#ddlSupplier").val('');
        $("#ddlSupplier,#ddlCustomer").removeAttr('required');
        $("#ddlSupplier,#ddlCustomer").closest('.j-unit').hide();
        showOrHideCustomerDetails('hide');
        showOrHideSupplierDetails('hide');
    }
}

function loadProductTypes() {
    var ddlProductType = '<option value="" selected>Select Product Type</option>';
    $.ajax({
        url: "/Securities/Common/GetProductTypesDropdown?productId=" + $("#ddlProduct").val(),
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlProductType += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlProductType").html(ddlProductType);
        },
        error: function (error) {
            $("#ddlProductType").html(ddlProductType);
            console.log(error);
        },
        complete: function () {

        }
    })
}

function showOrHideUserDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#ddlSupplier,#ddlCustomer").val('');
        $("#ddlSupplier,#ddlCustomer").removeAttr('required');
        $("#ddlSupplier,#ddlCustomer").closest('.j-unit').hide();
        showOrHideSupplierDetails('hide');
        showOrHideCustomerDetails('hide');
    }
}

function showOrHideSupplierDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#SupplierMobile,#SupplierName,#SupplierAddress").val('');
        $("#SupplierMobile,#SupplierName,#SupplierAddress").removeAttr('required');
        $("#SupplierMobile,#SupplierName,#SupplierAddress").closest('.j-unit').hide();
    }
    else {

        $("#SupplierMobile,#SupplierName,#SupplierAddress").attr('required', true);
        $("#SupplierMobile,#SupplierName,#SupplierAddress").closest('.j-unit').show();
    }
}
function showOrHideCustomerDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#CustomerMobile,#CustomerName,#CustomerAddress").val('');
        $("#CustomerMobile,#CustomerName,#CustomerAddress").removeAttr('required');
        $("#CustomerMobile,#CustomerName,#CustomerAddress").closest('.j-unit').hide();
    }
    else {
        $("#CustomerMobile,#CustomerName,#CustomerAddress").attr('required', true);
        $("#CustomerMobile,#CustomerName,#CustomerAddress").closest('.j-unit').show();
    }
}
function showOrHideTruckDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#truckTotalAmount,#truckPaidAmount,#TruckOwnerMobile,#TruckOwnerName,#TruckNumber,#TruckRent").val('');
        $("#truckTotalAmount,#TruckOwnerMobile,#TruckOwnerName,#TruckNumber,#TruckRent").removeAttr('required');
        $("#truckTotalAmount,#truckPaidAmount,#TruckOwnerMobile,#TruckOwnerName,#TruckNumber,#TruckRent").closest('.j-unit').hide();
    }
    else {
        $("#truckTotalAmount,#TruckOwnerMobile,#TruckOwnerName,#TruckNumber,#TruckRent").attr('required', true);
       $("#truckTotalAmount,#truckPaidAmount,#TruckOwnerMobile,#TruckOwnerName,#TruckNumber,#TruckRent").closest('.j-unit').show();
    }
}

function showOrHideDriverDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#DriverMobile,#DriverName").val('');
        $("#DriverMobile,#DriverName").removeAttr('required');
        $("#DriverMobile,#DriverName").closest('.j-unit').hide();
    }
    else {
        $("#DriverMobile,#DriverName").attr('required', true);
        $("#DriverMobile,#DriverName").closest('.j-unit').show();
    }
}

function getOtherSupplier(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherSuppliers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response !== undefined && response != null) {
                $("#SupplierMobile").val(response.mobileNumber);
                $("#SupplierName").val(response.name);
                $("#SupplierAddress").val(response.address);
            }
            else {
                $("#SupplierName").val('');
                $("#SupplierAddress").val('');
            }

        },
        error: function (error) {

            $("#SupplierName").val('');
            $("#SupplierAddress").val('');
        },
        complete: function () {

        }
    })
}
function getOtherCustomer(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherCustomers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response !== undefined && response != null) {
                $("#CustomerMobile").val(response.mobileNumber);
                $("#CustomerName").val(response.name);
                $("#CustomerAddress").val(response.address);
            }
            else {
                $("#CustomerName").val('');
                $("#CustomerAddress").val('');
            }

        },
        error: function (error) {

        },
        complete: function () {

        }
    })
}
function getOtherTruck(truckNumber, mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherTrucks?truckNumber=" + truckNumber + "&mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response !== undefined && response != null) {
                if (response.mobileNumber!=null)
                    $("#TruckOwnerMobile").val(response.mobileNumber);
                if (response.name != null)
                $("#TruckOwnerName").val(response.name);
            }
            else {
                $("#TruckOwnerName").val('');
            }

        },
        error: function (error) {

        },
        complete: function () {

        }
    })
}
function getOtherDriver(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherDrivers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response !== undefined && response != null) {
                $("#DriverMobile").val(response.mobileNumber);
                $("#DriverName").val(response.name);

            }
            else {
                //$("#DriverMobile").val(response.mobileNumber);
                $("#DriverName").val(response.name);
            }
        },
        error: function (error) {

        },
        complete: function () {

        }
    })
}
function loadStocks() {
    if ($("#ddlTransportType").val() == "2" && $("#ddlProduct").val() != "" && $("#ddlProductType").val() != "") {
        $.ajax({
            url: "/Inventories/Stock/GetStock?productId=" + $("#ddlProduct").val() + "&productTypeId=" + $("#ddlProductType").val() + "&transportId=" + $("#hdnTransportId").val(),
            type: "GET",
            dataType: "json",
            beforeSend: function () {

            },
            success: function (response) {
                if (response.statusCode > 0) {
                    var stock = $.parseJSON(response.data);
                    var availableStock = parseFloat(stock.Table[0].Stock);
                    if (availableStock > 0) {
                        $("#hdnAvailableStock").val(stock.Table[0].Stock);
                        toastr.info('Available stock: ' + stock.Table[0].Stock);
                    }
                    else {
                        $("#hdnAvailableStock").val(0);
                        toastr.error($("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock is not available');
                    }
                }
                else {
                    $("#hdnAvailableStock").val(0);
                    toastr.error($("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock is not available');
                }
            },
            error: function (error) {
                toastr.error($("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock is not available');
                $("#hdnAvailableStock").val(0);
                console.log(error);
            },
            complete: function () {

            }
        })
    }
    else {

        $("#hdnAvailableStock").val(0);
    }
}
function validateForm() {
    var returnValue = true;
    $('form#frmUserInfo').find('select,input').each(function () {
        if ($(this).prop('required') && ($(this).val() == '' || $(this).val() == null)) {
            var message = $(this).closest('.j-unit').find('.j-label').text();
            if ($(this).prop('type') == 'text')
                toastr.error("Please Enter " + message);
            else
                toastr.error("Please Select " + message);
            $(this).focus();
            returnValue = false;
            return returnValue;
        }
    });
    if ($("#ddlSupplier").val() == '-111' && returnValue && (parseFloat($("#hdnAvailableStock").val()) < parseFloat($("#Quantity").val()))) {
        toastr.error('Available ' + $("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock: ' + $("#hdnAvailableStock").val());
        returnValue = false;
    }
    if (returnValue && $("#SupplierMobile").length > 0 && $("#SupplierMobile").prop('required') && $("#SupplierMobile").val().length != 10) {
        toastr.error('Pealse enter valid 10 digit mobile number');
        $("#SupplierMobile").focus();
        returnValue = false;
        return returnValue;
    }
    if (returnValue && $("#CustomerMobile").length > 0 && $("#CustomerMobile").prop('required') && $("#CustomerMobile").val().length != 10) {
        toastr.error('Pealse enter valid 10 digit mobile number');
        $("#CustomerMobile").focus();
        returnValue = false;
        return returnValue;
    }
    if (returnValue && $("#TruckOwnerMobile").length > 0 && $("#TruckOwnerMobile").prop('required') && $("#TruckOwnerMobile").val().length != 10) {
        toastr.error('Pealse enter valid 10 digit mobile number');
        $("#TruckOwnerMobile").focus();
        returnValue = false;
        return returnValue;
    }
    if (returnValue && $("#DriverMobile").length > 0 && $("#DriverMobile").prop('required') && $("#DriverMobile").val().length != 10) {
        toastr.error('Pealse enter valid 10 digit mobile number');
        $("#DriverMobile").focus();
        returnValue = false;
        return returnValue;
    }
    return returnValue;
}
function createTransport() {
    $("#btnSave").attr('disabled', true);
    var TTransportProductDetail = { ProductId: $("#ddlProduct").val(), ProductTypeId: $("#ddlProductType").val(), Quantity: $("#Quantity").val(), TotalAmount: $("#productTotalAmount").val(), PaidAmount: $("#productPaidAmount").val() };
    var TTransportTruckDetail = { TotalAmount: $("#truckTotalAmount").val(), PaidAmount: $("#truckPaidAmount").val() };
    var token = $('input[name="__RequestVerificationToken"]').val();
    var apiUrl = '';
    var transportId = 0;
    if ($("#hdnTransportId").length > 0) {
        transportId = $("#hdnTransportId").val();
        apiUrl = "/Transports/Transport/Edit";
    }
    else
        apiUrl = "/Inventories/Order/Create";
    var formData = {
        TransportTypeId: $("#ddlTransportType").val(),
        TransportId: transportId,
        SupplierId: $("#ddlSupplier").val(),
        SupplierMobile: $("#SupplierMobile").val(),
        SupplierName: $("#SupplierName").val(),
        SupplierAddress: $("#SupplierAddress").val(),
        CustomerId: $("#ddlCustomer").val(),
        CustomerMobile: $("#CustomerMobile").val(),
        CustomerName: $("#CustomerName").val(),
        CustomerAddress: $("#CustomerAddress").val(),
        TruckId: $("#ddlTruck").val(),
        TruckNumber: $("#TruckNumber").val(),
        TruckOwnerMobile: $("#TruckOwnerMobile").val(),
        TruckOwnerName: $("#TruckOwnerName").val(),
        DriverId: $("#ddlDriver").val(),
        DriverName: $("#DriverName").val(),
        DriverMobile: $("#DriverMobile").val(),
        Comments: $("#Comments").val(),
        TTransportProductDetail: TTransportProductDetail,
        TTransportTruckDetail: TTransportTruckDetail
    }
    $.ajax({
        type: "POST",
        url: apiUrl,
        data: { __RequestVerificationToken: token, transport: formData },
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response.statusCode > 0) {
                toastr.success(response.statusMessage);
                $("#btnReset").trigger("click");
            }
            else
                toastr.error(response.statusMessage);
        },
        complete: function () {
            $("#btnSave").removeAttr('disabled');
        },
        error: function (error) {
            console.log(error);
            toastr.error(response.statusMessage);
        }
    })
}


function ResetForm() {
    showOrHideSupplierDetails('hide');
    showOrHideCustomerDetails('hide');
    showOrHideTruckDetails('hide');
    showOrHideDriverDetails('hide');    
}