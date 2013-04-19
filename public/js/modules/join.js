define(['utility'], function() {
  var nameCtrl = $('#nameInput');
  nameCtrl.focus();
  if( Minion.isPickLess() )
    $('#lblPickLess').removeClass('hide');
  else
    $('#lblPickMore').removeClass('hide');
  
  function validateInput() {
    var parentNameCtrl = nameCtrl.parent().parent();
    var inputOk = true;
    parentNameCtrl.removeClass('error');
    
    if( !nameCtrl.val() ) {
      parentNameCtrl.addClass('error');
      inputOk = false;
    }
    
    return inputOk;
  }
  
  $('#frmJoinRoom').submit(function() {
    return validateInput();
  });
});
