$(function(){
  var $slideMenu = $('.slide-menu')

  $('.menu-trigger').click(function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $slideMenu.removeClass('open');
      $slideMenu.addClass('close');
    } else {
      $(this).addClass('active');
      $slideMenu.removeClass('close');
      $slideMenu.addClass('open');
    }
  });
});
