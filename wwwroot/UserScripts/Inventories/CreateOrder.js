$(document).ready(function () {
    loadProducts();
    loadDrivers();
    loadTrucks();
    $("#ddlDealer,#CustomerMobile,#CustomerName,#CustomerAddress,#DriverName,#DriverMobile,#TruckNumber").closest('.j-unit').hide();
    $('#CustomerMobile').on('paste keypress',function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;
       
    });
    $('#DriverMobile').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $('#Quantity').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $('#TotalAmount').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $('#PaidAmount').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $("#ddlUserType").change(function () {
        showOrHideCustomerDetails();
    });
    var date = new Date();
    $("#OrderDate").dateDropper({
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c",
        dropBorder: "1px solid #1abc9c",
        defaultDate: date,
        format: 'd/m/Y',
        maxYear: 2050,
        minYear: 2010,
        
    })

    $("#btnSave").click(function () {
        if (validateForm()) {
            createOrder();
        }
    });
    $("select").change(function () {
        if ($(this).val() == null || $(this).val().trim() == '') {
            $(this).closest('.j-input').removeClass('j-success-view').find('span').remove();
            $(this).closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select user type</span>');
            $(this).focus();
            return false;
        }
        else {
            $(this).closest('.j-input').removeClass('j-error-view').find('span').remove();
            $(this).closest('.j-input').addClass('j-success-view');
        }
    });
    $("input").keyup(function () {
        if ($(this).val() == null || $(this).val().trim() == '') {
            $(this).closest('.j-input').removeClass('j-success-view').find('span').remove();
            $(this).closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter valid input</span>');
            $(this).focus();
            return false;
        }
        else {
            $(this).closest('.j-input').removeClass('j-error-view').find('span').remove();
            $(this).closest('.j-input').addClass('j-success-view');
        }
    });

    $("#ddlProduct").change(function () {
        loadProductTypes();
    });

    $("#chkOtherDriver").change(function () {
        showOrHideDriverDetails();
    });
    $("#chkOtherTruck").change(function () {
        showOrHideTruckDetails();
    });
    $("#btnReset").click(function () {
        ResetForm();
    });
    $("#ddlPaymentType").change(function () {
        if ($(this).val() == '' || parseInt($(this).val()) == 1) {
            $("#PaidAmount").val('0');
            $("#PaidAmount").attr('disabled', true);
        }
        else {
            $("#PaidAmount").val('');
            $("#PaidAmount").removeAttr('disabled');
        }
    })
    $("#ddlProductType").change(function () {
        loadStocks();
    });
    $("#ddlTransportType").change(function () {
        $("#ddlProduct").val('');
        $("#ddlProductType").val('');
        loadStocks();
    });

})

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
function loadProducts() {
    var ddlProduct = '<option value="" selected>Select Product</option>';
    $.ajax({
        url: "/Securities/Common/GetProductsDropdown",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlProduct += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlProduct").html(ddlProduct);
        },
        error: function (error) {
            $("#ddlProduct").html(ddlProduct);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function loadDealers() {
    var ddlDealer = '<option value="" selected>Select Dealer</option>';
    $.ajax({
        url: "/Securities/Common/GetDealersDropdown",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlDealer += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlDealer").html(ddlDealer);
        },
        error: function (error) {
            $("#ddlDealer").html(ddlDealer);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function loadDrivers() {
    var ddlDriver = '<option value="" selected>Select Drivers</option>';
    $.ajax({
        url: "/Securities/Common/GetDriversDropdown",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlDriver += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlDriver").html(ddlDriver);
        },
        error: function (error) {
            $("#ddlDriver").html(ddlDriver);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function loadTrucks() {
    var ddlTruck = '<option value="" selected>Select Truck</option>';
    $.ajax({
        url: "/Securities/Common/GetTrucksDropdown",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlTruck += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlTruck").html(ddlTruck);
        },
        error: function (error) {
            $("#ddlTruck").html(ddlTruck);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function loadStocks() {
    if ($("#ddlTransportType").val() == "2" && $("#ddlProduct").val() != "" && $("#ddlProductType").val() != "") {
        $.ajax({
            url: "/Inventories/Stock/GetStock?productId=" + $("#ddlProduct").val() + "&productTypeId=" + $("#ddlProductType").val(),
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
                        $(".show-stock").text('Available stock: ' + stock.Table[0].Stock);
                    }
                    else {
                        $("#hdnAvailableStock").val(0);
                        $(".show-stock").text('Stock is not available');
                    }
                }
                else {
                    $("#hdnAvailableStock").val(0);
                    $(".show-stock").text('Stock is not available');
                }
            },
            error: function (error) {
                $(".show-stock").text('Stock is not available');
                $("#hdnAvailableStock").val(0);
                console.log(error);
            },
            complete: function () {

            }
        })
    }
    else {
        $(".show-stock").text('');
        $("#hdnAvailableStock").val(0);
    }        
}

function validateForm() {

    if ($("#ddlUserType").val() == null || $("#ddlUserType").val().trim() == '') {
        $("#ddlUserType").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlUserType").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select user type</span>');
        $("#ddlUserType").focus();
        return false;
    }
    else {
        $("#ddlUserType").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlUserType").closest('.j-input').addClass('j-success-view');
    }
    if ($("#ddlUserType").val() == "2") {
        if ($("#CustomerMobile").val() == null || $("#CustomerMobile").val().trim() == '') {
            $("#CustomerMobile").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#CustomerMobile").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter customer mobile</span>');
            $("#CustomerMobile").focus();
            return false;
        }
        else if ($("#CustomerMobile").val().length != 10) {
            $("#CustomerMobile").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#CustomerMobile").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter 10 digit mobile number</span>');
            $("#CustomerMobile").focus();
            return false;
        }
        else {
            $("#CustomerMobile").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#CustomerMobile").closest('.j-input').addClass('j-success-view');
        }
        if ($("#CustomerName").val() == null || $("#CustomerName").val().trim() == '') {
            $("#CustomerName").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#CustomerName").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter customer names</span>');
            $("#CustomerName").focus();
            return false;
        }
        else {
            $("#CustomerName").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#CustomerName").closest('.j-input').addClass('j-success-view');
        }
        if ($("#CustomerAddress").val() == null || $("#CustomerAddress").val().trim() == '') {
            $("#CustomerAddress").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#CustomerAddress").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter customer address</span>');
            $("#CustomerAddress").focus();
            return false;
        }
        else {
            $("#CustomerAddress").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#CustomerAddress").closest('.j-input').addClass('j-success-view');
        }
    }
    if ($("#ddlUserType").val() == "3") {
        if ($("#ddlDealer").val() == null || $("#ddlDealer").val().trim() == '') {
            $("#ddlDealer").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#ddlDealer").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select dealer</span>');
            $("#ddlDealer").focus();
            return false;
        }
        else {
            $("#ddlDealer").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#ddlDealer").closest('.j-input').addClass('j-success-view');
        }
    }
    if ($("#ddlTransportType").val() == null || $("#ddlTransportType").val().trim() == '') {
        $("#ddlTransportType").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlTransportType").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select transport type</span>');
        $("#ddlTransportType").focus();
        return false;
    }
    else {
        $("#ddlTransportType").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlTransportType").closest('.j-input').addClass('j-success-view');
    }

    if ($("#OrderDate").val() == null || $("#OrderDate").val().trim() == '') {
        $("#OrderDate").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#OrderDate").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select date</span>');
        $("#OrderDate").focus();
        return false;
    }
    else {
        $("#OrderDate").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#OrderDate").closest('.j-input').addClass('j-success-view');
    }

    if ($("#ddlStatus").val() == null || $("#ddlStatus").val().trim() == '') {
        $("#ddlStatus").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlStatus").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select status</span>');
        $("#ddlStatus").focus();
        return false;
    }
    else {
        $("#ddlStatus").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlStatus").closest('.j-input').addClass('j-success-view');
    }

    if ($("#ddlProduct").val() == null || $("#ddlProduct").val().trim() == '') {
        $("#ddlProduct").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlProduct").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select product</span>');
        $("#ddlProduct").focus();
        return false;
    }
    else {
        $("#ddlProduct").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlProduct").closest('.j-input').addClass('j-success-view');
    }

    if ($("#ddlProductType").val() == null || $("#ddlProductType").val().trim() == '') {
        $("#ddlProductType").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlProductType").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select product type</span>');
        $("#ddlProductType").focus();
        return false;
    }
    else {
        $("#ddlProductType").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlProductType").closest('.j-input').addClass('j-success-view');
    }

    if ($("#Quantity").val() == null || $("#Quantity").val().trim() == '') {
        $("#Quantity").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#Quantity").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter quantity</span>');
        $("#Quantity").focus();
        return false;
    }
   else if ($("#ddlTransportType").val()==2 && parseFloat($("#hdnAvailableStock").val()) < parseFloat($("#Quantity").val())) {
        $("#Quantity").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#Quantity").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter quantity less or equal to available stock</span>');
        $("#Quantity").focus();
        return false;
    }
    else {
        $("#Quantity").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#Quantity").closest('.j-input').addClass('j-success-view');
    } 

    if ($("#ddlPaymentType").val() == null || $("#ddlPaymentType").val().trim() == '') {
        $("#ddlPaymentType").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlPaymentType").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select payment type</span>');
        $("#ddlPaymentType").focus();
        return false;
    }
    else {
        $("#ddlPaymentType").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlPaymentType").closest('.j-input').addClass('j-success-view');
    }

    if ($("#TotalAmount").val() == null || $("#TotalAmount").val().trim() == '') {
        $("#TotalAmount").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#TotalAmount").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter total amount</span>');
        $("#TotalAmount").focus();
        return false;
    }
    else {
        $("#TotalAmount").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#TotalAmount").closest('.j-input').addClass('j-success-view');
    }

    if ($("#PaidAmount").val() == null || $("#PaidAmount").val().trim() == '') {
        $("#PaidAmount").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#PaidAmount").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter paid amount</span>');
        $("#PaidAmount").focus();
        return false;
    }
    else if (($("#ddlPaymentType").val() == "1" && parseFloat($("#PaidAmount").val()) >0) || $("#ddlPaymentType").val() == "2" && parseFloat($("#PaidAmount").val()) == parseFloat($("#TotalAmount").val())) {
        $("#PaidAmount").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#PaidAmount").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please change payment type</span>');
        $("#PaidAmount").focus();
        return false;
    }
    else if ($("#ddlPaymentType").val()=="3" && parseFloat($("#PaidAmount").val()) != parseFloat($("#TotalAmount").val())) {
        $("#PaidAmount").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#PaidAmount").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please paid total amount</span>');
        $("#PaidAmount").focus();
        return false;
    }
    else {
        $("#PaidAmount").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#PaidAmount").closest('.j-input').addClass('j-success-view');
    }
    if (!$("#chkOtherDriver").prop('checked') && ($("#ddlDriver").val() == null || $("#ddlDriver").val().trim() == '')) {
        $("#ddlDriver").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlDriver").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select driver</span>');
        $("#ddlDriver").focus();
        return false;
    }
    else {
        $("#ddlDriver").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlDriver").closest('.j-input').addClass('j-success-view');
    }
    if (!$("#chkOtherTruck").prop('checked') && ($("#ddlTruck").val() == null || $("#ddlTruck").val().trim() == '')) {
        $("#ddlTruck").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#ddlTruck").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select truck</span>');
        $("#ddlTruck").focus();
        return false;
    }
    else {
        $("#ddlTruck").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#ddlTruck").closest('.j-input').addClass('j-success-view');
    }
   
    

    return true;
}
function createOrder() {
    var TOrderDetails = new Array();
    TOrderDetails.push({ ProductId: $("#ddlProduct").val(), ProductTypeId: $("#ddlProductType").val(), Quantity: $("#Quantity").val() });
    var token = $('input[name="__RequestVerificationToken"]').val();
    if ($("#chkOtherDriver").prop('checked'))
        $("#ddlDriver").val('');

    if ($("#chkOtherTruck").prop('checked'))
        $("#ddlTruck").val('');

    var formData = {
        UserTypeId: $("#ddlUserType").val(),
        TransportTypeId: $("#ddlTransportType").val(),
        UserId: $("#ddlDealer").val(),
        CustomerName: $("#CustomerName").val(),
        CustomerMobile: $("#CustomerMobile").val(),
        CustomerAddress: $("#CustomerAddress").val(),
        OrderDate: $("#OrderDate").val(),
        PaymentTypeId: parseInt($("#ddlPaymentType").val()),
        StatusTypeId: $("#ddlStatus").val(),
        DriverId: $("#ddlDriver").val(),
        TruckId: $("#ddlTruck").val(),
        DriverName: $("#DriverName").val(),
        DriverMobile: $("#DriverMobile").val(),
        TruckNumber: $("#TruckNumber").val(),
        TotalAmount: $("#TotalAmount").val(),
        PaidAmount: $("#PaidAmount").val(),
        Comments: $("#Comments").val(),
        TOrderDetails: TOrderDetails
    }
    $.ajax({
        type: "POST",
        url: "/Inventories/Order/Create",
        data: { __RequestVerificationToken: token, order: formData },
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response.statusCode > 0) {
                SuccessAlert(response.statusMessage);
                ResetForm();
            }               
            else 
                ErrorAlert(response.statusMessage);
        },
        complete: function () {

        },
        error: function (error) {
            console.log(error);
            ErrorAlert(response.statusMessage);
        }
    })
}
function ResetForm() {
    $("input,textarea,select").val('');
    $("input[type=checkbox]").prop('checked',false);
    $("input,select,textarea").closest('.j-input').removeClass('j-success-view').find('span').remove();
    showOrHideCustomerDetails(); 
    showOrHideDriverDetails();
    showOrHideTruckDetails();
}
function showOrHideCustomerDetails() {
    if ($("#ddlUserType").val() == "2") {
        $("#ddlDealer").val('');
        $("#ddlDealer,#ddlTransportType").closest('.j-unit').hide();
        $("#ddlTransportType").val('2');
        $("#CustomerMobile,#CustomerName,#CustomerAddress").closest('.j-unit').show();
    }
    else if ($("#ddlUserType").val() == "3") {
        $("#CustomerMobile,#CustomerName,#CustomerAddress").val('');
        $("#CustomerMobile,#CustomerName,#CustomerAddress").closest('.j-unit').hide();
        $("#ddlDealer,#ddlTransportType").closest('.j-unit').show();
        $("#ddlTransportType").val('');
        loadDealers();
    }
    else {
        $("#ddlDealer,#CustomerMobile,#CustomerName,#CustomerAddress").closest('.j-unit').hide();
    }
}
function showOrHideDriverDetails() {
    if ($("#chkOtherDriver").prop('checked') == true) {
        $("#ddlDriver").val("");
        $("#ddlDriver").attr("disabled", true);
        $("#DriverName,#DriverMobile").closest('.j-unit').show();
        $("#DriverMobile,#DriverName").removeAttr("disabled");
    }
    else {
        $("#DriverName,#DriverMobile").val("");
        $("#DriverName,#DriverMobile").closest('.j-unit').hide();
        $("#ddlDriver,#txtDriverName").removeAttr("disabled");
    }
}
function showOrHideTruckDetails() {
    if ($("#chkOtherTruck").prop('checked') == true) {
        $("#ddlTruck").val("");
        $("#ddlTruck").attr("disabled", true);
        $("#TruckNumber").closest('.j-unit').show();
        $("#TruckNumber").removeAttr("disabled");
    }
    else {
        $("#TruckNumber").val("");
        $("#TruckNumber").closest('.j-unit').hide();
        $("#ddlTruck").removeAttr("disabled");
    }
}