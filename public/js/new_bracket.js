$(document).ready(function() {

  var current_team_num = 2;

  var setDropdown = function() {
    $('input.form_box_md_input_text').focus(function() {

      if ($(this).attr('id') != 'title_input') {
        if ($(this).val() == '') {
          var position = $(this).offset();
          var top = position.top + 40;
          var left = position.left;
          var width = $(this).outerWidth();
          $('.team_form_dropdown').css({top: top, left: left, width: width}).show();
          $(this).keyup(function() {
            if ($(this).val() == '') {
              $('.team_form_dropdown').show();
            } else {
              $('.team_form_dropdown').hide();
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
        $('.team_form_dropdown').fadeOut(200);
      } else {
        $('.team_form_dropdown').fadeOut(200);
      }
    });

  };

  $('.team_form_dropdown').hide().removeClass('hide');
  setDropdown();

  $('#add_team_btn').click(function() {
    $("<div class='team_form_box' style='margin-top: 0' id='team" + (current_team_num + 1) + "'><p>TEAM " + (current_team_num + 1) + "</p><input type='text' name='bracket[team][]'' class='form_box_md_input_text'></div>").insertAfter('#team' + current_team_num);
    setDropdown();
    current_team_num ++;
  });

});
