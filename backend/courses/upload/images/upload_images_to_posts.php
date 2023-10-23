
<?php
    // Define the target directory to store uploaded files
    $target_dir = "posts/";

    // Define the target file to be saved
    // basename($_FILES["file"]["name"]) gets original name of the file from client
    // You can customize this to use a different name
    $target_file = $target_dir . basename($_FILES["file"]["name"]);

    // Move the uploaded file to your target directory
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
        echo "The file ". basename( $_FILES["file"]["name"]). " has been uploaded.";
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
?>
