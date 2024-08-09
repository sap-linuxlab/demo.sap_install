<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $a = escapeshellarg($_POST['a']);
    $b = escapeshellarg($_POST['b']);
    
    $output = shell_exec("./test.sh $a $b");
    
    echo "<h2>Result:</h2>";
    echo "<pre>$output</pre>";
} else {
    echo "Error: Invalid request method.";
}
?>
