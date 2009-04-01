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

function spinner(show) {
  if (show) {$('#ajax_spinner').show()}
  else {$('#ajax_spinner').hide()}
};

function show_name_details(element) {
  //if (element.attr('name_string_id') == undefined) return;
  $("#name_column_right").removeClass("name_column_right_inactive");
  $("#name_column_right").addClass("name_column_right_active");
  var name_string_id = element.attr('name_string_id');
    spinner(true);
  $.get('/name_strings/'+ name_string_id, {},
    function(data) {
      $('#name_column_right').html(data);
      spinner(false);
    });
}

$(function() {
  
  // Set focus on login text input for login
  $("input#login,input#user_login,input#data_source_title").focus();

  // Set zebra style for data tables
  $("table.data tbody tr:nth-child(even)").addClass("even");

  // Set info/error messages dissapear after 5 seconds
  //$("div#flash").fadeIn("slow").animate({opacity: 1.0}, 10000).fadeOut("slow");
  $("div#flash").show(1500);

  $("#submit_import_data").confirm({
    msg:'Import new and delete old data? ',
    timeout:5000, 
    buttons: {
      wrapper:"<button></button>",
      separator:"&nbsp;&nbsp;&nbsp;"
    }
  });

  $("div.name_string_active").each(
    function(){
      show_name_details($(this));
    }
  );

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
        $(this).removeClass("name_string_active");
      });
      $(this).removeClass("name_string_hover");
      $(this).addClass("name_string_active");
      show_name_details($(this));
    }
   );

  // Show how import status is changing for data_source import
  
  $('#import_in_progress').everyTime(15000, function() {
      var import_scheduler_id = $(this).attr('import_scheduler_id');
      if (import_scheduler_id > 0){
        $.getJSON('/import_schedulers/' + import_scheduler_id, {},
          function(data) {
              if (data.status == "4"){
                document.location = document.location
              }
              var message = data.message;
              $('#import_in_progress').text(message);
            }
          )
      } else {
        $('#import_in_progress').text("No imports had been scheduled yet.");
      }
  });

  $('.valid_url').bind('blur', function(event) {
    var bound_element = $(this);
    $.getJSON('/url_check', {url: $(this).attr('value')},
      function(data) {
        bound_element.siblings().filter('[class=valid_url_message]').text(data.message);
      }
    );
  });

  // Fix the size of the window according to the length of name_string detail table

});
