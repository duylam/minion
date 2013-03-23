define([], function() {
  var warningSection = $('#warningSection');
  $('.close', warningSection).click(function() {
    warningSection.removeClass('visible').addClass('invisible');
  });
  
  function validateInput() {
    var msgLabel = $('#warningMessage');
    var inputOk = true;
    
    if( $('#peopleAmountInput :selected').val() == '0' ) {
      msgLabel.text('Chọn người dùm cái bạn ơi');
      inputOk = false;
    }
    
    if( inputOk && !$('#nameInput').val() ) {
      msgLabel.text('Nhập tên vô dùm cái bạn ơi');
      inputOk = false;
    }
    
    if( !inputOk ) {
      warningSection.removeClass('invisible').addClass('visible');
    }
    
    return inputOk;
  }
  
  $('#btnCreateRoom').click(function() {
    if( validateInput() ) $('#frmCreatRoom').submit();
  });
});
