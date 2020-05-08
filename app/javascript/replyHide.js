$(function() {

    var text = $('.sended-replies-hide').text();

  $('.sended-replies-hide').on('click', function() {
    var $span = $(this).find('span');

    if ($span.hasClass('hide')) {
      $('.sended-replies').slideDown();
      $span.text('返信先を隠す');
      $span.removeClass('hide');
    } else {
      $('.sended-replies').slideUp();
      $span.addClass('hide');
      $span.text(text);
    }
  });

  var textAs = $('.received-replies-hide').text();

  $('.received-replies-hide').on('click', function() {
    var $span = $(this).find('span');

    if ($span.hasClass('hide')) {
      $('.received-replies').slideDown();
      $span.text('返信を隠す');
      $span.removeClass('hide');
    } else {
      $('.received-replies').slideUp();
      $span.addClass('hide');
      $span.text(textAs);
    }
  });
});
