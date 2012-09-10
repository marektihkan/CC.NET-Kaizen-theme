/* Startup
----------------------------------*/
$(document).ready(function() {
	BindFxCopSlidings();	
	BindMsBuildLogActions();	
});

function BindFxCopSlidings() {
	$('a.expandRule').click(function () {
		var msgid = $(this).attr('ref');
		$(this).closest('tr').next().find('td.contentCell div#' + msgid).slideToggle('fast');
		return false;
	});
		
	$('a.expandAllRules').click(function () {
		
		var msgs = $(this).closest('div.section').children('div.section-content').find('div.innerWrapper');
		
		var switchIcon = $(this).children('img');
		if(switchIcon.hasClass('collapsed'))
		{
			msgs.slideDown('fast');
		}
		else
		{
			msgs.slideUp('fast');
		}
		switchIcon.toggleClass('collapsed');
		return false;
	});
}

function BindMsBuildLogActions()
{
	$('div.section a.msbuildHeaderIcon').click(function(e) {	
		var collection = $(this).closest('div.section').children('div.section-content').find('tr[class ^= msbuild-message]');
		
		if( $(this).hasClass('msbuildMessagesOn') ) {
			collection.hide();
			$(this).removeClass('msbuildMessagesOn') 
			$(this).addClass('msbuildMessagesOff') 
		}
		else {
			collection.show();
			$(this).removeClass('msbuildMessagesOff') 
			$(this).addClass('msbuildMessagesOn') 
		}		
		e.preventDefault();
	});
}

