$(document).ready(function () {
   
});

function deleteStock(ele,id,productId, productTypeId) {
    var token = $('input[name="__RequestVerificationToken"]').val();
    var formData = { id: id, productId: productId, productTypeId: productTypeId }
    if (confirm("Do you want to delete this?")) {
        $.ajax({
            type: "POST",
            url: "/Inventories/Stock/DeleteStock",
            data: { __RequestVerificationToken: token, stock: formData  },
            dataType: "json",
            beforeSend: function () {

            },
            success: function (response) {
                if (response.statusCode > 0) {
                    toastr.success(response.statusMessage);
                    ele.closest('.col-lg-3').remove();
                }
                else
                    toastr.error(response.statusMessage);
            },
            complete: function () {

            },
            error: function (error) {
                console.log(error);
                toastr.error("Something went wrong, Please contact to administrator");
            }
        })
    }
}

function loadInvestment(stockId) {
    $.ajax({
        type: "GET",
        url: "/Inventories/Stock/GetInvestment?stockId=" + stockId,
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response.statusCode > 0) {
                $("#tblBodyInvestment").html(response.data);
            }
            else
                $("#tblBodyInvestment").html('');
        },
        complete: function () {

        },
        error: function (error) {
            console.log(error);
            toastr.error("Something went wrong, Please contact to administrator");
        }
    });
}