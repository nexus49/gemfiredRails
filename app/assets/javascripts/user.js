$(document).ready(function(){

    $('.new_user_row').delegate('div[data-role=submit]', "click", function(){
        var values = new Object();
        values.firstname = $('input[name="firstname"]').val();
        values.lastname =  $('input[name="lastname"]').val();



        $.ajax({
            type: 'POST', url: noCacheUrl('/users'),
            data: { data:$.toJSON(values) }, async:   false,
            beforeSend: function( xhr ) {
                var token = $("meta[name='csrf-token']").attr("content");
                xhr.setRequestHeader("X-CSRF-Token", token);
              },
            success: function() {
                location.reload();
            }
        });
    });
});