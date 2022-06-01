$(function() {
    window.addEventListener("message", function(event) {
        e = event.data
        console.log(JSON.stringify(e))
        if(e.show) {
            $(".balance-body-text2").html(e.balance)
            $(".person-name").html(e.firstname + ' ' + e.lastname)
            console.log(e.transactions.length)
            if (e.transactions) {
                $('.transactions-body-outlines').html(``)
                for (let i = 0; i < e.transactions.length; i++) {
                    $('.transactions-body-outlines').append(`<span>${e.transactions[i].message}</span>`)
                }
            }
            $(".container").fadeIn(500)
        } else {
            $(".container").fadeOut(500)
        }
    });
});

$(".withdraw-button1").click(function() {
    $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
        amount: $("#withdraw-amount").val()
    }));
});

$(".deposit-button1").click(function() {
    console.log($("#deposit-amount").val())
    $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({
        amount: $("#deposit-amount").val()
    }));
});

$(".transfer-button1").click(function() {
    $.post(`https://${GetParentResourceName()}/transfer`, JSON.stringify({
        target: $("#transfer-player-id").val(),
        amount: $("#transfer-amount").val()
    }));
});

$(document).keyup(function(e) {
    if (e.keyCode === 27) {
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }
});

