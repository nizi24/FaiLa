$(function() {

  $('.post-modal-trigger').on('click', function() {
    $('.modal-bg').fadeIn();
  });

  $('.fa-times').on('click', function() {
    $('.modal-bg').fadeOut();
  });

});
