// Embed Video
EmbedVideo = {
  currentInstance: null,
  
  sampleCode: '<div class="embed-video">'
      + '<a href="#" data-item-type="video" data-video-sources="'
      + '/system/videos/2012/02/02/23_06_48_657_heli.mp4,'
      + '/system/videos/2012/02/02/23_06_45_420_heli.webm,'
      + '/system/videos/2012/02/02/23_06_34_928_heli.ogv" title="Helicopter">'
      + '<div class="video-watermark"></div>'
      + '<img alt="Tera_wallpaper_08_apr2010_1920x1080" src="'
      + '/system/images/BAhbB1sHOgZmSSJEMjAxMi8wMi8wNy8yMF8wM181Nl83NjJfVEVSQV9XYWxscGFwZXJfMDhfYXByMjAxMF8xOTIweDEwODAuanBnBjoGRVRbCDoGcDoKdGh1bWJJIg4yMDB4MjAwI2MGOwZU/TERA_Wallpaper_08_apr2010_1920x1080">'
      + '<span class="video-link">Helicopter</span></a></div>',
  
  addVideoButtonHtml: "<li class='wym_tools_add_video'>"
      + "<a href='#' class='add_video_link'>Add Video</a></li>",
  
  addEmbedVideoButton: function(wym){
    $(wym._box).find('.wym_tools_image').after(EmbedVideo.addVideoButtonHtml);
    $(wym._box).find('.add_video_link').data("wymeditorinstance", wym._index);
    $(wym._box).find('.add_video_link').click(function(e) {
      e.preventDefault();
      EmbedVideo.currentInstance = $(this).data("wymeditorinstance");
      var dom = $('#embed-video-dialog');
      if( dom.length < 1 ) {
        dom = $('<div id="embed-video-dialog"></div>')
      }
      dom.dialog({title: "Add Video", width:1000, height:513});
      dom.load("/refinery/videos/embed");
      //wym.insert(EmbedVideo.sampleCode);
      return(false);
    });
  },
  
  embedVideo: function(){
    var wym = WYMeditor.INSTANCES[EmbedVideo.currentInstance];
    var video = $('#embed-video-list li.selected');
    if(video.length > 0){
      var width = $("#embed-video-list #embed-video-width").val();
      var height = $("#embed-video-list #embed-video-height").val();
      var code = video.find(".video-embed-code").html();
      code = code.replace(/width="[0-9]*/, 'width="' + width);
      code = code.replace(/height="[0-9]*/, 'height="' + height);
      wym.insert(code);
    }
    $('#embed-video-dialog').dialog("close");
    return(false);
  },
  
  initVideoButtons: function(){
    WYMeditor.INSTANCES.forEach( function(wym){
      EmbedVideo.addEmbedVideoButton(wym);
    });
  }
};

$(function(){
  setTimeout(EmbedVideo.initVideoButtons, 333);
  $('#embed-video-submit').live("click", EmbedVideo.embedVideo);
  $('#existing_video_area_content ul li').live("click", function(e){
    e.preventDefault();
    $(this).siblings().removeClass("selected");
    $(this).addClass("selected");
  });
});
