/* Startup
----------------------------------*/
$(document).ready(function() {
	var ServerDetailsDialog = $('#ServerDetailsDialog').dialog({
		autoOpen: false,
		modal: true,
		title: 'Server details',
		width: 400,
		resizable: false
	});
	var PackageDetailsDialog = $('#PackageDetailsDialog').dialog({
		autoOpen: false,
		modal: true,
		title: 'Package details',
		width: 400,
		resizable: false
	});
	var PackageImportDialog = $('#PackageImportDialog').dialog({
		autoOpen: false,
		modal: true,
		title: 'Package details',
		width: 400,
		resizable: false
	});
	var LogDialog = $('#LogDialog').dialog({
		autoOpen: false,
		modal: true,
		title: 'Installation Log',
		width: 600,
		height:300
	});
	var ServerDeleteDialog = $('#ServerDeleteDialog').dialog({
		autoOpen: false,
		modal: true,
		title: 'Delete server',
		width: 400,
		height: 20,
		resizable: false
	});

	// Initialise the buttons
	$('SPAN.reload-button').bind('click', function() {
		$(this).parent('FORM').submit();
	});
	$('SPAN.logout-button').bind('click', function() {
		$(this).parent('FORM').submit();
	});
	$('#cancelServer').bind('click', function() {
		ServerDetailsDialog.dialog('close');
	});
	$('#addServerButton').bind('click', function(e) {
		$('#oldName').attr({ 'value': '' });
		$('#serverName').attr({ 'value': '' });
		$('#serverUri').attr({ 'value': '' });
		$('#serverForceBuild').attr({ 'checked': true });
		$('#serverStartStop').attr({ 'checked': true });
		$('#deleteServer').addClass('hidden');
		ServerDetailsDialog.dialog('open');
	});
	$('#loadPackageButton').bind('click', function(e) {
		PackageImportDialog.dialog('open');
	});
	$('#viewLogButton').bind('click', function(e) {
		LogDialog.dialog('open');
	});
	$('#viewLogLink').bind('click', function(e) {
		LogDialog.dialog('open');
	});
	$('#deleteServer').bind('click', function() {
		ServerDetailsDialog.dialog('close');
		var serverName = $('#oldName').attr('value');
		$('#deleteServerLabel').text(serverName);
		$('#deleteServerField').attr({ 'value': serverName });
		ServerDeleteDialog.dialog('open');
	});
	$('#cancelDeleteServer').bind('click', function(e) {
		ServerDeleteDialog.dialog('close');
	});

	// Associate the click handlers
	$('#Packages div.section-content a.dialog-link').bind('click', function(e) {
		var row = $(e.target).parents('tr');
		
		$('#PackageDetailsDialogName').text($(row).find(".data-name").text());
		$('#PackageDetailsDialogDescription').text($(row).find(".data-description").text());
    	$('#nameOfPackage').text($(row).find(".data-filename").text());
		
		var action = 'Install';
		if ($(row).find(".data-installed").length > 0) {
            action = 'Uninstall';
            $('#removeButton').addClass('hidden');
        }else{
            $('#removeButton').removeClass('hidden');
        }
        
		$('#installButton').attr({ 'value': action });
		PackageDetailsDialog.dialog('open');
    });
	
	$('#Servers div.section-content a.dialog-link').bind('click', function(e) {
		var row = $(e.target).parents('tr');
		
		$('#oldName').val($(row).find(".data-name").text());
		$('#serverName').val($(row).find(".data-name").text());
		$('#serverUri').val($(row).find(".data-url").text());
		
		$('#serverForceBuild').attr('checked', $(row).find(".data-force-build-enabled").length > 0);
		$('#serverStartStop').attr('checked', $(row).find(".data-start-enabled").length > 0);
		
		$('#deleteServer').removeClass('hidden');
		ServerDetailsDialog.dialog('open');
    });

});


/* Validation
----------------------------------*/
function ValidateServerDetailsDialog() {
	var isNameValid = ValidateRequiredInput($('#serverName'));
	var isUriValid = ValidateRequiredInput($('#serverUri'));
	return (isNameValid && isUriValid);
}

function ValidateRequiredInput(input) {
	var isValid = $(input).val() != '';
	var inputClass = (isValid) ? 'valid' : 'invalid';
	
	$(input).removeClass('invalid valid');
	$(input).addClass(inputClass);
	
	return isValid;
}
