"use strict";
$(document).ready(function(){
    /*Doughnut chart*/
    var ctx1 = document.getElementById("myChart1");
    var data1 = {
        labels: [
            "A", "B", "C", "D "
        ],
        datasets: [{
            data: [40, 10, 40, 10],
            backgroundColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"

            ]
        }]
    };

    var myDoughnutChart1 = new Chart(ctx1, {
        type: 'doughnut',
        data: data1
    });

    /*Doughnut chart*/
    var ctx2 = document.getElementById("myChart2");
    var data2 = {
        labels: [
            "A", "B", "C", "D "
        ],
        datasets: [{
            data: [40, 10, 40, 10],
            backgroundColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"

            ]
        }]
    };

    var myDoughnutChart2 = new Chart(ctx2, {
        type: 'doughnut',
        data: data2
    });

    /*Doughnut chart*/
    var ctx3 = document.getElementById("myChart3");
    var data3 = {
        labels: [
            "A", "B", "C", "D "
        ],
        datasets: [{
            data: [40, 10, 40, 10],
            backgroundColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#1ABC9C",
                "#FCC9BA",
                "#B8EDF0",
                "#B4C1D7"

            ]
        }]
    };

    var myDoughnutChart3 = new Chart(ctx3, {
        type: 'doughnut',
        data: data3
    });
    
});
