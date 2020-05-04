$(function(){

  $('.posted-select-microposts').on('click', function() {
    $('.user-articles').hide();
    $('.user-microposts').show();
  });

  $('.posted-select-articles').on('click', function() {
    $('.user-microposts').hide();
    $('.user-articles').show();
  });
});
