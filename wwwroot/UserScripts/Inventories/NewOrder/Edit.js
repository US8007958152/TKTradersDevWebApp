﻿$(document).ready(function () {
   
    showOrHideTruckDetails('HIDE');
    showOrHideDriverDetails('HIDE');
    hideOrShowTruckPayment('HIDE');
    hideOrShowProductPayment();
    loadStocks();

    $("#btnSave").click(function () {
        //if (validateForm()) {
        createOrder();
        //}
    });

    $("#Quantity").keyup(function () {
        if ($("#ddlTransportType").val() == "2" && parseFloat($("#hdnAvailableStock").val()) < parseFloat($(this).val())) {
            var quantity = $(this).val();
            quantity = quantity.slice(0, -1);
            $("#Quantity").val(quantity);
            toastr.error('Available ' + $("#ddlProductType option:selected").text() + ' ' + $("#ddlProduct option:selected").text() + ' stock: ' + $("#hdnAvailableStock").val());
            return false;
        }
    });
  
})
function ddlTruckChange() {
    if ($("#ddlTruck").val() == '-999') {
        showOrHideTruckDetails('show');
        hideOrShowTruckPayment('show');
    }
    else {
        showOrHideTruckDetails('hide');

        var groupLabel = $("#ddlTruck option:selected").parent().attr('label');

        if ($("#ddlTransportType").val() == "4" && groupLabel == 'Internal Truck')
            hideOrShowTruckPayment('show');
        else if (groupLabel == 'Internal Truck')
            hideOrShowTruckPayment('hide');
        else if (groupLabel == 'External Truck')
            hideOrShowTruckPayment('show');
        else
            hideOrShowTruckPayment('hide');
    }



    //else
    //    hideOrShowTruckPayment('show');
}
function hideOrShowTruckPayment(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#TruckRent,#PaidRent").val('');
        $("#TruckRent,#TruckOwnerMobile").removeAttr('required');
        $("#TruckRent,#PaidRent").closest('.j-unit').hide();
    }
    else {
        $("#TruckRent").attr('required', true);
        $("#TruckRent,#PaidRent").closest('.j-unit').show();
    }
}

function hideOrShowSupplierSite(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#ddlSupplierSite").val('');
        $("#ddlSupplierSite").removeAttr('required');
        $("#ddlSupplierSite").closest('.j-unit').hide();
    }
    else {
        $("#ddlSupplierSite").attr('required', true);
        $("#ddlSupplierSite").closest('.j-unit').show();
    }
}
function hideOrShowCustomerSite(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#ddlCustomerSite").val('');
        $("#ddlCustomerSite").removeAttr('required');
        $("#ddlCustomerSite").closest('.j-unit').hide();
    }
    else {
        $("#ddlCustomerSite").attr('required', true);
        $("#ddlCustomerSite").closest('.j-unit').show();
    }
}


function hideOrShowInternalUseDetails() {
    if ($("#ddlTransportType").val() == '5') {
        $("#ddlTruck,#TruckRent,#ddlDriver").val('');
        $("#ddlTruck,#TruckRent").removeAttr('required');
        $("#ddlTruck,#TruckRent,#ddlDriver").closest('.j-unit').hide();
        showOrHideTruckDetails('hide');
        showOrHideDriverDetails('hide');
    }
    else {
        $("#ddlTruck,#TruckRent,#ddlDriver").attr('required', true);
        $("#ddlTruck,#TruckRent,#ddlDriver").closest('.j-unit').show();
    }
}
function hideOrShowProductPayment() {
    if ($("#ddlTransportType").val() == "4" || $("#ddlTransportType").val() == "5") {
        //$("#BuyAmount,#SellAmount,#SellPaidAmount").val('');
        $("#BuyAmount,#SellAmount").removeAttr('required');
        $("#BuyAmount,#SellAmount").closest('.j-unit').hide();
    }
    else if ($("#ddlTransportType").val() == "1") {
        $("#BuyAmount,#SellAmount").attr('required', true);
        $("#BuyAmount,#SellAmount").closest('.j-unit').show();
       // $("#SellAmount,#SellPaidAmount").val('');
        $("#SellAmount").removeAttr('required');
        $("#SellAmount").closest('.j-unit').hide();
    }
    else if ($("#ddlTransportType").val() == "2") {
        $("#BuyAmount,#SellAmount").attr('required', true);
        $("#BuyAmount,#SellAmount").closest('.j-unit').show();
        //$("#SellAmount,#SellPaidAmount").val('');
        $("#BuyAmount").removeAttr('required');
        $("#BuyAmount").closest('.j-unit').hide();
    }
    else {

        $("#BuyAmount,#SellAmount,#SellPaidAmount").attr('required', true);
        $("#BuyAmount,#SellAmount,#SellPaidAmount").closest('.j-unit').show();
    }
}

