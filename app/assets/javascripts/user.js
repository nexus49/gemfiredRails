$(document).ready(function(){

    $('.search_row').delegate('div[data-role=submit]', "click", function(){
            var values = new Object();
            values.search_query= $('input[name="search"]').val();


            $.ajax({
                type: 'GET', url: noCacheUrl('/users_search'),
                data: { data:$.toJSON(values) }, async:   false,
                beforeSend: function( xhr ) {
                    var token = $("meta[name='csrf-token']").attr("content");
                    xhr.setRequestHeader("X-CSRF-Token", token);
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.setRequestHeader("Accept", "application/json");
                  },
                success: function(resp){
                    console.log("Received query response: "+$.toJSON(resp));
                    populateTable(resp,$('#user_table tbody'));
                }
            });
        });

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
            success: function(resp){
                refreshTable();
            }
        });
    });

//    $.poll(10000, function(retry){
//           refreshTable();
//           retry();
//    });
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
                    console.log("Received response: "+$.toJSON(resp));

                    populateTable(resp,$('#user_table tbody'));

                    console.log("Refreshing table...done");
                   },
                async:   true
            });
};

function populateTable(result, selector){
    var html ="";
    for(i=0;i<result.length;i++) {
        html += "<tr><td>"+result[i].firstname+"</td><td>"+result[i].lastname+"</td></tr>";
    }
    selector.html(html);
};