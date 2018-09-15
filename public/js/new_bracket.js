$(document).ready(function() {

  var current_team_num = 2;
  var teams_arr = []

  var setDropdown = function() {
    $('input.form_box_md_input_text').focus(function() {

      if ($(this).attr('id') != 'title_input') {
        if ($(this).val() == '') {
          var position = $(this).offset();
          var top = position.top + 40;
          var left = position.left;
          var width = $(this).outerWidth();
          $('.team_form_dropdown').stop(true, true).css({top: top, left: left, width: width}).show();
          console.log('show1');
          $(this).keyup(function() {
            if ($(this).css('color') != '#424242') {
              $(this).css({color: '#424242'});
            }
            if ($(this).val() == '') {
              $('.team_form_dropdown').css({top: top, left: left, width: width}).show();
              console.log('show2');
            } else {
              $('.team_form_dropdown').hide();
              console.log('hide1');
            };
          });
        };
      };
    });

    var team_clicked = false;
    var fill_value = "";
    $('.team_form_dropdown_row').mousedown(function(){
      team_clicked = true;
      fill_value = $.trim($(this).text());
    });

    $('input.form_box_md_input_text').blur(function() {
      if (team_clicked) {
        $(this).val(fill_value).focus();
        team_clicked = false;

      }
      $('.team_form_dropdown').fadeOut(200);
      console.log('fadeout1');
    });

  };

  $('#new_bracket_form').submit(function(e){
    var ok = true;
    teams_arr = [];
    $('.form_box_md_input_text').each(function(index) {
      if ((teams_arr.indexOf($(this).val()) == -1) && (index > 0) && $(this).val() != '') {
        teams_arr.push($(this).val());
      } else if (index > 0 && $(this).val() != '') {
        $(this).css({color: 'red'});
        ok = false;
      }
    });
    console.log(ok);
    if (ok == false) {
      e.preventDefault();
    }
  });

  $('.team_form_dropdown').hide().removeClass('hide');
  setDropdown();

  $('#add_team_btn').click(function() {
    $("<div class='team_form_box' style='margin-top: 0' id='team" + (current_team_num + 1) + "'><p>TEAM " + (current_team_num + 1) + "</p><input type='text' name='bracket[team][]'' class='form_box_md_input_text'></div>").insertAfter('#team' + current_team_num);
    setDropdown();
    current_team_num ++;
  });

});
