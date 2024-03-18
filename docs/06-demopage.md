---
layout: default
title: AAP Template Config
nav_order: 5
has_children: false
---

# AAP Demo setup


<form id="regForm" action="/action_page.php" autocomplete="on">
  <h1>AAP Cloud Deployment:</h1>
  <!-- One "tab" for each step in the form: -->
  <!-- TAB 1 -->
  <div class="tab">
    <h3>Name:</h3>
    <p><input type="text"  placeholder="Nickname..." oninput="this.className = ''" name="nickname" required> </p>
    <p><input type="email" placeholder="Email..." oninput="this.className = ''" name="email" required></p>
    <h3>Cloud Provider:</h3>
    <p><select name="type" id="type" oninput="this.className = ''" >
      <option value="azure">Microsoft Azure</option>
      <option value="aws">Amazon WebService</option>
      <option value="gcs">Google Cloud Service</option> 
    </select></p>
  </div>
  <!-- TAB 2 -->
  <div class="tab">
    <h3 id="cloudtype" >Enter Cloud Configuration:</h3>
    <p><input type="text"  placeholder="Azure Client Id" oninput="this.className=''" name="azure_cli_id" id="azure_cli_id"></p>
    <p><input type="text"  placeholder="Azure Password" oninput="this.className=''" name="azure_cli_secret" id="azure_cli_secret"></p>
    <p><input type="text"  placeholder="Azure Tenant" oninput="this.className=''" name="azure_tenant" id="azure_tenant"></p>
    <p><input type="text"  placeholder="Azure Subscription Id" oninput="this.className=''" name="azure_subscription" id="azure_subscription"></p>
    <p><input type="text"  placeholder="Azure Location" oninput="this.className=''" name="azure_location" id="azure_location" value=westeurope></p>
    <p><input type="text"  placeholder="Azure Resource Group" oninput="this.className=''" name="azure_resource_group" id="azure_resource_group"></p>
    <p><input type="text"  placeholder="Instance Flavour" oninput="this.className=''" name="instance_flavor" id="instance_flavor" value="Standard_D4s_v3" required></p>
  </div>
  <!-- TAB 3 -->
  <div class="tab">Enter Controller Configuration:
      <p><input type="password"  placeholder="Controller Admin Password" oninput="this.className=''" name="controller_admin_password" id="controller_admin_password" required></p>
      <p>RH AAP Manifest File<input type="file" name="rhaap_manifest" id="rhaap_manifest" required></p>
      <p><input type="checkbox" name="controller_ah_enable" id="controller_ah_enable" oninput="this.className=''" value=true>
        <label for="controller_ah_enable">Enable Private Automation Hub</label></p>
      <p><input type="checkbox" name="controller_eda_enable" id="controller_eda_enable" oninput="this.className=''" value=true>
        <label for="controller_eda_enable">Enable Event Driven Ansible</label></p>
  </div>
  <!-- TAB 4 -->
  <div class="tab">Enter Private Automation Hub Configuration:
    <!-- Auto Generated
    <p><input type="text"  placeholder="XXX..." oninput="this.className=''" name="controller_ah_instance_name" id="controller_ah_instance_name"></p>
    -->
    <p><input type="text"  placeholder="AH Content Download URL" oninput="this.className=''" 
        name="automation_hub_server_url" id="automation_hub_server_url"
        value="https://console.redhat.com/api/automation-hub/content/published/"></p>
    <!-- Static Values
    <p><input type="text"  placeholder="quay username" oninput="this.className=''" name="quay_registry_username" id="quay_registry_username"></p>
    <p><input type="text"  placeholder="quay password" oninput="this.className=''" name="quay_registry_password" id="quay_registry_password"></p>
    -->
    <p><input type="text"  placeholder="RHSM Automation Hub Access Token" oninput="this.className=''" name="rhsm_ah_offline_token" id="rhsm_ah_offline_token"></p>
  </div>
  <!-- TAB 5 -->
  <div class="tab">Enter Red Hat Subscription Credentials:
    <p><input type="text"  placeholder="RHSM Username" oninput="this.className=''" name="rhsm_username" id="rhsm_username" required></p>
    <p><input type="text"  placeholder="RHSM Password" oninput="this.className=''" name="rhsm_password" id="rhsm_password" required></p>
    <p><input type="text"  placeholder="RHSM PoolId" oninput="this.className=''" name="rhsm_poolid" id="rhsm_poolid" required></p>  
  </div>
  <!-- TAB 6 -->
  <div class="tab">SSH Keypair Configuration
    <p><label for="controller_ansible_private_key">SSH Private Key</label> 
       <input type="file"  oninput="this.className=''" name="controller_ansible_private_key" id="controller_ansible_private_key" required></p>    
    <p><label for="controller_ansible_public_key">SSH Public Key</label>
       <input type="file"  oninput="this.className=''" name="controlle_ansible_public_key" id="controller_ansible_public_key" required></p>

  </div>
  <!-- TAB 7 -->
  <div class="tab">Let's encrypt:
    <p><input type="checkbox" name="letsencrypt_skip" id="letsencrypt_skip" value="true" checked>
       <label for="letsencrypt_skip">Disable Let's Encrypt Certificates</label></p>

  </div>
  <!-- TAB 8 -->
  <div class="tab">Ansible SSA DynDns Config
    <p><input type="checkbox"  name="dns_update" id="dns_update" value="true">
      <label for="dns_update">Enable DynDns (only for Red Hat Employees)</label></p>
    <p><input type="text"  placeholder="DNS Subdomain Suffix" oninput="this.className=''" name="dns_suffix" id="dns_suffix"></p>
    <p><input type="file"  placeholder="DNS Key" oninput="this.className=''" name="dns_key" id="dns_key"></p>
    <p><input type="file"  placeholder="DNS Private Key" oninput="this.className=''" name="dns_private" id="dns_private"></p>
  </div>
  <!-- Buttons -->
  <div style="overflow:auto;">
    <div style="float:right;">
      <button type="button" id="prevBtn" onclick="nextPrev(-1)">Previous</button>
      <button type="button" id="nextBtn" onclick="nextPrev(1)">Next</button>
    </div>
  </div>
  <!-- Circles which indicates the steps of the form - add accordingly: -->
  <div style="text-align:center;margin-top:40px;">
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
    <span class="step"></span>
  </div>
  <p id="error"></p>
</form>


<script>
var currentTab = 0; // Current tab is set to be the first tab (0)
showTab(currentTab); // Display the current tab

function showTab(n) {
  // This function will display the specified tab of the form...
  var x = document.getElementsByClassName("tab");
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
  var x = document.getElementsByClassName("tab");
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
  x = document.getElementsByClassName("tab");
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
</script>
