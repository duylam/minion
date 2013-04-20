define([], function() {
  var nameCtrl = $('#nameInput');
  nameCtrl.focus();  
  function validateInput() {
    var parentNameCtrl = nameCtrl.parent().parent();
    var inputOk = true;
    parentNameCtrl.removeClass('error');
    
    if( !nameCtrl.val() ) {
      parentNameCtrl.addClass('error');
      nameCtrl.focus();
      inputOk = false;
    }
    
    return inputOk;
  }
  
  $('#frmCreatRoom').submit(function() {
    return validateInput();
  });
});
