var currentTab = 0; // Current tab is set to be the first tab (0)
showTab(currentTab); // Display the current tab

function showTab(n) {
  // This function will display the specified tab of the form...
  var x = document.getElementsByClassName("formtab");
  x[n].style.display = "block";
  //... and fix the Previous/Next buttons:
  if (n == 0) {
    document.getElementById("prevBtn").style.display = "none";
  } else {
    document.getElementById("prevBtn").style.display = "inline";
  }
  if (n == (x.length - 1)) {
    document.getElementById("nextBtn").innerHTML = "Submit";
  } else {
    document.getElementById("nextBtn").innerHTML = "Next";
  }
  //... and run a function that will display the correct step indicator:
  fixStepIndicator(n)
}

function nextPrev(n) {
  // This function will figure out which tab to display
  var x = document.getElementsByClassName("formtab");
  // Cleanup Error Message
  document.getElementById("error").innerHTML = "";
  // Exit the function if any field in the current tab is invalid:
  if (n == 1 && !validateForm()) return false;
  // Hide the current tab:
  x[currentTab].style.display = "none";
  // Increase or decrease the current tab by 1:
  currentTab = currentTab + n;
  // if you have reached the end of the form...
  if (currentTab >= x.length) {
    // ... the form gets submitted:
    document.getElementById("regForm").submit();
    return false;
  }
  // Otherwise, display the correct tab:
  showTab(currentTab);
}

function validateForm() {
  // This function deals with validation of the form fields
  var x, y, i, valid = true;
  x = document.getElementsByClassName("formtab");
  y = x[currentTab].getElementsByTagName("input");
  // A loop that checks every input field in the current tab:
  for (i = 0; i < y.length; i++) {
    // If a field is empty...
    document.getElementById("error").innerHTML += y[i].value + " ";
    if ( y[i].required && y[i].value == "" ) {
      // Print message that the fields are required
      // document.getElementById("error").innerHTML = "Fill in the required fields";
      // add an "invalid" class to the field:
      y[i].className += " invalid";
      // and set the current valid status to false
      valid = false;
    }
  }
  // If the valid status is true, mark the step as finished and valid:
  if (valid) {
    document.getElementsByClassName("step")[currentTab].className += " finish";
  }
  document.getElementById("cloudtype").innerHTML = "Enter Configuration Details for " + document.getElementById('type').value;
  // make cloud fields visible
  if ( document.getElementById('type').value == "azure") {
    document.getElementById('azure_cli_id').required = true;
    document.getElementById('azure_cli_id').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
    document.getElementById('azure_cli_secret').required = true;
    document.getElementById('azure_cli_secret').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
    document.getElementById('azure_tenant').required = true;
    document.getElementById('azure_tenant').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
    document.getElementById('azure_subscription').required = true;
    document.getElementById('azure_subscription').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
    document.getElementById('azure_location').required = true;
    document.getElementById('azure_location').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
    document.getElementById('azure_resource_group').className.replace( /(?:^|\s)hideme(?!\S)/ , '' );
  } else {
    document.getElementById('azure_cli_id').required = false;
    document.getElementById('azure_cli_id').className += " hideme";
    document.getElementById('azure_cli_secret').required = false;
    document.getElementById('azure_cli_secret').className += " hideme";
    document.getElementById('azure_tenant').required = false;
    document.getElementById('azure_tenant').className += " hideme";
    document.getElementById('azure_subscription').required = false;
    document.getElementById('azure_subscription').className += " hideme";
    document.getElementById('azure_location').required = false;
    document.getElementById('azure_location').className += " hideme";
    document.getElementById('azure_resource_group').className += " hideme";
  }
  // if private automation hub is enabled make other variables required
  if ( document.getElementById('controller_ah_enable').checked == true ) {
    document.getElementById('rhsm_ah_offline_token').required = true;
    document.getElementById('automation_hub_server_url').required = true;
  } else {
    document.getElementById('rhsm_ah_offline_token').required = false;
    document.getElementById('automation_hub_server_url').required = false;
  }
  return valid; // return the valid status
}

function fixStepIndicator(n) {
  // This function removes the "active" class of all steps...
  var i, x = document.getElementsByClassName("step");
  for (i = 0; i < x.length; i++) {
    x[i].className = x[i].className.replace(" active", "");
  }
  //... and adds the "active" class on the current step:
  x[n].className += " active";
}

