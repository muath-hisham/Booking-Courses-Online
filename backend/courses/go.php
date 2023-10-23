<?php
include 'connection.php';
// $json = file_get_contents('php://input');
// $data  = json_decode($json, true); // to change the data to jason

$state = 104;
$result = "";
$finalResult = '{"state":';
error_reporting(E_ERROR | E_PARSE);
// Codes 
// 101 >> sucess
// 102 >> empty
// 103 >> wrong mail
// 104 >> failed
// 105 >> used 

$sucess = 101;
$empty = 102;
$wrong_mail = 103;
$failed = 104;
$used_mail = 105;
$wrong_password = 106;
$rent_before = 107;
$empty_m = 108;
$result_text = "result";

// $BASE_URL = 'http://192.168.1.9/courses/images/';

// echo "i am out";
// print_r($data);

if (isset($_POST)) {
    // echo "i am in";
    // Takes raw data from the request
    $json = file_get_contents('php://input');

    // Converts it into a PHP object
    $data = json_decode($json, true);
    // echo "i am after decode";
    //add your check here that is $data["username"] as bellow
    if ($data["method"] == "login") {
        $typeOfUser = "";
        $email = $data['email'];
        $password = $data['password'];
        $type = $data['type'];
        $sql = "SELECT * FROM `admins` WHERE admin_email = '$email'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        if (empty($row)) {
            $sql = "SELECT * FROM `companies` WHERE company_email = '$email'";
            $result = $conn->query($sql);
            $row = $result->fetch_assoc();
            if (empty($row)) {
                $sql = "SELECT * FROM `students` WHERE student_email = '$email'";
                $result = $conn->query($sql);
                $row = $result->fetch_assoc();
                if (empty($row)) {
                    $state = $wrong_password;
                } else {
                    if (password_verify($password, $row['student_password'])) {
                        $typeOfUser = "student";
                        $state = $sucess;
                    } else {
                        $state = $wrong_password;
                    }
                }
            } else {
                if (password_verify($password, $row['company_password'])) {
                    $typeOfUser = "company";
                    $state = $sucess;
                } else {
                    $state = $wrong_password;
                }
            }
        } else {
            if (password_verify($password, $row['admin_password'])) {
                $typeOfUser = "admin";
                $state = $sucess;
            } else {
                $state = $wrong_password;
            }
        }

        $result_text = "user";

        $finalResult .= $state . ',"type_of_user":"' . $typeOfUser . '","' . $result_text . '":' . json_encode($row) . "}";
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "autoLogin") {
        $email = $data['email'];
        $password = $data['password'];
        $type = $data['user_type'];

        switch ($type) {
            case "admin":
                $sql = "SELECT * FROM `admin` WHERE admin_email = '$email'";
                $result = $conn->query($sql);
                $row = $result->fetch_assoc();
                break;

            case "company":
                $sql = "SELECT * FROM `companies` WHERE company_email = '$email'";
                $result = $conn->query($sql);
                $row = $result->fetch_assoc();
                break;

            case "student":
                $sql = "SELECT * FROM `students` WHERE student_email = '$email'";
                $result = $conn->query($sql);
                $row = $result->fetch_assoc();
                break;
        }

        if (empty($row)) {
            $state = $wrong_password;
        } else {
            if (password_verify($password, $row['student_password']) || password_verify($password, $row['company_password']) || password_verify($password, $row['admin_password'])) {
                $state = $sucess;
            } else {
                $state = $wrong_password;
            }
        }

        $result_text = "user";

        $finalResult .= $state . ',"' . $result_text . '":' . json_encode($row) . "}";
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "like_post") {
        $process = $data['process'];
        $student_id = $data['student_id'];
        $post_id = $data['post_id'];
        if ($process == 'add') {
            $sql = "INSERT INTO `postlikes` (post_id, student_id) VALUES ($post_id, $student_id)";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
        } else if ($process == 'remove') {
            $sql = "DELETE FROM `postlikes` WHERE post_id = $post_id and student_id = $student_id";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
        }

        $sql = "SELECT * FROM `post` WHERE post_id = '$post_id'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        if ($process == 'add') {
            $likes = $row['post_number_of_likes'] + 1;
        } else if ($process == 'remove') {
            $likes = $row['post_number_of_likes'] - 1;
        }
        $sql = "UPDATE `post` SET post_number_of_likes=$likes WHERE post_id=$post_id";
        if ($conn->query($sql) === TRUE) {
            $state2 = $sucess;
        } else {
            $state2 = $failed;
        }

        $finalResult .= $state . '"state2":' . $state2 . ',"process":"' . $process . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "follow_company") {
        $process = $data['process'];
        $student_id = $data['student_id'];
        $company_id = $data['company_id'];
        if ($process == 'follow') {
            $sql = "INSERT INTO `following` (student_id, company_id) VALUES ($student_id, $company_id)";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
        } else if ($process == 'unFollow') {
            $test = "delete";
            $sql = "DELETE FROM `following` WHERE company_id = $company_id and student_id = $student_id";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
            //      echo "Error: " . $sql . "<br>" . $conn->error;
        }

        $finalResult .= $state . ',"process":"' . $process . ',"test":"' . $test . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "is_fav_post") {
        $student_id = $data['student_id'];
        $post_id = $data['post_id'];
        $sql = "SELECT * FROM `postlikes` WHERE post_id = '$post_id' and student_id = $student_id";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        if (empty($row)) {
            $state = $sucess;
            $isFav = 0;
        } else {
            $state = $sucess;
            $isFav = 1;
        }

        $finalResult .= $state . ',"isFav":"' . $isFav . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "is_follow_company") {
        $student_id = $data['student_id'];
        $company_id = $data['company_id'];
        $sql = "SELECT * FROM `following` WHERE company_id = '$company_id' and student_id = $student_id";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        if (empty($row)) {
            $state = $sucess;
            $isFollow = 0;
        } else {
            $state = $sucess;
            $isFollow = 1;
        }

        $finalResult .= $state . ',"isFollow":"' . $isFollow . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "create_student_account") {
        $student_fname = $data['firstName'];
        $student_lname = $data['lastName'];
        $student_email = $data['email'];
        $student_password = $data['password'];
        $student_gender = $data['gender'];
        $student_city = $data['city'];
        $student_country = $data['country'];
        $student_dateOfBirth = $data['dateOfBirth'];
        $student_Phone = $data['Phone'];
        $student_img = $data['img'];

        $hashedPassword = password_hash($student_password, PASSWORD_DEFAULT);

        // to generate comblex id 
        $bytes = openssl_random_pseudo_bytes(10);
        $student_id = bin2hex($bytes);

        // to get the current time
        $date = new DateTime();

        $sql = "INSERT INTO `students` VALUES ('$student_id', '$student_fname', '$student_lname', '$student_dateOfBirth', '$student_country', '$student_city', '{$date->format('Y-m-d H:i:s')}', '$student_Phone', '$student_email', '$hashedPassword', '$student_img', '$student_gender')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $sql = "SELECT * FROM `students` WHERE student_id = '$student_id'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();

        $finalResult .= $state . ',"user":' . json_encode($row) . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "courses_to_company") {

        // Get all records from the database
        $id = $data["company_id"];
        $sql = "SELECT * from `companies` NATURAL JOIN `courses` NATURAL JOIN `coursetype` WHERE company_id = '$id'";
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
        $result_text = "courses";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "create_company_account") {
        $company_name = $data['name'];
        $company_des = $data['des'];
        $company_country = $data['country'];
        $company_email = $data['email'];
        $company_password = $data['password'];
        $company_phone1 = $data['phone1'];
        $company_phone2 = $data['phone2'];
        $company_img = $data['img'];
        $company_locations = $data['locations']; ////////////////////////////////////////////////////////////////
        $company_payment_methods = $data['payment_methods']; ///////////////////////////////////////////////////
        $company_website = $data['website'];

        $hashedPassword = password_hash($company_password, PASSWORD_DEFAULT);

        // to generate comblex id 
        $bytes = openssl_random_pseudo_bytes(10);
        $company_id = bin2hex($bytes);

        // to get the current time
        $date = new DateTime();

        $sql = "INSERT INTO `companies` VALUES ('$company_id', '$company_name', '$company_des', '$company_country', '$company_img', '$company_email', '$hashedPassword', '$company_website', '0', '{$date->format('Y-m-d H:i:s')}', '$company_phone1', '$company_phone2')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $sql = "SELECT * FROM `companies` WHERE company_id = '$company_id'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();

        $finalResult .= $state . ',"user":' . json_encode($row) . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "notifications_company") {

        // Get all records from the database
        $id = $data["company_id"];
        $sql = "SELECT * from `notificationscompany` NATURAL JOIN `companies` WHERE company_id = '$id' ORDER BY `notificationscompany`.`notification_time` DESC";
        $db_data = array();

        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $state = $sucess;
            while ($row = $result->fetch_assoc()) {
                $db_data[] = $row;
            }
        } else {
            $state = $empty;
        }

        // Send back the complete records as a json
        $result_text = "notifications";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "notifications_student") {

        // Get all records from the database
        $id = $data["student_id"];
        $sql = "SELECT * from `notificationsstudent` NATURAL JOIN `students` WHERE student_id = '$id' ORDER BY `notificationsstudent`.`notification_time` DESC";
        $db_data = array();

        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $state = $sucess;
            while ($row = $result->fetch_assoc()) {
                $db_data[] = $row;
            }
        } else {
            $state = $empty;
        }

        // Send back the complete records as a json
        $result_text = "notifications";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "create_post") {
        $company_id = $data['company_id'];
        $post_content = $data['post_content'];
        $imgs = $data['imgs'];

        // echo "1000000000000000000";

        // to get the current time
        $date = new DateTime();

        // to generate comblex id 
        // $bytes = openssl_random_pseudo_bytes(10);
        // $post_id = bin2hex($bytes);


        $sql = "INSERT INTO `post` (`post_id`, `post_time`, `company_id`, `post_content`, `post_number_of_likes`, `post_is_accepted`) VALUES (NULL, '{$date->format('Y-m-d H:i:s')}', '$company_id', '$post_content', '0', '0')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
            // echo "2000000000000000000";
        } else {
            $state = $failed;
            // echo "22222222222222222222";
        }

        if (!empty($imgs)) {
            $sql = "SELECT * from `post` WHERE post_time = '{$date->format('Y-m-d H:i:s')}' AND company_id = '$company_id'";
            $result = $conn->query($sql);
            if ($result->num_rows > 0) {
                // $state = $sucess;
                $row = $result->fetch_assoc();
                // echo "3000000000000000000";
                for ($i = 0; $i < sizeof($imgs); $i++) {
                    // to generate comblex id 
                    // $bytes = openssl_random_pseudo_bytes(10);
                    // $img_id = bin2hex($bytes);

                    $post_id = $row['post_id'];
                    $img_name = $imgs[$i];

                    $sql = "INSERT INTO `postimg` VALUES (NULL,'$post_id', '$img_name')";
                    if ($conn->query($sql) === TRUE) {
                        // echo "4000000000000000000";
                        $state2 = $sucess;
                    } else {
                        // echo "44444444444444444444";
                        $state2 = $failed;
                    }
                }
            }
        }

        $finalResult .= $state . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "get_books") {

        // Get all records from the database
        $id = $data["course_id"];
        $sql = "SELECT * from `courses` NATURAL JOIN `bookstocourse` WHERE course_id = '$id'";
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
        $result_text = "books";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "course_type_and_interest") {

        // Get all records from the database
        $sql = "SELECT * from `interest`";
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
        $result_text = "interest";

        // Get all records from the database
        $sql2 = "SELECT * from `coursetype`";
        $db_data2 = array();

        $result2 = $conn->query($sql2);
        if ($result2->num_rows > 0) {
            $state2 = $sucess;
            while ($row2 = $result2->fetch_assoc()) {
                $db_data2[] = $row2;
            }
            // echo json_encode($db_data);
        } else {
            $state2 = $empty;
        }

        // Send back the complete records as a json
        $result_text2 = "coursetype";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . ',"' . $result_text2 . '":' . json_encode($db_data2) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "add_new_course") {

        // Get all records from the database
        $company_id = $data["company_id"];
        $course_name = $data["course_name"];
        $course_description = $data["course_description"];
        $course_price_before_discount = $data["course_price_before_discount"];
        $course_price_after_discount = $data["course_price_after_discount"];
        $course_content = $data["course_content"];
        $course_type_id = $data["course_type_id"];
        $interest_id = $data["interest_id"];
        $files_path = $data["files"];
        $files_name = $data["files_name"];
        $number_of_pages = $data["number_of_pages"];

        // to generate comblex id 
        $bytes = openssl_random_pseudo_bytes(10);
        $course_id = bin2hex($bytes);


        $sql = "INSERT INTO `courses` VALUES ('$course_id', '$company_id', '$course_name', '$course_description', '$course_price_before_discount', '$course_price_after_discount', '$course_content', '0', '$course_type_id', '$interest_id')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        for ($i = 0; $i < sizeof($files_path); $i++) {
            $before = $number_of_pages[$i]['before'];
            $after = $number_of_pages[$i]['after'];
            $sql = "INSERT INTO `bookstocourse` VALUES (NULL, '$course_id', '$files_path[$i]', '$files_name[$i]', '$before', '$after')";
            if ($conn->query($sql) === TRUE) {
                $state2 = $sucess;
            } else {
                $state2 = $failed;
            }
        }

        $finalResult .= $state . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "get_companies") {

        // Get all records from the database
        $country = $data["country"];
        $sql = "SELECT * from `companies` WHERE company_country = '$country'";
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
        $result_text = "companies";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "update_student_account") {

        // Get all records from the database
        $id = $data["id"];
        $firstName = $data["firstName"];
        $lastName = $data["lastName"];
        $city = $data["city"];
        $country = $data["country"];
        $img = $data["img"];
        $sql = "UPDATE `students` SET student_first_name = '$firstName', student_last_name = '$lastName' , student_country = '$country', student_city = '$city', student_img = '$img' WHERE student_id = '$id'";

        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "update_company_account") {

        // Get all records from the database
        $id = $data["id"];
        $name = $data["name"];
        $des = $data["des"];
        $website = $data["website"];
        $phone1 = $data["phone1"];
        $phone2 = $data["phone2"];
        $img = $data["img"];
        $sql = "UPDATE `companies` SET company_name = '$name', company_description = '$des' , company_website = '$website', company_first_phone = '$phone1', company_second_phone = '$phone2', company_img = '$img' WHERE company_id = '$id'";

        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "own_student_courses") {

        // Get all records from the database
        $id = $data["student_id"];
        $sql = "SELECT * from `students` NATURAL JOIN `studentcourses` NATURAL JOIN `courses` NATURAL JOIN `coursetype` NATURAL JOIN `companies` WHERE student_id = '$id'";
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
        $result_text = "courses";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "student_interesting_from_all_interesting") {

        // Get all records from the database
        $id = $data["student_id"];
        $sql = "SELECT * from `interest`";
        $db_data = array();
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            $state = $sucess;
            while ($row = $result->fetch_assoc()) {
                $interest_id = $row['interest_id'];
                $sql2 = "SELECT * from `interest` NATURAL JOIN `studentinterest` WHERE student_id = '$id' AND interest_id = '$interest_id'";
                $result2 = $conn->query($sql2);
                if ($result2->num_rows > 0) {
                    $row['isInterest'] = 'true';
                } else {
                    $row['isInterest'] = 'false';
                }
                $db_data[] = $row;
            }
        } else {
            $state = $empty;
        }

        // Send back the complete records as a json
        $result_text = "interesting";

        $finalResult .= $state . ',' . '"' . $result_text . '":' . json_encode($db_data) . "}";
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "interest_progress") {
        $process = $data['process'];
        $student_id = $data['student_id'];
        $interest_id = $data['interest_id'];
        if ($process == 'addInt') {
            $test = "add";
            $sql = "INSERT INTO `studentinterest` (student_id, interest_id) VALUES ('$student_id', '$interest_id')";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
        } else if ($process == 'removeInt') {
            $test = "delete";
            $sql = "DELETE FROM `studentinterest` WHERE interest_id = '$interest_id' and student_id = '$student_id'";
            if ($conn->query($sql) === TRUE) {
                $state = $sucess;
            } else {
                $state = $failed;
            }
            //      echo "Error: " . $sql . "<br>" . $conn->error;
        }

        $finalResult .= $state . ',"process":"' . $process . ',"test":"' . $test . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "wasItBought") {

        // Get all records from the database
        $id = $data["student_id"];
        $course_id = $data['course_id'];
        $sql = "SELECT * from `studentcourses` WHERE student_id = '$id' AND course_id = '$course_id'";

        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $state = $sucess;
            $bought = 'true';
        } else {
            $state = $empty;
            $bought = 'false';
        }

        // Send back the complete records as a json
        $result_text = "wasItBought";

        $finalResult .= $state . ',' . '"' . $result_text . '":"' . $bought . '"}';
        // echo "123";
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "rate_company") {
        $student_id = $data['student_id'];
        $company_id = $data['company_id'];
        $rating = $data['rating'];
        $des_experience = $data['des_experience'];

        $sql = "INSERT INTO `rate` VALUES (NULL, '$student_id', '$company_id', '$rating', '$des_experience')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "reviews_to_student") {

        // Get all records from the database
        $company_id = $data["company_id"];
        $student_id = $data["student_id"];

        $sql = "SELECT * from `companies` NATURAL JOIN `rate` NATURAL JOIN `students` WHERE company_id = '$company_id'ORDER BY 
        CASE 
          WHEN student_id = '$student_id' THEN 0
          ELSE 1
        END,
        student_id";

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
    } else if ($data["method"] == "delete_rate") {
        $student_id = $data['student_id'];
        $company_id = $data['company_id'];

        $sql = "DELETE FROM `rate` WHERE company_id = $company_id and student_id = $student_id";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . '"}';
        // echo "123";
        print_r($finalResult);
        $conn->close();
    } else if ($data["method"] == "get_number_of_reviews") {

        // Get all records from the database
        $id = $data["company_id"];
        $sql = "SELECT * from `companies` NATURAL JOIN `rate` WHERE company_id = '$id'";
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
    } else if ($data["method"] == "book_course") {

        // Get all records from the database
        $course_id = $data["course_id"];
        $student_id = $data["student_id"];

        $sql = "INSERT INTO `studentcourses` VALUES (NULL, '$student_id', '$course_id')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . '}';
        print_r($finalResult);

        $conn->close();
    } else if ($data["method"] == "add_notification") {

        // Get all records from the database
        $notification_content = $data["notification_content"];
        $student_id = $data["student_id"];

        $currentDate = date('Y-m-d'); // Format: YYYY-MM-DD

        $sql = "INSERT INTO `notificationsstudent` VALUES (NULL, '$student_id', '$notification_content', '$currentDate')";
        if ($conn->query($sql) === TRUE) {
            $state = $sucess;
        } else {
            $state = $failed;
        }

        $finalResult .= $state . '}';
        print_r($finalResult);

        $conn->close();
    }
}
