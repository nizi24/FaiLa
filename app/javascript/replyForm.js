$(function() {

  $('.micropost-item-reply').on('click', function() {
    var $replyForm = $(this).parents('.micropost-detail').find('.reply-form');
    $replyForm.slideDown();
  });

  $('.reply-form').find('.fa-times').on('click', function() {
    var $replyForm = $(this).parents('.reply-form');
    $replyForm.slideUp();
  });

});
