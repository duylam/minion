define([], function() {
  var warningSection = $('#warningSection');
  var pickLess = $('#btnPickLess');
  var pickMore = $('#btnPickMore');
  var btnSelectedCssName = 'btn-primary';
  var pickLessInput = $('#pickLessInput');
  pickLessInput.val(pickLess.hasClass(btnSelectedCssName));
  $('.close', warningSection).click(function() {
    warningSection.addClass('invisible');
  });
  
  _.each([pickLess, pickMore], function(ele) {
    ele.click(function() {
      var self = $(this);
      if( !self.hasClass(btnSelectedCssName) ) {
        pickLess.removeClass(btnSelectedCssName);
        pickMore.removeClass(btnSelectedCssName);
        self.addClass(btnSelectedCssName);
        pickLessInput.val(pickLess.hasClass(btnSelectedCssName));
      }
    });
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
      warningSection.removeClass('invisible');
    }
    
    return inputOk;
  }
  
  $('#btnCreateRoom').click(function() {
    if( validateInput() ) $('#frmCreatRoom').submit();
  });
});
