/* Copied from [1] and modified.
 *
 * 1: https://github.com/resolve/refinerycms/blob/e8d2091556c2fe5db657d41ee5a396cf54aa8d0c/core/app/assets/javascripts/refinery/admin.js.erb
 */

var video_dialog = {
  initialised: false
  , callback: null

  , init: function(callback){

    if (!this.initialised) {
      this.callback = callback;
      this.init_tabs();
      this.init_select();
      this.init_actions();
      this.initialised = true;
    }
    return this;
  }

  , init_tabs: function(){
    var radios = $('#dialog_menu_left input:radio');
    var selected = radios.parent().filter(".selected_radio").find('input:radio').first() || radios.first();

    radios.click(function(){
      link_dialog.switch_area($(this));
    });

    selected.attr('checked', 'true');
    link_dialog.switch_area(selected);
  }

  , switch_area: function(radio){
    $('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $(radio).parent().addClass('selected_radio');
    $('#dialog_main .dialog_area').hide();
    $('#' + radio.value + '_area').show();
  }

  , init_select: function(){
    $('#existing_video_area_content ul li img').click(function(){
        video_dialog.set_video(this);
    });
    //Select any currently selected, just uploaded...
    if ((selected_img = $('#existing_video_area_content ul li.selected img')).length > 0) {
      video_dialog.set_video(selected_img.first());
    }
  }

  , set_video: function(img){
    if ($(img).length > 0) {
      $('#existing_video_area_content ul li.selected').removeClass('selected');

      $(img).parent().addClass('selected');
      var videoId = $(img).attr('data-id');
      var geometry = $('#existing_video_size_area li.selected a').attr('data-geometry');
      var size = $('#existing_video_size_area li.selected a').attr('data-size');
      //var resize = $("#wants_to_resize_video").is(':checked');

      video_url = resize ? $(img).attr('data-' + size) : $(img).attr('data-original');

      if (parent) {
        if ((wym_src = parent.document.getElementById('wym_src')) != null) {
          wym_src.value = video_url;
        }
        if ((wym_title = parent.document.getElementById('wym_title')) != null) {
          wym_title.value = $(img).attr('title');
        }
        if ((wym_alt = parent.document.getElementById('wym_alt')) != null) {
          wym_alt.value = $(img).attr('alt');
        }
        if ((wym_size = parent.document.getElementById('wym_size')) != null
            && typeof(geometry) != 'undefined') {
          wym_size.value = geometry.replace(/[<>=]/g, '');
        }
      }
    }
  }

  , submit_video_choice: function(e) {
    e.preventDefault();
    if((img_selected = $('#existing_video_area_content ul li.selected img').get(0)) && $.isFunction(this.callback))
    {
      this.callback(img_selected);
    }

    close_dialog(e);
  }

  , init_actions: function(){
    var _this = this;
    // get submit buttons not inside a wymeditor iframe
    $('#existing_video_area .form-actions-dialog #submit_button')
      .not('.wym_iframe_body #existing_video_area .form-actions-dialog #submit_button')
      .click($.proxy(_this.submit_video_choice, _this));

    // get cancel buttons not inside a wymeditor iframe
    $('.form-actions-dialog #cancel_button')
      .not('.wym_iframe_body .form-actions-dialog #cancel_button')
      .click($.proxy(close_dialog, _this));

    $('#existing_video_size_area ul li a').click(function(e) {
      $('#existing_video_size_area ul li').removeClass('selected');
      $(this).parent().addClass('selected');
      $('#existing_video_size_area #wants_to_resize_video').attr('checked', 'checked');
      video_dialog.set_video($('#existing_video_area_content ul li.selected img'));
      e.preventDefault();
    });

    video_area = $('#existing_video_area').not('#wym_iframe_body #existing_video_area');
    video_area.find('.form-actions input#submit_button').click($.proxy(function(e) {
      e.preventDefault();
      $(this.document.getElementById('wym_dialog_submit')).click();
    }, parent));
    video_area.find('.form-actions a.close_dialog').click(close_dialog);
  }
};
