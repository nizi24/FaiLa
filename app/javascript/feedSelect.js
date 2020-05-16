$(function(){

  $.fn.colorChangeBtn = function() {
    if ($(this).hasClass('btn-outline-info')) {
      var $currentSerect = $('.container').find('.btn-info');
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
    showSelected('.timeline');
  });

  $('.trend-select').on('click', function() {
    showSelected('.trend');
  });

  $('.top-select').on('click', function() {
    $(this).colorChangeBtn();
    $('.top').show();
    $('.second').hide();
    $('.third').hide();
  });

  $('.second-select').on('click', function() {
    $(this).colorChangeBtn();
    $('.top').hide();
    $('.second').show();
    $('.third').hide();
  });

  $('.third-select').on('click', function() {
    $(this).colorChangeBtn();
    $('.top').hide();
    $('.second').hide();
    $('.third').show();
  });

});
