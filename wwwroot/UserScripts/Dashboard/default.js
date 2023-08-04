"use strict";
$(document).ready(function () {
    $.ajax({
        url: "/Dashboard/Default/GetDashboard",
        type: "GET",
        dataType: "json",
        beforeSend: function () {

        },
        success: function (response) {
            if (response != null && response != "") {
                var _response = $.parseJSON(response);
                var orderCountArray = new Array();
                if (_response.Table.length > 0) {
                    $("#export-profit").text(_response.Table[0].ExportProfit);
                    $("#transport-profit").text(_response.Table[0].TransportProfit);
                    $("#truck-service-profit").text(_response.Table[0].TruckServiceProfit);
                    $("#overall-loss").text(_response.Table[0].OverallLoss);
                    orderCountArray.push(_response.Table[0].ExportOrderCount);
                    orderCountArray.push(_response.Table[0].TransportOrderCount);
                    orderCountArray.push(_response.Table[0].TruckServiceOrderCount);
                }
                else
                    orderCountArray = [0, 0, 0];
              
               
               

                var productProfitArray = new Array();
                if (_response.Table1 !== undefined && _response.Table1.length > 0) {
                    productProfitArray.push(_response.Table1[0].ProductProfit);
                    productProfitArray.push(_response.Table1[1].ProductProfit);
                    productProfitArray.push(_response.Table1[2].ProductProfit);
                    productProfitArray.push(_response.Table1[3].ProductProfit);
                    productProfitArray.push(_response.Table1[4].ProductProfit);
                }
                else
                    productProfitArray = [0, 0, 0, 0, 0];
               
               

                var truckRentArray = new Array();

                if (_response.Table2 !== undefined && _response.Table2.length > 0) {
                    truckRentArray.push(_response.Table2[0].ExternalTruck);
                    truckRentArray.push(_response.Table2[0].InternalTruck);
                }
                else
                    truckRentArray = [0, 0];
                

                getChartData(orderCountArray, productProfitArray, truckRentArray);
            }
           
        },
        error: function (error) {
           
            console.log(error);
        },
        complete: function () {

        }
    })
    
});


function getChartData(orderCountArray, productProfitArray, truckRentArray) {
    /*Doughnut chart*/
    var ctx1 = document.getElementById("productProfit");
    var data1 = {
        labels: [
            "Cements", "Bricks", "Sand", "Metal (Gitti)", "Husks"
        ],
        datasets: [{
            data: productProfitArray,
            backgroundColor: [
                "#F1C40F",
                "#2ECC71",
                "#3498DB",
                "#E74C3C",
                "#1ABC9C"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#F1C40F",
                "#2ECC71",
                "#3498DB",
                "#E74C3C",
                "#1ABC9C"

            ]
        }]
    };

    var myDoughnutChart1 = new Chart(ctx1, {
        type: 'doughnut',
        data: data1
    });

    

    /*Doughnut chart*/
    var ctx3 = document.getElementById("orderCount");
    var data3 = {
        labels: [
            "Export", "Transport", "Truck Service"
        ],
        datasets: [{
            data: orderCountArray,
            backgroundColor: [
                "#2ecc71",
                "#17a689",
                "#8cddcd"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#2ecc71",
                "#17a689",
                "#8cddcd"

            ]
        }]
    };

    var myDoughnutChart3 = new Chart(ctx3, {
        type: 'doughnut',
        data: data3
    });

    /*Doughnut chart*/
    var ctx2 = document.getElementById("truckData");
    var data2 = {
        labels: [
            "External", "Internal"
        ],
        datasets: [{
            data: truckRentArray,
            backgroundColor: [
                "#FCC9BA",
                "#1ABC9C"
            ],
            borderWidth: [
                "0px",
                "0px",
            ],
            borderColor: [
                "#FCC9BA",
                "#1ABC9C"
            ]
        }]
    };

    var myDoughnutChart2 = new Chart(ctx2, {
        type: 'doughnut',
        data: data2
    });
}
