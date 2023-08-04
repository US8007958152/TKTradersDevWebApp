$(document).ready(function () {
    hideOrShow();
   

    $('#MobileNumber').on('paste keypress', function (e) {

        var charCode = (e.which) ? e.which : event.keyCode

        if (String.fromCharCode(charCode).match(/[^0-9]/g))

            return false;
    });

    $("#UserType").change(function () {         
        hideOrShow();
    });
    $("#frmUserInfo select").change(function () {
        validateForm($(this),true);
    })
    $("#frmUserInfo input").keyup(function () {
        validateForm($(this), true);
    })
    $("#btnSave").click(function (e) {
        
        if (validateForm(null, false))
            saveUser();
    })
    $("div.dvUserSite").on('click', '.j-row:last .ion-ios-plus', function () {
        var isValid = false;
        var siteNumber = $(".dvUserSite").find('.j-row').length;
        //var siteNewRow = $(this).closest('.j-row');
        $("div.dvUserSite .j-row").each(function (index, value) {
            var siteAddress = $(this).find('input[type=text]').val();
            if (siteAddress === undefined || siteAddress == '' || siteAddress == null) {
                toastr.error("Please enter site" + (index + 1) + " address");
                $(this).find('input').focus();
                isValid = true;
                return false;
            }
            //var siteAddress = siteNewRow.find('input').val();
            //if ($(this) !== siteNewRow && siteAddress.toUpperCase() == siteAddress.toUpperCase()) {
            //    toastr.error("Please enter unique site name");
            //    $(this).find('input').focus();
            //    isValid = true;
            //    return false;
            //}
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
    })
    $("div.dvUserSite").on('click', '.ion-ios-minus', function () {
        if (confirm("Do you want to delete this site?")) {
            var siteId = $(this).closest('.j-row').find('input[type=hidden]').length > 0 ? $(this).closest('.j-row').find('input[type=hidden]').val() : 0;
            if (siteId > 0) {
                $.ajax({
                    url: "/Security/User/DeleteSite?siteId=" + siteId,
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
            else
            $(this).closest('.j-row').remove();
            //$("div.dvUserSite .j-row:last .ion-ios-minus").addClass('d-none');
            //$("div.dvUserSite .j-row:last .ion-ios-plus").removeClass('d-none');
        }
        $("div.dvUserSite .j-row").each(function (index, value) {
            $(this).find('input').attr("placeholder", "Site" + (index + 1) + " Address");
        })
    });
    $("#ddlDistrict").change(function () {
        if ($(this).val() !='')
            getCity($(this).val());
        else
            $("#ddlCity").html('<option value="" selected>Select City</option>');
    });
   
});
function getCity(districtId) {
    var ddlCity = '<option value="" selected>Select City</option>';
    $.ajax({
        url: "/Securities/Common/GetCity?districtId=" + districtId,
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlCity += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlCity").html(ddlCity);
        },
        error: function (error) {
            $("#ddlCity").html(ddlCity);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function hideOrShow() {
    if ($("#UserType").val() == "1") {
        $(".dvPassord").show();
        $(".dvUserDetails").hide();
    }
    else if ($("#UserType").val() == "") {
        $(".dvPassord").hide();
        $(".dvUserDetails").hide();
    }
    else {
        $(".dvPassord").hide();
        $(".dvUserDetails").show();
        $(".dvPassord input[type=password]").val("");
        if ($("#UserType").val() == "3")
            $(".dvCompany").show();
        else
            $(".dvCompany").hide();
        
    }
    if ($("#UserType").val() == "3" || $("#UserType").val() == "5")
        $(".dvUserSite").show();
    else
        $(".dvUserSite").hide();
}
function validateForm(obj,isChange) {
   
    if ($("#FullName").val() == null || $("#FullName").val().trim() == '') {
        $("#FullName").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#FullName").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter full name</span>');
        return false;
    }
    else {
        $("#FullName").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#FullName").closest('.j-input').addClass('j-success-view');  
        if (isChange && obj.attr("id") == "FullName")
            return;
    }
    if ($("#MobileNumber").val() == null || $("#MobileNumber").val().trim() == '') {
        $("#MobileNumber").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#MobileNumber").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter mobile number</span>');
        return false;
    }
    else {
        $("#MobileNumber").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#MobileNumber").closest('.j-input').addClass('j-success-view');
        if (isChange && obj.attr("id") == "MobileNumber")
            return;
    }
    if ($("#EmailId").val() != null && $("#EmailId").val().trim() != '' && !validateEmail($("#EmailId").val())) {
        $("#EmailId").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#EmailId").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter valid emaild id</span>');
        return false;
    }
    else {
        $("#EmailId").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#EmailId").closest('.j-input').addClass('j-success-view');
        if (isChange && obj.attr("id") == "EmailId")
            return;
    }
    
    if ($("#UserType").val() == null || $("#UserType").val().trim() == '') {
        $("#UserType").closest('.j-input').removeClass('j-success-view').find('span').remove();
        $("#UserType").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter user type</span>');
        return false;
    }
    else {
        $("#UserType").closest('.j-input').removeClass('j-error-view').find('span').remove();
        $("#UserType").closest('.j-input').addClass('j-success-view');
        if (isChange && obj.attr("id") == "UserType")
            return;
    }
    if ($("#UserType").val() == "1") {

        if ($("#Password").val() == null || $("#Password").val().trim() == '') {
            $("#Password").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#Password").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter password</span>');
            return false;
        }
        else {
            $("#Password").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#Password").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "EmailId")
                return;
        }
        if ($("#ConfirmPassword").val() == null || $("#ConfirmPassword").val().trim() == '') {
            $("#ConfirmPassword").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#ConfirmPassword").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter confirm password</span>');
            return false;
        }
        else {
            $("#ConfirmPassword").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#ConfirmPassword").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "ConfirmPassword")
                return;
        }
        if ($("#ConfirmPassword").val() != $("#Password").val()) {
            $("#ConfirmPassword").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#ConfirmPassword").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Confirm password is not matched</span>');
            return false;
        }
        else {
            $("#ConfirmPassword").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#ConfirmPassword").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "ConfirmPassword")
                return;
        }
    }

    if ($("#UserType").val() != "" && parseInt($("#UserType").val())>1) {

       
        if ($("#UserType").val() == "3") {
            if ($("#Company").val() == null || $("#Company").val().trim() == '') {
                $("#Company").closest('.j-input').removeClass('j-success-view').find('span').remove();
                $("#Company").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter company</span>');
                return false;
            }
            else {
                $("#Company").closest('.j-input').removeClass('j-error-view').find('span').remove();
                $("#Company").closest('.j-input').addClass('j-success-view');
                if (isChange && obj.attr("id") == "Company")
                    return;
            }
        }
        if ($("#UserType").val() == "3" || $("#UserType").val() == "5") {
            var isValid = false;
            $("div.dvUserSite .j-row").each(function (index, value) {
                var siteAddress = $(this).find('input[type=text]').val();
                if (siteAddress === undefined || siteAddress == '' || siteAddress == null) {
                    toastr.error("Please enter site" + (index + 1) + " address");
                    $(this).find('input').focus();
                    isValid = true;
                    return false;
                }
            })
            if (isValid)
                return false;
        }
        if ($("#Address").val() == null || $("#Address").val().trim() == '') {
            $("#Address").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#Address").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please enter address</span>');
            return false;
        }
        else {
            $("#Address").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#Address").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "Address")
                return;
        }
        if ($("#State").val() == null || $("#State").val().trim() == '') {
            $("#State").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#State").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select state</span>');
            return false;
        }
        else {
            $("#State").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#State").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "State")
                return;
        }
        if ($("#ddlDistrict").val() == null || $("#ddlDistrict").val().trim() == '') {
            $("#ddlDistrict").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#ddlDistrict").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select district</span>');
            return false;
        }
        else {
            $("#ddlDistrict").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#ddlDistrict").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "District")
                return;
        }
        if ($("#ddlCity").val() == null || $("#ddlCity").val().trim() == '') {
            $("#ddlCity").closest('.j-input').removeClass('j-success-view').find('span').remove();
            $("#ddlCity").closest('.j-input').addClass('j-error-view').append('<span class="j-error-view">Please select city</span>');
            return false;
        }
        else {
            $("#ddlCity").closest('.j-input').removeClass('j-error-view').find('span').remove();
            $("#ddlCity").closest('.j-input').addClass('j-success-view');
            if (isChange && obj.attr("id") == "City")
                return;
        }
    }

    return true;
}

function validateEmail(inputText) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(inputText);
}
function saveUser() {
    var _url = '';
    var _userId = 0;
    var token = $('input[name="__RequestVerificationToken"]').val();
    if ($("#hdnUserId").length > 0) {
        _url = "/Securities/User/Edit";
        _userId = $("#hdnUserId").val();
    }
    else {
        _url = "/Securities/User/Create";
        _userId = 0;
    }

    var TUserSites = new Array();
    $("div.dvUserSite .j-row").each(function (index, value) {
        var siteId = $(this).find('input[type=hidden]').length>0? $(this).find('input[type=hidden]').val():0;
        var siteAddress = $(this).find('input[type=text]').val();
        TUserSites.push({ SiteId: siteId, UserId: _userId, SiteAddress: siteAddress });
    })
   
    var userMaster = {
        UserId: _userId, UserTypeId: $("#UserType").val(), Name: $("#FullName").val(), MobileNumber: $("#MobileNumber").val(), EmailId: $("#EmailId").val(),
        Address: $("#Address").val(), Company: $("#Company").val(), CityId: $("#ddlCity").val(), DistrictId: $("#ddlDistrict").val(), StateId: $("#State").val(), Password: $("#Password").val(),
        TUserSites: TUserSites
    };
    $.ajax({
        url: _url,
        type: "POST",
        dataType: "json",
        data: { __RequestVerificationToken: token, userMaster: userMaster },
        success: function (response) {
            if (response.statusCode == 1) {
                    window.location.reload();
            }
            else {
                toastr.error(response.statusMessage);
            }
        },
        error: function (error) {
            //$("#ddlProductType").html(ddlProductType);
            console.log(error);
        },
        complete: function () {

        }
    })
}