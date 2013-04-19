define([], function() {
  var nameCtrl = $('#nameInput');
  $('#lblPlayerAmount').text($('#server_playerAmount').val());
  nameCtrl.focus();
  if($('#server_pickLess').val() == 'true')
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
  
  $('#btnJoinRoom').click(function() {
    if( validateInput() ) $('#frmJoinRoom').submit();
  });
});
