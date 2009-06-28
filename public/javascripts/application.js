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
  if (show) {$('#ajax_spinner').show();}
  else {$('#ajax_spinner').hide();}
};

function show_name_details(element,do_show_tree) {
  //if (element.attr('name_string_id') == undefined) return;
  $("#name_column_right").removeClass("name_column_right_inactive");
  $("#name_column_right").addClass("name_column_right_active");
  show_tree = '';
  if (do_show_tree) show_tree = '?show_tree=1';
  var name_string_id = element.attr('name_string_id');
    spinner(true);
  $.get('/name_strings/'+ name_string_id + show_tree, {},
    function(data) {
      $('#name_column_right').html(data);
      spinner(false);
    });
}

function strip(a_string) {
  return a_string.replace(/^\s+|\s+$/g,"");
}

function toggle_parsed_information() {
  var tree = $('.tree_root');
  if (tree.is(':hidden')) {
    tree.slideDown();
    $('#parsed_information').text('Parsed information (hide)');
  } else {
    tree.slideUp();    
    $('#parsed_information').text('Parsed information (show)');
  }
  
};

$(function() {
  
  // Set focus on login text input for login
  $("input#login,input#user_login,input#data_source_title,input#search_term").focus();

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
      show_name_details($(this),false);
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
      var show_tree = true;
      if ($('.tree_root').is(':hidden')) {
        show_tree = false;
      }
      show_name_details($(this), show_tree);
    }
   );

  // Show how import status is changing for data_source import
  
  $('#import_in_progress').everyTime(15000, function() {
      var import_scheduler_id = $(this).attr('import_scheduler_id');
      if (import_scheduler_id > 0){
        $.getJSON('/import_schedulers/' + import_scheduler_id, {},
          function(data) {
              if (data.status == "4" || data.status == "3" || data.status == "5"){
                document.location = document.location;
              }
              var message = data.message;
              $('#import_in_progress').text(message);
            }
          );
      } else {
        $('#import_in_progress').text("No imports had been scheduled yet.");
      }
  });
  
  $('#search_help').bind('click', function(event) {
      if ($('#search_help_body').is(':hidden')) {
        $(this).text('Hide Help');
        $('#search_help_body').slideDown();//.css('display','none');
      } else {
        $(this).text('Help');
        $('#search_help_body').slideUp();//.css('display','block');
      }
      $("input#search_term").focus();
    }
  );
  
  $('.valid_url').bind('blur', function(event) {
    var bound_element = $(this);
    var url_to_check = strip($(this).attr('value'));
    if (url_to_check != '') {
      $.getJSON('/url_check', {url: url_to_check},
        function(data) {
          bound_element.siblings().filter('[class=valid_url_message]').text(data.message);
        }
      );
    } else {
      bound_element.siblings().filter('[class=valid_url_message]').text('');
      bound_element.attr('value','');
    }
  });
  
  // $('.valid_logo_url').bind('blur', function(event) {
  //   var bound_element = $(this);
  //   var data_source_id = $('form').attr('id').split('_').pop()
  //   $.getJSON('/url_check?type=logo', {url: $(this).attr('value'), data_source_id: data_source_id},
  //     function(data) {
  //       bound_element.siblings().filter('[class=valid_url_message]').text(data.message);
  //       if (data.message == 'OK') {
  //         bound_element.siblings().filter('[class=logos_show]').show();
  //       }
  //     }
  //   );
  // });

  // Fix the size of the window according to the length of name_string detail table

});
