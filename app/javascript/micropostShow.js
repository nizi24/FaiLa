$(function() {

  $('.reply-form').on('click', function(e) {
    if ($(e.target).is('input')) {
      return true;
    } else {
      return false;
    }
  });

    // 下4つは同じことをしているのでそのうち修正
    // もっといい方法がありそう
  $('.micropost-item').on('click', function(e) {
    if (!$(e.target).closest('.micropost-item-footer').length) {
      var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
      window.location.href = '/microposts/' + micropostLink
    }
  });

  $('.received-replies').find('.micropost-detail').on('click', function(e) {
    if (!$(e.target).closest('.micropost-item-footer').length) {
      var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
      window.location.href = '/microposts/' + micropostLink
    }
  });

  $('.sended-replies').find('.micropost-detail').on('click', function(e) {
    if (!$(e.target).closest('.micropost-item-footer').length) {
      var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
      window.location.href = '/microposts/' + micropostLink
    }
  });

  $('.replies').find('.micropost-detail').on('click', function(e) {
    if (!$(e.target).closest('.micropost-item-footer').length) {
      var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
      window.location.href = '/microposts/' + micropostLink
    }
    });
});
