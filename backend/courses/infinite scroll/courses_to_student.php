<?php
// Database connection parameters
include "../connection.php";
include "../go.php";

$limit = (isset($_GET['limit']) && $_GET['limit'] != "") ? $_GET['limit'] : 10;
$offset = (isset($_GET['offset']) && $_GET['offset'] != "") ? $_GET['offset'] : 0;

$id = $_GET['id'];
$student_country = $_GET['country'];

$sql = "SELECT * from `students` NATURAL JOIN `studentinterest` NATURAL JOIN `interest` WHERE student_id = '$id'";
$interests = array();
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $interests[] = $row;
    }
}
$interests_str = implode("','", $interests);
//////////////////////////////////////////////////////////////////////////////////////////////////
$sql2 = "SELECT * from `interest` NATURAL JOIN `courses` NATURAL JOIN `companies` NATURAL JOIN `coursetype` WHERE company_country = '$student_country' ORDER BY FIELD(`interest`.`interest_name`, 'programming') DESC LIMIT $limit OFFSET $offset";
$db_data = array();

$result = $conn->query($sql2);
if ($result->num_rows > 0) {
    $state = $sucess;
    while ($row = $result->fetch_assoc()) {
        $db_data[] = $row;
    }
}

if (count($db_data) == 0) {
    $state = $empty;
}

// Send back the complete records as a json
$result_text = "courses";

$finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
// echo "123";
print_r($finalResult);

$conn->close();
