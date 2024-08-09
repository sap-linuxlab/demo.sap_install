<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nickname = escapeshellarg($_POST['nickname']);
    $email = escapeshellarg($_POST['email']);
    $email_hash = hash('sha256', $email);
    mkdir("/tmp/$email_hash",0710);
    $parameterfile = fopen("/tmp/$email_hash/parameter.yml","w");
    fwrite($parameterfile,"---\n");
    fwrite($parameterfile,"hash: $email_hash\n");
    $type = escapeshellarg($_POST['type']);
    fwrite($parameterfile,"type: $type\n");
    if ($type == "'azure'") {
      $azure_cli_id = escapeshellarg($_POST['azure_cli_id']);
      $azure_cli_secret = escapeshellarg($_POST['azure_cli_secret']);
      $azure_tenant = escapeshellarg($_POST['azure_tenant']);
      $azure_subscription = escapeshellarg($_POST['azure_subscription']);
      putenv("AZURE_SECRET=$azure_cli_secret");
      putenv("AZURE_CLIENT_ID=$azure_cli_id");
      putenv("AZURE_SUBSCRIPTION_ID=$azure_subscription");
      putenv("AZURE_TENANT=$azure_tenant");
      $azure_location = escapeshellarg($_POST['azure_location']);
      if ($azure_location == 'other') {
        $azure_location = escapeshellarg($_POST['azure_other_location']);
      }
      fwrite($parameterfile,"azure_location: $azure_location\n");
      $azure_resource_group = escapeshellarg($_POST['azure_resource_group']);
      if ($azure_resource_group != '') {
        fwrite($parameterfile,"azure_resource_group: $azure_resource_group\n");
      }
    }
    $instance_flavor = escapeshellarg($_POST['instance_flavor']);
    fwrite($parameterfile,"instance_flavor: $instance_flavor\n");
    $controller_admin_password = escapeshellarg($_POST['controller_admin_password']);
    fwrite($parameterfile,"controller_admin_password: $controller_admin_password\n");
    # $rhaap_manifest = escapeshellarg($_POST['rhaap_manifest']);
    # $controller_ah_enable = escapeshellarg($_POST['controller_ah_enable']);
    # $controller_eda_enable = escapeshellarg($_POST['controller_eda_enable']);
    # $automation_hub_server_url = escapeshellarg($_POST['automation_hub_server_url']);
    # $quay_registry_username = escapeshellarg($_POST['quay_registry_username']);
    # $quay_registry_password = escapeshellarg($_POST['quay_registry_password']);
    # $rhsm_ah_offline_token = escapeshellarg($_POST['rhsm_ah_offline_token']);
    # $rhsm_username = escapeshellarg($_POST['rhsm_username']);
    # $rhsm_password = escapeshellarg($_POST['rhsm_password']);
    # $rhsm_poolid = escapeshellarg($_POST['rhsm_poolid']);
    # $controller_ansible_private_key = escapeshellarg($_POST['controller_ansible_private_key']);
    # fwrite($parameterfile,"private_key: $controller_ansible_private_key\n");
    # $controlle_ansible_public_key = escapeshellarg($_POST['controlle_ansible_public_key']);
    # fwrite($parameterfile,"public_key: $controlle_ansible_public_key\n");
    # $letsencrypt_skip = escapeshellarg($_POST['letsencrypt_skip']);
    # fwrite($parameterfile,"letsencrypt_skip: $letsencrypt_skip\n");
    # $dns_update = escapeshellarg($_POST['dns_update']);
    # $dns_suffix = escapeshellarg($_POST['dns_suffix']);
    # $dns_key = escapeshellarg($_POST['dns_key']);
    # $dns_private = escapeshellarg($_POST['dns_private']);
    fclose($parameterfile);    
    echo "<h2>Deployment started on $type</h2>"; 
    echo "Parameterfile: $email_hash.yml";
    echo "<h3>verifying inputs</h3>";
    $output = shell_exec("env; /usr/local/bin/ansible --version");
    echo "<pre>$output</pre>";
    echo "<h3> Creating infrastructure </h3>";
    # $:output = shell_exec("./01-create-infra.sh");
    # echo "<pre>$output</pre>";
    echo "<h3>Installing Controller</h3>";
    # $output = shell_exec("./02-install-controller.sh");
    # echo "<pre>$output</pre>";
    echo "<h3> Pre-Loading Controller </h3>";
    # $output = shell_exec("./03-load-controller.sh");
    # echo "<pre>$output</pre>";
    echo "<h2> Deployment finished </h2>";
    # $output = shell_exec("./03-load-controller.sh");
} else {
    echo "Error: Invalid request method.";
}
?>
