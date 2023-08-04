$(document).ready(function () {
    loadProducts();
    loadInvestProducts();
    if ($("#hdnStockId").val()>0)
        loadProducts();
    $("#btnSave").click(function () {
        if (validateForm()) {
            saveStock();
        }
    });
    $('#Quantity').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $("div.dvUserSite").on('paste keypress', '.quantity', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $("div.dvUserSite").on('paste keypress', '.amount', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))
            return false;

    });
    $("#ddlProduct").change(function () {
        loadProductTypes();
    });
    $("div.dvUserSite").on('click', '.j-row:last .ion-ios-plus', function () {
        var isValid = false;
        var siteNumber = $(".dvUserSite").find('.j-row').length;
        //$("div.dvUserSite .j-row:not(:last)").each(function (index, value) {
        $("div.dvUserSite .j-row").each(function (index, value) {
            var productId = $(this).find('select').val();
            if (productId === undefined || productId == '' || productId == null) {
                toastr.error("Please select product for Investment " + (index + 1));
                $(this).find('select').focus();
                isValid = true;
                return false;
            }
            var quantity = $(this).find('.quantity').val();
            if (getInt(productId) != -888 && (quantity === undefined || quantity == '' || quantity == null)) {
                toastr.error("Please enter quantity for Investment " + (index + 1));
                $(this).find('.quantity').focus();
                isValid = true;
                return false;
            }
            if (getInt(productId) == -888) {
                var amount = $(this).find('.amount').val();
                if (amount === undefined || amount == '' || amount == null) {
                    toastr.error("Please enter amount for Investment " + (index + 1));
                    $(this).find('.amount').focus();
                    isValid = true;
                    return false;
                }
            }
          
        })
        if (isValid)
            return false;
        var html = '<div class="j-row">';
        html += $(this).closest('.j-row').html();
        $(this).addClass('d-none');
        $(this).next().removeClass('d-none');
        html += '</html>';
      
        $(html.replace('Site' + siteNumber + ' Address', 'Site' + (siteNumber + 1) + ' Address')).insertAfter('div.dvUserSite > .j-row:last');
        $(".dvUserSite .j-row:last").find('input[type=hidden]').val('0');
        $(".dvUserSite .j-row:last").find('input[type=text]').val('');
        var lastProduct = $("div.dvUserSite .j-row:last").find('select');
        $("div.dvUserSite .j-row:not(last)").find('select').each(function () {
            var productId = $(this).val();
            lastProduct.find('option').each(function () {
                if ($(this).attr('value') != '' && $(this).attr('value') == productId)
                    $(this).hide();                
            })           
        })
    })
    $("div.dvUserSite").on('click', '.ion-ios-minus', function () {
        //var investmentId = $(this).closest('.j-row').find('input[type="hidden"]').val();
        if (confirm("Do you want to delete this site?")) {
            var investmentId = $(this).closest('.j-row').find('.inverstment-id').length > 0 ? $(this).closest('.j-row').find('.inverstment-id').val() : 0;
            if (investmentId > 0) {
                $.ajax({
                    url: "/Inventories/Stock/DeleteInvestment?stockId=" + $("#hdnStockId").val() + "&investmentId=" + investmentId,
                    type: "GET",
                    dataType: "json",
                    success: function (response) {
                        if (response.statusCode == 1) {
                            $("div.dvUserSite .j-row").each(function (index, value) {
                                var _siteId = $(this).find('input[type=hidden]').val();
                                if (siteId == _siteId) {
                                    $(this).remove();
                                    return false;
                                }
                            })
                            toastr.success(response.statusMessage);
                        }
                        else {
                            toastr.error(response.statusMessage);
                        }
                    },
                    error: function (error) {
                        console.log(error);
                    },
                    complete: function () {

                    }
                })
            }
            else {
                $(this).closest('.j-row').remove();
                toastr.success("Investment deleted successfully");
            }
               
            $("#TotalAmount").val(getTotalInvestmentAmount());
        }        
    });
    $("div.dvUserSite").on('change', '.investment-product', function () {
        if ($(this).val() != -888) {
            $(this).closest('.j-row').find('.amount').attr('disabled', true);
        }
        else
            $(this).closest('.j-row').find('.amount').removeAttr('disabled');
        loadStock($(this).val());
    });
    $("div.dvUserSite").on('keyup', '.amount', function () {        
        $("#TotalAmount").val(getTotalInvestmentAmount());
    });
    $("div.dvUserSite").on('keyup', '.quantity', function (e) {
        var quantity = $("#hdnAvailableStock").val();
        var productTypeId = $(this).closest('.j-row').find('select').val();
        if (getFloat(productTypeId)>0 && getFloat($(this).val()) > getFloat(quantity)) {
            toastr.error("Available stock is: " + quantity);
            $(this).val("");
            return false;
        }
        //else if (getFloat(quantity) > 0) {
        //    toastr.info("Available stock is: " + quantity);
        //}
    });
});
function loadStock(productTypeId) {
    $.ajax({
        url: "/Inventories/Stock/LoadStock?productTypeId=" + productTypeId,
        type: "GET",
        dataType: "json",
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            if (response.statusCode == 1) {
                $("#hdnAvailableStock").val(response.data);
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
function cascadeDropdown(productId) {
    var selectedProductIds = new Array();
    $("div.dvUserSite .j-row").each(function () {
        var productId = $(this).find('select').val();
        if (getInt(productId)>0)
        selectedProductIds.push(productId);      
    })
    //$("div.dvUserSite .j-row").each(function () {
    //    var select = $(this).find('select');
    //    select.find('option').each(function () {
    //        if ($(this).attr('value') != '' && jQuery.inArray(getInt($(this).attr('value')), selectedProductIds) !== -1)
    //            $(this).hide();
    //        else
    //    })
    //})
    // var options = $(this).find('option');
    $(this).find('option').each(function () {
        var option = $(this);
        $("div.dvUserSite .j-row").each(function () {
            var select = $(this).find('select');
            if (option.attr('value') == select.val() && option.attr('value') == productId)
                option.hide();
            else
                option.show();
        });
    })
}
function getTotalInvestmentAmount() {
    var totalInvestmentAmount = 0;
    $("div.dvUserSite .j-row").each(function (index, value) {
        var amount = $(this).find('.amount').val();
        totalInvestmentAmount = totalInvestmentAmount + getFloat(amount);
    })
    return totalInvestmentAmount;
}

function saveStock() {
    var TStockInvestments = new Array();
    $("div.dvUserSite .j-row").each(function (index, value) {
        var investmentId = $(this).find('.inverstment-id').val(); 
        var productId = getInt($(this).find('select').val()); 
        var quantity = getFloat($(this).find('.quantity').val());       
        var amount = getFloat($(this).find('.amount').val());
        if ((productId == -888 && amount > 0 && quantity > 0) || (productId >0 && quantity > 0)) {
            TStockInvestments.push({ "Id": investmentId, "StockId": $("#hdnStockId").val(), "ProductTypeId": productId, "Quantity": quantity, "Amount": amount });
        }
    })
    var data = {
        "Id": $("#hdnStockId").val(),
        "Title": $("#txtName").val(),
        "ProductId": $("#ddlProduct").val(),
        "ProductTypeId": $("#ddlProductType").val(),
        "Quantity": $("#Quantity").val(),
        "TotalAmount": $("#TotalAmount").val(),
        "TStockInvestments": TStockInvestments
    }
    var token = $('input[name="__RequestVerificationToken"]').val();
    $.ajax({
        url: "/Inventories/Stock/AddStock",
        type: "POST",
        dataType: "json",
        data: { __RequestVerificationToken: token, addStock: data },
        beforeSend: function () {
            $(".loader-block").show();
        },
        success: function (response) {
            if (response.statusCode == 1) {
                toastr.success(response.statusMessage);
                clearForm();
            }
            else {
                toastr.error(response.statusMessage);
            }
        },
        error: function (error) {
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
function loadInvestProducts() {
    var ddlInvestmentProduct = '<option value="" selected>Select Product Type</option>';
    ddlInvestmentProduct += '<option value="-888" >Lobour Charge</option>';
    $.ajax({
        url: "/Securities/Common/GetInvestmentProductTypes?productId=-1",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlInvestmentProduct += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlInvestmentProduct").html(ddlInvestmentProduct);
        },
        error: function (error) {
            $("#ddlInvestmentProduct").html(ddlInvestmentProduct);
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
function validateForm() {
    var returnValue = true;
   
    if ($("#txtName").val() == '') {
        toastr.error("Please enter stock name");
        $("#txtName").focus();
        return false;
    }
    if ($("#ddlProduct").val() == '') {
        toastr.error("Please select a product");
        $("#ddlProduct").focus();
        return false;
    }
    if ($("#ddlProductType").val() == '') {
        toastr.error("Please select a product type");
        $("#ddlProductType").focus();
        return false;
    }
    if (getFloat($("#Quantity").val())==0) {
        toastr.error("Please enter a quantity");
        $("#ddlProductType").focus();
        return false;
    }
    var isValid = false;
    
    $("div.dvUserSite .j-row:not(:last)").each(function (index, value) {    
        var productId = $(this).find('select').val();
        if (getInt(productId) == 0) {
            toastr.error("Please select product for Investment " + (index + 1));
            $(this).find('select').focus();
            isValid = true;
            return false;
        }
        var quantity = $(this).find('.quantity').val();
        if (getInt(productId)!=-888 && getFloat(quantity) == 0) {
            toastr.error("Please enter quantity for Investment " + (index + 1));
            $(this).find('.quantity').focus();
            isValid = true;
            return false;
        }
        if (getInt(productId) == -888) {
            var amount = $(this).find('.amount').val();
            if (getFloat(amount) == 0) {
                toastr.error("Please enter amount for Investment " + (index + 1));
                $(this).find('.amount').focus();
                isValid = true;
                return false;
            }
        }
       
    })
    $("div.dvUserSite .j-row:last").each(function (index, value) {
        var productId = $(this).find('select').val();
       
        var quantity = $(this).find('.quantity').val();
       
        var amount = $(this).find('.amount').val();
        if (getInt(productId) > 0 || getFloat(quantity) > 0 || getFloat(amount) > 0) {
            var productId = $(this).find('select').val();
            if (getInt(productId) == 0) {
                toastr.error("Please select product for Investment " + $("div.dvUserSite .j-row").length);
                $(this).find('select').focus();
                isValid = true;
                return false;
            }
            var quantity = $(this).find('.quantity').val();
            if (getFloat(quantity)==0) {
                toastr.error("Please enter quantity for Investment " + $("div.dvUserSite .j-row").length);
                $(this).find('.quantity').focus();
                isValid = true;
                return false;
            }
            var amount = $(this).find('.amount').val();
            if (getInt(productId) == -888 && getFloat(amount)==0) {
                toastr.error("Please enter amount for Investment " + $("div.dvUserSite .j-row").length);
                $(this).find('.amount').focus();
                isValid = true;
                return false;
            }
        }
    })
    if (isValid)
        return false;
    return returnValue;
}
function getInt(value) {
    if (value == "" || value === undefined || value === NaN || value == null)
        return 0;
    return parseInt(value);
}
function getFloat(value) {
    if (value == "" || value === undefined || value === NaN || value == null)
        return 0;
    return parseFloat(value);
}
function clearForm() {    
    $("#hdnStockId").val(0);
    $("#txtName").val('');
   $("#ddlProduct").val('');
   $("#ddlProductType").val('');
   $("#Quantity").val('');
    $("#TotalAmount").val('');
    $("div.dvUserSite .j-row:not(:last)").remove();
    $("div.dvUserSite .j-row").each(function (index, value) {
        $(this).find('select').val('');
        $(this).find('.quantity').val(0);
        $(this).find('.amount').val(0);
    })
}