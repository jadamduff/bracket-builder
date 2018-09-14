$(document).ready(function() {

  var current_team_num = 2;

  var setDropdown = function() {
    $('input.form_box_md_input_text').focus(function() {
      var position = $(this).offset();
      var top = position.top + 40;
      var left = position.left;
      var width = $(this).outerWidth();
      $('.team_form_dropdown').css({top: top, left: left, width: width}).show();
    });

    $('input.form_box_md_input_text').focusout(function() {
      $('.team_form_dropdown').hide();
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