function hideOrShowSupplier() {
    if ($("#ddlTransportType").val() == '2' || $("#ddlTransportType").val() == '5') {
        $("#ddlSupplier").val('');
        $("#ddlSupplier").removeAttr('required');
        $("#ddlSupplier").closest('.j-unit').hide();
        showOrHideSupplierDetails('hide');
        $("#BuyAmount").closest('.j-span4').find('.j-label').text('Invest Amount');
    }
    else {
        $("#BuyAmount").closest('.j-span4').find('.j-label').text('Buy Amount');
        $("#ddlSupplier").attr('required', true);
        $("#ddlSupplier").closest('.j-unit').show();
    }
}
function hideOrShowCustomer() {
    if ($("#ddlTransportType").val() == '1' || $("#ddlTransportType").val() == '5') {
        $("#ddlCustomer").val('');
        $("#ddlCustomer").removeAttr('required');
        $("#ddlCustomer").closest('.j-unit').hide();
        hideOrShowCustomerSite('hide');
        showOrHideCustomerDetails('hide');
    }
    else {
        hideOrShowCustomerSite('show');
        $("#ddlCustomer").attr('required', true);
        $("#ddlCustomer").closest('.j-unit').show();
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
        $("#TruckOwnerMobile,#TruckOwnerName,#TruckNumber").val('');
        $("#TruckOwnerMobile,#TruckOwnerName,#TruckNumber").removeAttr('required');
        $("#TruckOwnerMobile,#TruckOwnerName,#TruckNumber").closest('.j-unit').hide();
    }
    else {
        $("#TruckOwnerMobile,#TruckOwnerName,#TruckNumber").attr('required', true);
        $("#TruckOwnerMobile,#TruckOwnerName,#TruckNumber").closest('.j-unit').show();
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

function loadTruckDropdown(truckType) {
    var ddlTruck = '<option value="" selected>Select Truck</option>';
    if (truckType != 1)
        ddlTruck += '<option value="-999">Other Truck</option>';
    $.ajax({
        url: "/Securities/Common/GetTrucksDropdown?truckType=" + truckType,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            var internalTruck = '<optgroup label="Internal Truck">';
            var externalTruck = '<optgroup label="External Truck">';
            var hasInternalTruck = false;
            var hasExternalTruck = false;
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    if (value.disabled) {
                        hasInternalTruck = true;
                        internalTruck += '<option value="' + value.value + '">' + value.text + '</option>';
                    }
                    else {
                        hasExternalTruck = true;
                        externalTruck += '<option value="' + value.value + '">' + value.text + '</option>';
                    }

                });
            }
            internalTruck += '</optgroup>';

            externalTruck += '</optgroup>';
            if (hasInternalTruck)
                ddlTruck += internalTruck;
            if (truckType != 1 && hasExternalTruck)
                ddlTruck += externalTruck;
            $("#ddlTruck").html(ddlTruck);
        },
        error: function (error) {
            $("#ddlTruck").html(ddlTruck);
            console.log(error);
        },
        complete: function () {
            $(".loader-block").hide();
        }
    })
}

