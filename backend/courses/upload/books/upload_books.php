<?php
$target_dir = "before/";
$target_file = $target_dir . basename($_FILES["pdf"]["name"]);

if (move_uploaded_file($_FILES["pdf"]["tmp_name"], $target_file)) {
    echo "The file ". htmlspecialchars( basename( $_FILES["pdf"]["name"])). " has been uploaded.";
} else {
    echo "Sorry, there was an error uploading your file.";
}
?>
