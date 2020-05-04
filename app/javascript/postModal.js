$(function() {

  $('.post-modal-trigger').on('click', function() {
    $('#post-modal-bg').fadeIn();
  });

  $('.fa-times').on('click', function() {
    $('#post-modal-bg').fadeOut();
  });

});
