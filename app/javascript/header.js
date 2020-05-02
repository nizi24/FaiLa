$(function() {
  var $slideMenu = $('.slide-menu')

  $(document).on("click", ".menu-trigger", function () {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $slideMenu.removeClass('open');
      $slideMenu.addClass('close');
      $('#logo').css('pointer-events', '')
    } else {
      $(this).addClass('active');
      $slideMenu.removeClass('close');
      $slideMenu.addClass('open');
      $('#logo').css('pointer-events', 'none')
    }
  });
});
