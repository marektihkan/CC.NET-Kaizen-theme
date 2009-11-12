/* Startup
----------------------------------*/
$(document).ready(function() {
    GroupProjectsByActivity();
    BindSliding();
    BindTooltips();
    BindMessage();
    BindShortcuts();
    BindDialogs();
    BindSearching();
});


/* Navigation
----------------------------------*/
function NavigateTo(linkElement) {
	var address = $(linkElement).attr('href');
	if (address != null) {
		window.location.href = address;
	}
}

/* Tooltips
----------------------------------*/
function BindTooltips() {
	BindTooltipTo('#show-all', '<p>Expand all sections</p><p class="shortcut">Shortcut: Q</p>');
	BindTooltipTo('#hide-all', '<p>Collapse all</p><p class="shortcut">Shortcut: W</p>');
	BindTooltipTo('#show-errors', '<p>Expand errors and warnings</p><p class="shortcut">Shortcut: E</p>');
	BindTooltipTo('#toggle-failed', '<p>Show/hide failed sections</p><p class="shortcut">Shortcut: R</p>');
	BindTooltipTo('#toggle-warning', '<p>Show/hide warnings sections</p><p class="shortcut">Shortcut: Y</p>');
	BindTooltipTo('#toggle-success', '<p>Show/hide success section</p><p class="shortcut">Shortcut: G</p>');
	BindTooltipTo('#latest-build', '<p>Navigate to the lastest build</p><p class="shortcut">Shortcut: L</p>');
	BindTooltipTo('#previous-build', '<p>Navigate to the previous build</p><p class="shortcut">Shortcut: Z</p>');
	BindTooltipTo('#next-build', '<p>Navigate to the next build</p><p class="shortcut">Shortcut: X</p>');
	BindTooltipTo('DIV.builds H2', '<p>Collapse/expand recent builds</p><p class="shortcut">Shortcut: B</p>');
	BindTooltipTo('li.route-dashboard A', '<p>Navigate to dashboard</p><p class="shortcut">Shortcut: D</p>');
	BindTooltipTo('SPAN.logout-button', '<p>Logout from administration dashboard</p>');
	BindTooltipTo('SPAN.reload-button', '<p>Reloads dashboard configuration</p>');
	BindTooltipTo('A.rss-button', '<p>RSS</p>');
	BindTooltipTo('A.refresh-button', '<p>Reloads projects</p>');
	
	$('#content DIV.section-content DIV.tooltip').hide();
	
	$('#content DIV.section-content .tooltip-owner').each(function (i) {
		BindFixedTooltipTo(this, $(this).find('DIV.tooltip').html());
	});
}

function BindTooltipTo(element, text) {
	$(element).tooltip({text:text, timein:1000, classname:'tooltip'});
}

function BindFixedTooltipTo(element, text) {
	$(element).tooltip({text:text, timein:1000, classname:'tooltip-fixed'});
}

/* Sliding
----------------------------------*/
function BindSliding() {
    BindSliders();
    BindViewButtons();
    BindSelectionBox();
    HideSuccessContent();
    HideNavigation();
    StopPropagationOnSliding();
}

function BindSliders() {
	EnableSliding('H1.title', 'DIV.section-content');
	EnableSliding('H2', 'UL');
}

function EnableSliding(link, content) {
	$(link).bind('click', function (e) {
		$(this).parent().find(content).slideToggle('fast');
	});
}

function BindViewButtons() {	
	$('#show-all').click(function () {
		$('DIV.section-content').slideDown('fast');
	});
	
	$('#hide-all').click(function () {
		$('DIV.section-content').slideUp('fast');
	});
	
	$('#show-errors').click(function () {
		$('DIV.success-light').slideUp('fast');
		$('DIV.warning-light').slideDown('fast');
		$('DIV.failed-light').slideDown('fast');
	});
	
	$('#toggle-failed').click(function () {		
		$('H1.failed').parent(':not(.hidden)').slideToggle('fast');
		$(this).toggleClass('failed-light');
	});
	
	$('#toggle-warning').click(function () {
		$('H1.warning').parent(':not(.hidden)').slideToggle('fast');
		$(this).toggleClass('warning-light');
	});
	
	$('#toggle-success').click(function () {
		$('H1.success').parent(':not(.hidden)').slideToggle('fast');
		$(this).toggleClass('success-light');
	});
}

function BindSelectionBox() {
    $('a.selection-link-show').click(function() {
        $('DIV.selection').slideDown();
    });
    $('a.selection-link-hide').click(function() {
        $('DIV.selection').slideUp();
    });
}

function HideSuccessContent() {
	$('DIV.success-light').hide();
	$('DIV.warning-light').show();
	$('DIV.failed-light').show();
}

function HideNavigation() {	
	$('DIV.build-navigation UL').hide();
	$('DIV.builds UL').hide();
	$('DIV.external-links UL').hide();
	$('DIV.servers UL').hide();
	$('DIV.help UL').hide();
}

function StopPropagationOnSliding() {
	$('h1.title a').click(function(event) {
		event.stopPropagation();
	});
}

