$(document).ready(function () {
    showOrHideUserDetails('hide');
    $("#btnPaymentSave").click(function () {
        if (validateForm())
        addTransaction();
    });
    $("#ddlUser").change(function () {
        if($(this).val() == "-999")
            showOrHideUserDetails('show');
        else
           showOrHideUserDetails('hide');
    });
});
function showOrHideUserDetails(type) {
    if (type.toUpperCase() == 'HIDE') {
        $("#ddlUserType,#UserMobile,#UserName,#UserAddress").val('');
        $("#ddlUserType,#UserMobile,#UserName,#UserAddress").removeAttr('required');
        $("#ddlUserType,#UserMobile,#UserName,#UserAddress").closest('.j-unit').hide();
    }
    else {

        $("#ddlUserType,#UserMobile,#UserName,#UserAddress").attr('required', true);
        $("#ddlUserType,#UserMobile,#UserName,#UserAddress").closest('.j-unit').show();
    }
}
function addTransaction() {
    var _url = '';
    var _transactionId = 0;
    if ($("#hdnTransactionId").length > 0) {
        _url = "/Securities/Payment/EditPayment";
        _transactionId = $("#hdnTransactionId").val();
    }

    else {
        _url = "/Securities/Payment/AddPayment";
        _transactionId = 0;
    }
       

    var userTransaction = { TransactionId: _transactionId, UserId: $("#ddlUser").val(), TransactionTypeId: $("#ddlTransactionType").val(), Amount: $("#Amount").val(), Comments: $("#Comments").val(), UserType: $("#ddlUserType").val(), UserMobile: $("#UserMobile").val(), UserName: $("#UserName").val(), UserAddress: $("#UserAddress").val() };
    $.ajax({
        url: _url,
        type: "POST",
        dataType: "json",
        data: { userTransaction: userTransaction },
        success: function (response) {
            if (response.statusCode == 1) {
                if ($("#hdnTransactionId").length > 0) {
                    toastr.success(response.statusMessage);
                }
                else {
                    toastr.success(response.statusMessage);
                    showOrHideUserDetails('hide');
                    $("#btnPaymentReset").click();
                }
             
            }
            else {
                toastr.error(response.statusMessage);
            }
        },
        error: function (error) {
            $("#ddlProductType").html(ddlProductType);
            console.log(error);
        },
        complete: function () {

        }
    })
}

function validateForm() {
    var returnValue = true;
    $('form#frmPaymentInfo').find('select,input').each(function () {
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
    return returnValue;
}

