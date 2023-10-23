<?php
$imageName = $_POST['image_name'];
$file_pointer = "profiles/$imageName"; 
   
// Use unlink() function to delete a file 
if (!unlink($file_pointer)) { 
    echo ("$file_pointer cannot be deleted due to an error"); 
} 
else { 
    echo ("$file_pointer has been deleted"); 
} 
?>
