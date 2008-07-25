//display elements in collection in firebug
//TODO: fix sorting
jQuery.fn.debug = jQuery.fn.dbg = function () {
  var elements = $.makeArray(this);
  return elements.sort(
    function(a,b){
      if (a.toString() < b.toString()) return -1;
      if (a.toString() > b.toString()) return 1;
      return 0;
      });
};


$(function() {
  
  // Set focus on login text input for login
  $("input#login,input#user_login").focus();

  // Set zebra style for data tables
  $("table.data tbody tr:nth-child(even)").addClass("even");

  // Set info/error messages dissapear after 5 seconds
  $("div#flash").animate({opacity: 1.0}, 5000).hide("slow");

  // Show how import status is changing for data_source import
  
  $('#data_source_import_status').everyTime(15000, function() {
      var import_scheduler_id = $(this).attr('import_scheduler_id');
      if (import_scheduler_id > 0){
        $.getJSON('/import_schedulers/' + import_scheduler_id, {},
          function(data) {
            var message = data.message;
            $('#data_source_import_status').text(message);
          })
      }
  });
      /*function(n){
        
        $(this).everyTime(1000, function() { $(this).text('here')})
        //if (import_scheduler_id) {
          $(this).everyTime("5s", function() {
              $.getJSON('/import_schedulers/' + import_scheduler_id,
                {},
                function(data){
                  var html = "</p>\n<p>" + data.message + "</p>\n";
                  $('#data_source_import_status').html(html);
              }
          );
          });
        };
      };
    );*/

});
