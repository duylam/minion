define([], function() {
  var selectCtrl = $('#peopleAmountInput');
  var nameCtrl = $('#nameInput');
    
  selectCtrl.focus();  
  function validateInput() {
    var parentNameCtrl = nameCtrl.parent().parent();
    var parentSelectCtrl = selectCtrl.parent().parent();
    var inputOk = true;
    parentNameCtrl.removeClass('error');
    parentSelectCtrl.removeClass('error');
    
    if( $(':selected', selectCtrl).val() == '0' ) {
      parentSelectCtrl.addClass('error');
      inputOk = false;
    }
    
    if( !nameCtrl.val() ) {
      parentNameCtrl.addClass('error');
      inputOk = false;
    }
    
    return inputOk;
  }
  
  $('#frmCreatRoom').submit(function() {
    return validateInput();
  });
});
