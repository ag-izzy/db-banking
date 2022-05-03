window.addEventListener("message", function(event) {
    e = event.data
    if(e.show == true) {
        if (e.type == "updateData") {
            $(".balance-body-text2").html(e.balance) //TODO Finish Rest
            $("")
        }
    }
});

$(".withdraw-button1").click(function() {
    $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
        amount: $("#withdraw-amount").val()
    }));
});

$(".deposit-button1").click(function() {
    $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({
        amount: $("#deposit-amount").val()
    }));
});

$(".transfer-button1").click(function() {
    $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({
        target: $("#transfer-player-id").val(),
        amount: $("#transfer-amount").val()
    }));
});

$(document).keyup(function(e) {
    if (e.keyCode === 27) {

        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        $(".container").fadeOut()
    }


});