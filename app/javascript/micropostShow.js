$(function() {

  $('.micropost-item').on('click', function() {
    var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
    window.location.href = '/microposts/' + micropostLink
  });

  $('.received-replies').find('.micropost-detail').on('click', function() {
    var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
    window.location.href = '/microposts/' + micropostLink
  });

  $('.sended-replies').find('.micropost-detail').on('click', function() {
    var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
    window.location.href = '/microposts/' + micropostLink
  });

  $('.replies').find('.micropost-detail').on('click', function() {
    var micropostLink = $(this).find('.micropost-item-likes').find('input[name="likeable_id"]').attr('value')
    window.location.href = '/microposts/' + micropostLink
  });
});
