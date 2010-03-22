
function posting() {
	if (($('ticket_content').value.length) < 4) {
		$('new_ticket_msg').innerHTML = '<b><span>A Ticket requires at least 3 characters</span></b>';
		return false;
	}
	else {
		($('x_submit')).disabled = true;
		($('x_submit')).form.onsubmit();
		($('ticket_content')).value = '';
	}
}


function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

addLoadEvent(function() { 
	if ($('ticket_content')!= null) {
  $('ticket_content').focus();}
});
