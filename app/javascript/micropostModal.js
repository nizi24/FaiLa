$(function() {
  $('.micropost-select').on('click', function() {
    $('#post-modal-bg').hide();
    $('#micropost-modal-bg').show();
  });

  $('.micropost-modal').find('.fa-times').on('click', function() {
    $('#micropost-modal-bg').hide();
    $('#post-modal-bg').show();
  });
});
