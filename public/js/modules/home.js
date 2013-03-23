define([], function() {
  var warningSection = $('#warningSection');
  $('.close', warningSection).click(function() {
    warningSection.removeClass('visible').addClass('invisible');
  });
  
  function validateInput() {
    var msgLabel = $('#warningMessage');
    var selectCtrl = $('#peopleAmountInput');
    var nameCtrl = $('#nameInput');
    var parentNameCtrl = nameCtrl.parent().parent();
    var parentSelectCtrl = selectCtrl.parent().parent();
    var inputOk = true;
    parentNameCtrl.removeClass('error');
    parentSelectCtrl.removeClass('error');
    
    if( $(':selected', selectCtrl).val() == '0' ) {
      msgLabel.text('Chọn người dùm cái bạn ơi');
      parentSelectCtrl.addClass('error');
      inputOk = false;
    }
    
    if( inputOk && !nameCtrl.val() ) {
      msgLabel.text('Nhập tên vô dùm cái bạn ơi');
      parentNameCtrl.addClass('error');
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
