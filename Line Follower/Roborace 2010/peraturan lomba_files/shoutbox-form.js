// $Id: shoutbox-form.js,v 1.11.2.15 2010/09/08 20:48:11 mikestefff Exp $

Drupal.shoutbox = {}
Drupal.behaviors.shoutbox = function(context) {
  // Add AJAX behavior to the form
  var options = {
	  resetForm: true,
	  beforeSubmit: Drupal.shoutbox.validate,
	  success: Drupal.shoutbox.success
  };
  $("#shoutbox-add-form").ajaxForm(options);

  // Tell the form that we have Javascript enabled
  $('#shoutbox-add-form #edit-js').val(1);
  
  // Empty the shout textfield
  $('#shoutbox-add-form #edit-message').val('');
  
  // Close errors if they're clicked
  $('#shoutbox-error').click(function() {
    $(this).hide(); 
  });

  // Show the admin links on hover
  Drupal.shoutbox.adminHover();
  
  // Initialize the timer for shout updates
  Drupal.shoutbox.shoutTimer('start');
}

/**
 * Attach a hover event to the shoutbox admin links
 */
Drupal.shoutbox.adminHover = function() {
  // Remove binded events
  $('#shoutbox-body .shoutbox-msg').unbind();
  
  // Bind hover event on admin links
  $('#shoutbox-body .shoutbox-msg').hover(
    function() {
      $(this).find('.shoutbox-admin-links').show();
    },
    function() {
      $(this).find('.shoutbox-admin-links').hide();
    }
  );
}

/**
 * Fix the destination query on shout admin link URLs
 * 
 * This is required because on an AJAX reload of shouts, the
 * ?destination= query on shout admin links points to the JS
 * callback URL
 */
Drupal.shoutbox.adminFixDestination = function() {
  var href = '';
  $('.shoutbox-admin-links').find('a').each(function() {
    // Extract the current href
    href= $(this).attr('href');
    // Remove the query
    href = href.substr(0, href.indexOf('?'));
    // Add the new destination
    href = href + '?destination=' + Drupal.settings.shoutbox.currentPath;
    // Set the new href
    $(this).attr('href', href);
  });
}

/**
 * Callback for a successful shout submission
 */
Drupal.shoutbox.success = function(responseText) {
  // Load the latest shouts
  Drupal.shoutbox.loadShouts(true);
}

/**
 * Starts or stops a timer that triggers every delay seconds.
 */
Drupal.shoutbox.shoutTimer = function(op) {
  var delay = Drupal.settings.shoutbox.refreshDelay;
  if (delay > 0) {
    switch (op) {
      case 'start':
        Drupal.shoutbox.interval = setInterval("Drupal.shoutbox.loadShouts()", delay);
        break;
      
      case 'stop':
        clearInterval(Drupal.shoutbox.interval);
        break;
    }
	}	
}

/**
 * Reloads all shouts from the server.
 */
Drupal.shoutbox.loadShouts = function(restoreForm) {
  // Stop the timer
  Drupal.shoutbox.shoutTimer('stop');
  
	$.ajax({
    url: Drupal.settings.shoutbox.refreshPath,
    type: "GET",
    cache: "false",
    dataType: "html",
    data: {shouts: Drupal.settings.shoutbox.showAmount},
    success: function(data) {
      // Update the shouts
      $("#shoutbox-body").html(data);
      
      // Rebind the hover for admin links
      Drupal.shoutbox.adminHover();
      
      // Fix the destination URL queries on admin links
      Drupal.shoutbox.adminFixDestination();
      
      // Resume the timer
      Drupal.shoutbox.shoutTimer('start');
      
      // Hide any errors
      $('#shoutbox-error').hide();
      
      // Restore the button
      if (restoreForm) {
        $('#shoutbox-add-form input#edit-submit').show();
        $('#shoutbox-throbber').hide();
      }
    },
    error: function() {
      $('#shoutbox-error').html(Drupal.t('Error updating shouts. Please refresh the page.'));
      $('#shoutbox-error').show();
    }
  });
}

/**
 * Validate input before submitting.
 * Don't accept default values or empty strings.
 */
Drupal.shoutbox.validate = function (formData, jqForm, options) {
  var errorMsg = '';
  var errorDiv = $('#shoutbox-error');
  var form = jqForm[0];

  // Check if a message is present
  if ((!form.message.value)) {
	  errorMsg = Drupal.t('Enter a message');
  }
  
  // If a maxlength is set, enforce it
  if ((Drupal.settings.shoutbox.maxLength > 0) && (form.message.value.length > Drupal.settings.shoutbox.maxLength)) {
	  errorMsg = Drupal.t('The shout you entered is too long');
  }    
  
  if (errorMsg) {
    // Show the message and stop heres
    errorDiv.html(errorMsg);
    errorDiv.show();
    return false;
  }
  else {
    // No errors registered, continue
    errorDiv.hide();
    errorDiv.html('');
  }
  
  // Clear the form input 
  $('#shoutbox-add-form').resetForm();
  $('#shoutbox-throbber').show();
  $('#shoutbox-add-form input#edit-submit').hide();
  return true;	
}
