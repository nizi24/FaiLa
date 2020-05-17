$(function() {

  $('nav').find('.fa-search').on('click', function(){
    if ($(this).hasClass('mobile-only')) {
      if ($('.mobile-search-form').hasClass('open')) {
        $('.mobile-search-form').removeClass('open');
      } else {
        $('.mobile-search-form').addClass('open');
      }
    }
  });
});
