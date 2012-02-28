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
            success: function(){
                refreshTable();
            }
        });

    });

    $.poll(5000, function(retry){
           refreshTable();
           retry();
    });
    refreshTable();

});

function refreshTable()
{
    console.log("Refreshing table...");
    $.ajax({
            url: "/users",
                beforeSend: function( xhr ) {
                    var token = $("meta[name='csrf-token']").attr("content");
                    xhr.setRequestHeader("X-CSRF-Token", token);
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.setRequestHeader("Accept", "application/json");
                  },
                success: function(resp) {
                    console.log("Refreshing table...Response: "+resp);

                    var html ="";
                    for(i=0;i<resp.length;i++) {
                        html += "<tr><td>"+resp[i].firstname+"</td><td>"+resp[i].lastname+"</td></tr>";
                    }
                    $('#user_table tbody').html(html);

                    console.log("Refreshing table...done");

                   },
                async:   true
            });
};