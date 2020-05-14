$(function() {

  $('.notice').find('.text-warning').on('click', function(){
    if ($('.notice-field').hasClass('open')) {
      $('.notice-field').removeClass('open');
    } else {
      $('.notice-field').addClass('open');
    }
  });

  $(document).on('click', ".fa-bell", function(){
    if ($('.notice-field').hasClass('open')) {
      $('.notice-field').removeClass('open');
    } else {
      $('.notice-field').addClass('open');
    }
  });

  $('.notice-field').find('.fa-times').on('click', function() {
    $('.notice-field').removeClass('open');
  });

  $('.notice-action-user-icon').on('click', function(){
    var $actionUserLink = $(this).find("[name='action_user']").attr('value')
    window.location.href = '/users/' + $actionUserLink
  });

  $('.notice-message').on('click', function() {
    var $noticeLink = $(this).find("[name='link']").attr('value')
    window.location.href = $noticeLink
  });
});
