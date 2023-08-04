$(document).ready(function () {

    // Phone masking
    $('#phone').mask('(999) 999-9999', { placeholder: 'x' });

    /***************************************/
    /* Datepicker */
    /***************************************/
    // Start date
    function dateFrom(date_from, date_to) {
        $(date_from).datepicker({
            dateFormat: 'mm/dd/yy',
            prevText: '<i class="fa fa-caret-left"></i>',
            nextText: '<i class="fa fa-caret-right"></i>',
            onClose: function (selectedDate) {
                $(date_to).datepicker('option', 'minDate', selectedDate);
            }
        });
    }

    // Finish date
    function dateTo(date_from, date_to) {
        $(date_to).datepicker({
            dateFormat: 'mm/dd/yy',
            prevText: '<i class="fa fa-caret-left"></i>',
            nextText: '<i class="fa fa-caret-right"></i>',
            onClose: function (selectedDate) {
                $(date_from).datepicker('option', 'maxDate', selectedDate);
            }
        });
    }

    // Destroy date
    function destroyDate(date) {
        $(date).datepicker('destroy');
    }

    // Initialize date range
    dateFrom('#date_from', '#date_to');
    dateTo('#date_from', '#date_to');
    /***************************************/
    /* end datepicker */
    /***************************************/

    // Validation
    $("#frmUserInfo").justFormsPro({
        rules: {
            FullName: {
                required: true
            },
            //EmailId: {
            //    required: true,
            //    email: true
            //},
            MobileNumber: {
                required: true
            },
            UserType: {
                required: true
            },
            Password: {
                required: true
            },
            ConfirmPassword: {
                required: true
            },
            adults: {
                required: true,
                integer: true,
                minvalue: 0
            },
            children: {
                required: true,
                integer: true,
                minvalue: 0
            },
            date_from: {
                required: true
            },
            date_to: {
                required: true
            },
            message: {
                required: true
            }
        },
        messages: {
            FullName: {
                required: "Please enter full name"
            },
            //EmailId: {
            //    required: "Please enter email id",
            //    email: "Incorrect email format"
            //},
            MobileNumber: {
                required: "Please enter mobile number"
            },
            UserType: {
                required: "Please select user type"
            },
            Password: {
                required: "Please select user type"
            },
            ConfirmPassword: {
                required: "Please select user type"
            },
            adults: {
                required: "Field is required",
                integer: "Only integer allowed",
                minvalue: "Value not less than 0"
            },
            children: {
                required: "Field is required",
                integer: "Only integer allowed",
                minvalue: "Value not less than 0"
            },
            date_from: {
                required: "Select check-in date"
            },
            date_to: {
                required: "Select check-out date"
            },
            message: {
                required: "Enter your message"
            }
        },
        formType: {
            multistep: true
        },
        afterSubmitHandler: function () {
            // Destroy date range
            destroyDate("#date_from");
            destroyDate("#date_to");

            // Initialize date range
            dateFrom("#date_from", "#date_to");
            dateTo("#date_from", "#date_to");

            return true;
        }
    });
});