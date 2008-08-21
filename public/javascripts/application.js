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
  //$("div#flash").fadeIn("slow").animate({opacity: 1.0}, 10000).fadeOut("slow");
  $("div#flash").hide("fast").fadeIn("slow").animate({opacity: 1.0}, 10000).hide("slow");


  //modifies 
  $("div.name_string").hover(
    function () {
       $(this).addClass("name_string_hover");
       //$(this).append($("<span> ***</span>"));
    }, 
    function () {
       $(this).removeClass("name_string_hover");
       //$(this).find("span:last").remove();
    }).click(
    function() {
      $("div.name_string").each(function(){
        $(this).removeClass("name_string_click");
      });
      $(this).addClass("name_string_click");
    }
    );

  // Show how import status is changing for data_source import
  
  $('#import_in_progress').everyTime(15000, function() {
      var import_scheduler_id = $(this).attr('import_scheduler_id');
      if (import_scheduler_id > 0){
        $.getJSON('/import_schedulers/' + import_scheduler_id, {},
          function(data) {
            var message = data.message;
            $('#import_in_progress').text(message);
          })
      } else {
        $('#import_in_progress').text("No imports had been scheduled yet.");
      }
  });
});