/* Keyboard shortcuts
----------------------------------*/
function BindShortcuts() {
	AddShortcut('r', function () { $('#toggle-failed').click(); });
	AddShortcut('g', function () { $('#toggle-success').click(); });
	AddShortcut('y', function () { $('#toggle-warning').click(); });
	AddShortcut('q', function () { $('#show-all').click(); });
	AddShortcut('w', function () { $('#hide-all').click(); });
	AddShortcut('e', function () { $('#show-errors').click(); });
	AddShortcut('l', function () { NavigateTo('#latest-build'); });
	AddShortcut('z', function () { NavigateTo('#previous-build'); });
	AddShortcut('x', function () { NavigateTo('#next-build'); });
	AddShortcut('b', function () { $('DIV.builds H2').click(); });
	AddShortcut('d', function () { NavigateTo('LI.route-dashboard A'); });
	AddShortcut('h', function () { $('DIV.help H2').click(); });
	AddShortcut('f', function () { $('#searchbox').val('').focus(); });
	AddShortcut('1', function () { NumericNavigate(0) });
	AddShortcut('2', function () { NumericNavigate(1) });
	AddShortcut('3', function () { NumericNavigate(2) });
	AddShortcut('4', function () { NumericNavigate(3) });
	AddShortcut('5', function () { NumericNavigate(4) });
	AddShortcut('6', function () { NumericNavigate(5) });
	AddShortcut('7', function () { NumericNavigate(6) });
	AddShortcut('8', function () { NumericNavigate(7) });
	AddShortcut('9', function () { NumericNavigate(8) });
}

function AddShortcut(combination, callback) {
	shortcut.add(combination, callback, {'disable_in_input': true});
}

function NumericNavigate(number) {
	var links = ($('#content H1.title SPAN.title A').length > 0) 
		? $('#content DIV.section:visible H1.title SPAN.title A') 
		: $('#menu DIV.links LI A');
	
	var link = links.get(number);
	if (link) {
		var address = $(link).attr('href');
		if (address) {
			window.location.href = address;
		}
	}
}

/* Messaging
----------------------------------*/
function BindMessage() {
	$('DIV.message:visible').oneTime(5000, function() {
		$(this).click();
	});
	$('DIV.message').bind('click', function() {
		$(this).fadeOut('normal');
	});
}


/* Filtering
----------------------------------*/
function BindSearching() {
	$('#searchbox').keypress(function (e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		if(code == 13) { //Enter keycode
			SearchProjects();
		} else if(code == 27) { //Esc keycode
			ClearSearch();
		}
	});
}

function GroupProjectsByActivity() {
	var projects = $('.data-project');
	projects.remove();
	
	var activeProjects = new Array();
	var inactiveProjects = new Array();
	var stoppedProjects = new Array();
	var content = $('#content');
	
	projects.each(function() {
		if (IsStoppedProject(this)) {
			stoppedProjects.push(this);
		} else if (IsActiveProject(this)) {
			activeProjects.push(this);
		} else {
			inactiveProjects.push(this);
		}
	});
	
	AddProjectsToEnd(activeProjects, content);
	CreateSection('Inactive Projects', inactiveProjects, content)
	CreateSection('Stopped Projects', stoppedProjects, content)
}

function IsActiveProject(project) {
	var lastBuildDateText = $(project).find('.data-last-build-date').text();	
	var lastBuildDate = Date.parse(lastBuildDateText);
		
	return lastBuildDate > Date.today().add(-7).days();
}

function IsStoppedProject(project) {
	return $(project).find('.data-server-status').text() == 'Stopped';
}

function CreateSection(title, content, container) {
	if (content.length > 0) {
		container.append('<div class="section"><h1 class="title"><span class="title">' + title + '</span></h1></div>');
		AddProjectsToEnd(content, container);
	}
}

function AddProjectsToEnd(projects, container) {
	$(projects).each(function () {
		container.append($(this));
	});
}

function SearchProjects() {
	ResetFilterButtons();
	var projects = $('#content DIV.data-project');
	var searchNeedle = $('#searchbox').val();
	var pattern = new RegExp(searchNeedle, 'i');
	
	projects.hide();
	projects.each(function () {
		var name = $(this).find('.data-project-name').text();
		
		if (pattern.test(name)) {
			$(this).show().removeClass("hidden");
		} else {
			$(this).addClass("hidden");
		}
	});
	$('#searchbox').blur();
}

function ClearSearch() {
	$('#content DIV.data-project').show().removeClass("hidden");
	ResetFilterButtons();
	$('#searchbox').val('').blur();
}
function ResetFilterButtons() {
	$('#toggle-failed').removeClass('failed-light').addClass('failed');
	$('#toggle-warning').removeClass('warning-light').addClass('warning');
	$('#toggle-success').removeClass('success-light').addClass('success');
}

/* Dialogs
----------------------------------*/
function BindDialogs() {
	var HelpDialog = $('#help-shortcuts').dialog({
		autoOpen: false,
		modal: true,
		title: 'Help | Shortcuts',
		width: 600,
		resizable: false
	});
	
	$('#menu DIV.help LI A.link-help-shortcuts').bind('click', function() {
		HelpDialog.dialog('open');
	});
}