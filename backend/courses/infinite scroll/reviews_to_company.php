<?php
// Database connection parameters
include "../connection.php";
include "../go.php";

$limit = (isset($_GET['limit']) && $_GET['limit'] != "") ? $_GET['limit'] : 10;
$offset = (isset($_GET['offset']) && $_GET['offset'] != "") ? $_GET['offset'] : 0;
$id = $_GET['id'];

// Get all records from the database
$sql = "SELECT * from `students` NATURAL JOIN `rate` NATURAL JOIN `companies` WHERE company_id = '$id' LIMIT $limit OFFSET $offset";
$db_data = array();

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $state = $sucess;
    while ($row = $result->fetch_assoc()) {
        $db_data[] = $row;
    }
    // echo json_encode($db_data);
} else {
    $state = $empty;
}

// Send back the complete records as a json
$result_text = "reviews";

$finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
// echo "123";
print_r($finalResult);

$conn->close();
