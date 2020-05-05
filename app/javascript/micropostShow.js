$(function() {

  $('.micropost-item').on('click', function() {
    var micropostLink = $(this).find('.micropost-body').find('a').attr('href')
    window.location.href = micropostLink
  });
});
