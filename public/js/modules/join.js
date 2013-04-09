define([], function() {
  $('#lblPlayerAmount').text($('#server_playerAmount').val());
  if($('#server_pickLess').val() == 'true')
    $('#lblPickLess').removeClass('hide');
  else
    $('#lblPickMore').removeClass('hide');
  
  function validateInput() {
    var nameCtrl = $('#nameInput');
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
