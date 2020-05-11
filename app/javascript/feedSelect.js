$(function(){

  $.fn.colorChangeBtn = function() {
    if ($(this).hasClass('btn-outline-info')) {
      var $currentSerect = $('.feed').find('.btn-info');
      $currentSerect.removeClass('btn-info');
      $currentSerect.addClass('btn-outline-info');
      $(this).removeClass('btn-outline-info');
      $(this).addClass('btn-info');
    }
  }

  function showSelected (feed) {
    var $selected = $(feed).find('.hold-selected').find('.btn-success')
    if ($selected.hasClass('select-left')) {
      $('.feed-left').show();
      $('.feed-center').hide();
      $('.feed-right').hide();
    } else if ($selected.hasClass('select-center')) {
      $('.feed-left').hide();
      $('.feed-center').show();
      $('.feed-right').hide();
    } else {
      $('.feed-left').hide();
      $('.feed-center').hide();
      $('.feed-right').show();
    }
  }

  $('.timeline-select').on('click', function() {
    $(this).colorChangeBtn();
    $('.trend').hide();
    $('.timeline').show();
    showSelected('.timeline');
  });

  $('.trend-select').on('click', function() {
    $(this).colorChangeBtn();
    $('.trend').show();
    $('.timeline').hide();
    showSelected('.trend');
  });
});
