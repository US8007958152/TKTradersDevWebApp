$(document).ready(function () {
    if ($("#hdnTruckFuelId").length <= 0) {
        loadTruckDropdown();
        loadPetrolPumpDropdown();
    }
  
    $("#btnSave").click(function () {
        
        if (validateForm()) {
            addFuel();
        }
    })
    //$("#Quantity,#Rate").keyup(function () {
    //    var quantity = $("#Quantity").val();
    //    var rate = $("#Rate").val();
    //    $("#TotalAmount").val((quantity * rate).toFixed(2))
    //});
});

function loadTruckDropdown() {
    var ddlTruck = '<option value="" selected>-- Select --</option>';
   
    $.ajax({
        url: "/Securities/Common/GetTrucksDropdown?truckType=1",
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
function loadPetrolPumpDropdown() {
    var ddlPetrolPump = '<option value="" selected>-- Select --</option>';

    $.ajax({
        url: "/Securities/Common/GetUser?userTypeId=7",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {

            if (response != null && response.length > 0) {
                $.each(response, function (index, value) {
                    ddlPetrolPump += '<option value="' + value.value + '">' + value.text + '</option>';
                });
            }
            $("#ddlPetrolPump").html(ddlPetrolPump);
        },
        error: function (error) {
            $("#ddlPetrolPump").html(ddlPetrolPump);
            console.log(error);
        },
        complete: function () {

        }
    })
}
function addFuel() {
    $("#btnSave").attr('disabled', true);   
    var token = $('input[name="__RequestVerificationToken"]').val();
    var apiUrl = '';
    var truckFuelId = 0;
    if ($("#hdnTruckFuelId").length > 0) {
        truckFuelId = $("#hdnTruckFuelId").val();
        apiUrl = "/Configuration/Truck/EditFuel";
    }
    else
        apiUrl = "/Configuration/Truck/AddFuel";
    var formData = {
        Id: truckFuelId,
        FuelTypeId: $("#ddlFuelType").val(),
        PetrolPumpUserId: $("#ddlPetrolPump").val(),
        TruckId: $("#ddlTruck").val(),
        Quantity: $("#Quantity").val(),
        Rate: $("#Rate").val(),
        CurrentReading: $("#CurrentReading").val(),
        Amount: $("#TotalAmount").val(),
        Comments: $("#Comments").val()
    }
    $.ajax({
        type: "POST",
        url: apiUrl,
        data: { __RequestVerificationToken: token, truckFuel: formData },
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response.statusCode > 0) {
                toastr.success(response.statusMessage);
                if ($("#hdnTruckFuelId").length <=0)
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
function validateForm() {
    var returnValue = true;
    $('form#frmTruckFuelInfo').find('select,input').each(function () {
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