function loadDriverDropdown() {
    var ddlDriver = '<option value="" selected>Select Driver</option><option value="-999">Other Driver</option>';
    $.ajax({
        url: "/Securities/Common/GetDrivers",
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            var internalDriver = '<optgroup label="Internal Truck">';
            var externalDriver = '<optgroup label="External Truck">';
            var hasInternalDriver = false;
            var hasExternalDriver = false;
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    if (value.disabled) {
                        hasInternalDriver = true;
                        internalDriver += '<option value="' + value.value + '">' + value.text + '</option>';
                    }
                    else {
                        hasExternalDriver = true;
                        externalDriver += '<option value="' + value.value + '">' + value.text + '</option>';
                    }

                });
            }
            internalDriver += '</optgroup>';

            externalDriver += '</optgroup>';
            if (hasInternalDriver)
                ddlDriver += internalDriver;
            if (hasExternalDriver)
                ddlDriver += externalDriver;
            $("#ddlDriver").html(ddlDriver);
        },
        error: function (error) {
            $("#ddlProductType").html(ddlProductType);
            console.log(error);
        },
        complete: function () {
            $(".loader-block").hide();
        }
    })
}

function loadProductTypes() {
    var ddlProductType = '<option value="" selected>Select Product Type</option>';
    $.ajax({
        url: "/Securities/Common/GetProductTypesDropdown?productId=" + $("#ddlProduct").val(),
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
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
            $(".loader-block").hide();
        }
    })
}

function createOrder() {
    $("#btnSave").attr('disabled', true);
    var TOrderProductDetail = { ProductId: $("#ddlProduct").val(), ProductTypeId: $("#ddlProductType").val(), Quantity: $("#Quantity").val(), BuyAmount: $("#BuyAmount").val(), SellAmount: $("#SellAmount").val(), SellPaidAmount: $("#SellPaidAmount").val() };
    var TOrderTruckDetail = { TruckRent: $("#TruckRent").val(), PaidRent: $("#PaidRent").val() };
    var token = $('input[name="__RequestVerificationToken"]').val();
    var apiUrl = '';
    var orderId = 0;
    if ($("#hdnOrderId").length > 0) {
        orderId = $("#hdnOrderId").val();
        apiUrl = "/Inventories/NewOrder/Edit";
    }
    //else
    //    apiUrl = "/Inventories/NewOrder/Create";
    var formData = {
        TransportTypeId: $("#ddlTransportType").val(),
        OrderId: orderId,
        OrderDate: $("#OrderDate").val(),
        StatusTypeId: $("#ddlStatusType").val(),
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
        TOrderProductDetail: TOrderProductDetail,
        TOrderTruckDetail: TOrderTruckDetail
    }
    $.ajax({
        type: "POST",
        url: apiUrl,
        data: { __RequestVerificationToken: token, _order: formData },
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            if (response.statusCode > 0) {
                toastr.success(response.statusMessage);
                //$("#btnReset").trigger("click");
            }
            else
                toastr.error(response.statusMessage);
        },
        complete: function () {
            $("#btnSave").removeAttr('disabled');
            $(".loader-block").hide();
        },
        error: function (error) {
            console.log(error);
            toastr.error(response.statusMessage);
        }
    })
}


function getOtherSupplier(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherSuppliers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
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
            $(".loader-block").hide();
        }
    })
}

function getOtherCustomer(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherCustomers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
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
            $(".loader-block").hide();
        }
    })
}
function getOtherTruck(truckNumber, mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherTrucks?truckNumber=" + truckNumber + "&mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            if (response !== undefined && response != null) {
                if (response.mobileNumber != null)
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
            $(".loader-block").hide();
        }
    })
}
function getOtherDriver(mobileNumber) {
    $.ajax({
        url: "/Securities/Common/GetOtherDrivers?mobileNumber=" + mobileNumber,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
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
            $(".loader-block").hide();
        }
    })
}
function loadStocks() {
    if (($("#ddlTransportType").val() == "2" || $("#ddlTransportType").val() == "5") && $("#ddlProduct").val() != "" && $("#ddlProductType").val() != "") {
        $.ajax({
            url: "/Inventories/Stock/GetStock?productId=" + $("#ddlProduct").val() + "&productTypeId=" + $("#ddlProductType").val() + "&transportId=" + $("#hdnOrderId").val(),
            type: "GET",
            dataType: "json",
            beforeSend: function () {
                $(".loader-block").show();
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
                        
                    }
                }
                else {
                    $("#hdnAvailableStock").val(0);
                    
                }
            },
            error: function (error) {
               
                $("#hdnAvailableStock").val(0);
                console.log(error);
            },
            complete: function () {
                $(".loader-block").hide();
            }
        })
    }
    else {

        $("#hdnAvailableStock").val(0);
    }
}