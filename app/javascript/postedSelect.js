$(function(){

  $.fn.colorChange = function() {
    if ($(this).hasClass('btn-light')) {
      var $currentSerect = $(this).parent('.posted-select').find('.btn-success');
      $currentSerect.removeClass('btn-success');
      $currentSerect.addClass('btn-light');
      $(this).removeClass('btn-light');
      $(this).addClass('btn-success');
    }
  }

  $('.trend').find('.col-6').on('click', function() {
    $(this).colorChange();
    if ($(this).hasClass('select-article')) {
      $('.article-trend').show();
      $('.micropost-trend').hide();
    } else {
      $('.article-trend').hide();
      $('.micropost-trend').show();
    }
  });

  $('.select-left').on('click', function() {
    $(this).colorChange();
    $('.feed-left').show();
    $('.feed-center').hide();
    $('.feed-right').hide();
  });

  $('.select-center').on('click', function() {
    $(this).colorChange();
    $('.feed-left').hide();
    $('.feed-center').show();
    $('.feed-right').hide();
  });

  $('.select-right').on('click', function() {
    $(this).colorChange();
    $('.feed-left').hide();
    $('.feed-center').hide();
    $('.feed-right').show();
  });


});
