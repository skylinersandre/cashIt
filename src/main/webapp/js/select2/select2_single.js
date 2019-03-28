$(document).ready(function () {
    $('.js-example-basic-single').select2();

    $(".js-basic-single-payer").select2({
        placeholder: "Payer",
        allowClear: true
    });
    $(".js-basic-single-receiver").select2({
        placeholder: "Receiver",
        allowClear: true
    });
});


