<?php
// Database connection parameters
include "../connection.php";
include "../go.php";

$limit = (isset($_GET['limit']) && $_GET['limit'] != "") ? $_GET['limit'] : 10;
$offset = (isset($_GET['offset']) && $_GET['offset'] != "") ? $_GET['offset'] : 0;
$id = $_GET['id'];

// Get all records from the database
$sql = "SELECT * from `post` NATURAL JOIN `companies` WHERE company_id = '$id' ORDER BY `post`.`post_time` DESC LIMIT $limit OFFSET $offset";
$db_data = array();
$imgs = array();

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $state = $sucess;
    while ($row = $result->fetch_assoc()) {
        $str = $row['post_id'];
        $imgs = array();
        $sqlImg = "SELECT post_img from `post` NATURAL JOIN `postimg` WHERE post_id = $str";
        $resultImg = $conn->query($sqlImg);
        if ($resultImg->num_rows > 0) {
            while ($row2 = $resultImg->fetch_assoc()) {
                $imgs[] = $row2;
            }
            $row["photos"] = $imgs;
        } else {
            $row["photos"] = [];
        }
        $db_data[] = $row;
    }
    // echo json_encode($db_data);
} else {
    $state = $empty;
}

// Send back the complete records as a json
$result_text = "posts";

$finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
// echo "123";
print_r($finalResult);

$conn->close();
