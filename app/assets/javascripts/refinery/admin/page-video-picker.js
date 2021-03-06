$(document).ready(function(){
  $('#custom_videos_tab a').click(function(){
    if (!(picker = $('#page_video_picker')).data('size-applied')){
      wym_box = $('.page_part:first .wym_box');
      iframe = $('.page_part:first iframe');
      picker.css({
        height: wym_box.height()
        , width: wym_box.width()
      }).data('size-applied', true).corner('tr 5px').corner('bottom 5px').find('.wym_box').css({
        backgroundColor: 'white'
        , height: iframe.height() + $('.page_part:first .wym_area_top').height() - parseInt($('.wym_area_top .label_inline_with_link a').css('lineHeight'))
        , width: iframe.width() - 20
        , 'border-color': iframe.css('border-top-color')
        , 'border-style': iframe.css('border-top-style')
        , 'border-width': iframe.css('border-top-width')
        , padding: '0px 10px 0px 10px'
      });
    }
  });

  // Webkit browsers don't like the textarea being moved around the DOM,
  // they ignore the new contents. This is fixed below by adding a hidden
  // field that stays in place.
  $('#content #page_videos li textarea:hidden').each(function(index) {
    var old_name = $(this).attr('name');
    $(this).attr('data-old-id', $(this).attr('id'));
    $(this).attr('name', 'ignore_me_' + index);
    $(this).attr('id', 'ignore_me_' + index);

    var hidden = $('<input>')
                  .addClass('caption')
                  .attr('type', 'hidden')
                  .attr('name', old_name)
                  .attr('id', $(this).attr('data-old-id'))
                  .val($(this).val());

    $(this).parents('li').first().append(hidden);
  });

  reset_video_picker_functionality();
});

reset_video_picker_functionality = function() {
  WYMeditor.onload_functions.push(function(){
    $('.wym_box').css({'width':null});
  });

  $("#page_videos").sortable({
    'tolerance': 'pointer'
    , 'placeholder': 'placeholder'
    , 'cursor': 'drag'
    , 'items': 'li'
    , stop: reindex_videos
  });

  $('#content #page_videos li:not(.next_video)').live('hover', function(e) {
    if (e.type == 'mouseenter' || e.type == 'mouseover') {
      if ((video_actions = $(this).find('.video_actions')).length == 0) {
        video_actions = $("<div class='video_actions'></div>");
        img_delete = $("<img src='/assets/refinery/icons/delete.png' width='16' height='16' />");
        img_delete.appendTo(video_actions);
        img_delete.click(function() {
          $(this).parents('li').first().remove();
          reindex_videos();
        });

        if ($(this).find('textarea.page_caption').length > 0) {
          img_caption = $("<img src='/assets/refinery/icons/user_comment.png' width='16' height='16' class='caption' />");
          img_caption.appendTo(video_actions);
          img_caption.click(open_video_caption);
        } else {
          video_actions.addClass('no_captions');
        }

        video_actions.appendTo($(this));
      }

      video_actions.show();
    } else if (e.type == 'mouseleave' || e.type == 'mouseout') {
      $(this).find('.video_actions').hide();
    }
  });

  reindex_videos();
}

video_added = function(video) {
  new_list_item = (current_list_item = $('li.next_video')).clone();
  video_id = $(video).attr('id').replace('video_', '');
  current_list_item.find('input:hidden:first').val(video_id);

  $("<img />").attr({
    title: $(video).attr('title')
    , alt: $(video).attr('alt')
    , src: $(video).attr('data-grid') // use 'grid' size that is built into Refinery CMS (135x135#c).
  }).appendTo(current_list_item);

  current_list_item.attr('id', 'video_' + video_id).removeClass('next_video');

  new_list_item.appendTo($('#page_videos'));
  reset_video_picker_functionality();
}

open_video_caption = function(e) {
  // move the textarea out of the list item, and then move the textarea back into it when we click done.
  (list_item = $(this).parents('li').first()).addClass('current_caption_list_item');
  textarea = list_item.find('.textarea_wrapper_for_wym > textarea');

  textarea.after($("<div class='form-actions'><div class='form-actions-left'><a class='button'>"+I18n.t('refinery.js.admin.page_videos.done')+"</a></div></div>"));
  textarea.parent().dialog({
     title: I18n.t('refinery.js.admin.page_videos.add_caption')
     , modal: true
     , resizable: false
     , autoOpen: true
     , width: 928
     , height: 530
   });

  $('.ui-dialog:visible .ui-dialog-titlebar-close, .ui-dialog:visible .form-actions a.button')
    .bind('click',
      $.proxy(function(e) {
        // first, update the editor because we're blocking event bubbling (third argument to bind set to false).
        $(this).data('wymeditor').update();
        $(this).removeClass('wymeditor')
               .removeClass('active_rotator_wymeditor');

        $this_parent = $(this).parent();
        $this_parent.appendTo('li.current_caption_list_item').dialog('close').data('dialog', null);
        $this_parent.find('.form-actions').remove();
        $this_parent.find('.wym_box').remove();
        $this_parent.css('height', 'auto');
        $this_parent.removeClass('ui-dialog-content').removeClass('ui-widget-content');

        $('li.current_caption_list_item').removeClass('current_caption_list_item');

        $('.ui-dialog, .ui-widget-overlay:visible').remove();

        $('#' + $(this).attr('data-old-id')).val($(this).val());
      }, textarea)
    , false);

  textarea.addClass('wymeditor active_rotator_wymeditor widest').wymeditor(wymeditor_boot_options);
}

reindex_videos = function() {
  $('#page_videos li textarea:hidden').each(function(i, input){
    // make the video's name consistent with its position.
    parts = $(input).attr('name').split('_');
    parts[2] = ('' + i);
    $(input).attr('name', parts.join('_'));

    // make the video's id consistent with its position.
    $(input).attr('id', $(input).attr('id').replace(/_\d/, '_' + i));
    $(input).attr('data-old-id', $(input).attr('data-old-id').replace(/_\d_/, '_'+i+'_').replace(/_\d/, '_' + i));
  });
  $('#page_videos li').each(function(i, li){
    $('input:hidden', li).each(function() {
      // make the video's name consistent with its position.
      parts = $(this).attr('name').split(']');
      parts[1] = ('[' + i);
      $(this).attr('name', parts.join(']'));

      // make the video's id consistent with its position.
      $(this).attr('id', $(this).attr('id').replace(/_\d_/, '_'+i+'_').replace(/_\d/, '_'+i));
    });
  });
}
