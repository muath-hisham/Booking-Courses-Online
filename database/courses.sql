-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 26, 2023 at 04:32 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `courses`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int(11) NOT NULL,
  `admin_email` text NOT NULL,
  `admin_password` text NOT NULL,
  `admin_IPAddress` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookstocourse`
--

CREATE TABLE `bookstocourse` (
  `book_to_course_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `book_to_course_path` text NOT NULL,
  `book_to_course_name` text NOT NULL,
  `book_to_course_number_of_pages_before_summ` int(11) NOT NULL,
  `book_to_course_number_of_pages_after_summ` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookstocourse`
--

INSERT INTO `bookstocourse` (`book_to_course_id`, `course_id`, `book_to_course_path`, `book_to_course_name`, `book_to_course_number_of_pages_before_summ`, `book_to_course_number_of_pages_after_summ`) VALUES
(1, 1, 'Chapter 2-Data Representation.pdf', 'web dev', 50, 30),
(44, 2, 'file_2023051923251310-1108_ARJ-12-2021-0359.pdf', '10-1108_ARJ-12-2021-0359.pdf', 20, 17),
(59, 3, 'file_20230604131532course booking1.pdf', 'course booking1.pdf', 31, 12);

-- --------------------------------------------------------

--
-- Table structure for table `commentreport`
--

CREATE TABLE `commentreport` (
  `comment_report_id` int(11) NOT NULL,
  `comment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `company_id` int(11) NOT NULL,
  `company_name` text NOT NULL,
  `company_description` text NOT NULL,
  `company_country` text NOT NULL,
  `company_img` text NOT NULL,
  `company_email` text NOT NULL,
  `company_password` text NOT NULL,
  `company_website` text NOT NULL,
  `company_is_aproved` tinyint(1) NOT NULL,
  `company_time_to_create_account` datetime NOT NULL,
  `company_first_phone` text NOT NULL,
  `company_second_phone` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`company_id`, `company_name`, `company_description`, `company_country`, `company_img`, `company_email`, `company_password`, `company_website`, `company_is_aproved`, `company_time_to_create_account`, `company_first_phone`, `company_second_phone`) VALUES
(1, 'AMIT', 'AMIT, Association Of Management and Information Technology, is a rapidly growing company which was established in Egypt from 2011 specialized in embedded systems, software computer science and IT. AMIT is an integration of a group of experienced staff, which provides the work in its ideal shape and meets the highest customer satisfaction', 'Egypt', 'd2hy5z9-61fd4902-d5df-4637-8123-e778d360fc9d.jpg', 'amit.123@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', 'https://amit-learning.com/home', 1, '2023-03-10 00:00:00', '011055959', '01012145264'),
(1092, 'Amplify', 'jg', 'Egypt', 'image_202306041303114198.jpg', 'hhh@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', '', 0, '2023-05-13 15:05:09', '01058964712', ''),
(5909000, 'Great Minds\n', 'gff', 'Egypt', 'download.jpg', 'hh@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', '', 0, '2023-05-13 14:59:49', '01254785410', ''),
(5909003, 'Skillsoft', 'Skillsoft', 'Egypt', 'OIP.jpg', 'om@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', '', 1, '2023-05-30 01:11:56', '01258964120', '');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `course_name` text NOT NULL,
  `course_description` text NOT NULL,
  `course_price_before_discount` int(11) NOT NULL,
  `course_price_after_discount` int(11) NOT NULL,
  `course_content` text NOT NULL,
  `course_is_aproved` tinyint(1) NOT NULL,
  `course_type_id` int(11) NOT NULL,
  `interest_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `company_id`, `course_name`, `course_description`, `course_price_before_discount`, `course_price_after_discount`, `course_content`, `course_is_aproved`, `course_type_id`, `interest_id`) VALUES
(1, 1, 'Web', 'This course introduces students to the fundamentals of web programming, including HTML, CSS, and JavaScript. Students will learn how to create dynamic, interactive web pages using these technologies, as well as how to design and implement responsive layouts that adapt to different device sizes.', 3999, 2999, 'HTML: document structure, semantics, and basic markup\nCSS: styling, layout, and responsive design\nJavaScript: programming fundamentals, DOM manipulation, and event handling\njQuery: selecting and manipulating DOM elements, creating animations and effects\nBootstrap: using the popular CSS framework to create responsive layouts\nNode.js: server-side JavaScript, building web applications with Express\nMongoDB: NoSQL databases, using Mongoose to interact with data', 1, 1, 1),
(2, 1092, 'English Language and Composition', 'This course is designed to help students improve their reading, writing, and critical thinking skills in English. Students will learn how to analyze literary texts, write effective essays, and develop their ability to communicate clearly and persuasively in both academic and professional settings.', 1500, 1100, 'Reading comprehension: strategies for understanding and analyzing literary texts, including fiction, non-fiction, and poetry\r\nWriting skills: developing effective writing techniques, including drafting, revising, and editing essays, research papers, and other written assignments\r\nCritical thinking: developing critical thinking skills through analysis and evaluation of literary texts, as well as research and argumentation\r\nGrammar and syntax: understanding and using correct grammar, syntax, and punctuation in writing\r\nCommunication skills: developing effective communication skills through public speaking, group discussions, and other forms of oral communication', 1, 2, 2),
(3, 1, 'flutter', 'This course is an introduction to developing mobile applications using Flutter, a popular open-source framework for creating high-performance, cross-platform apps. Students will learn the basics of Flutter development, including how to design user interfaces, handle user input, and interact with data sources.', 3400, 2500, 'Flutter basics: widgets, layouts, and themes\nUI design: creating custom widgets, using animations and effects\nUser input: handling user interactions, forms, and validation\nNavigation: using routes to navigate between screens\nData persistence: working with local databases and web APIs\nState management: managing app state using Flutter\'s built-in tools\nTesting and debugging: using Flutter\'s testing and debugging tools to identify and fix issues', 1, 2, 1),
(21, 1, 'Java programming', 'This course provides an introduction to programming using Java, one of the most popular programming languages in use today. Students will learn the fundamentals of programming, including variables, data types, control structures, and functions, and how to apply these concepts to solve real-world problems.', 1200, 1000, 'Java basics: syntax, data types, operators, and control structures\r\nObject-oriented programming: classes, objects, inheritance, and polymorphism\r\nGUI development: using JavaFX to create graphical user interfaces\r\nException handling: handling errors and exceptions in Java programs\r\nData structures: arrays, lists, stacks, and queues\r\nFile I/O: reading and writing files using Java\r\nNetworking: using Java to create networked applications', 1, 2, 1),
(22, 5909000, 'Advanced Mathematics', 'This course is designed for students who have a strong foundation in mathematics and are interested in exploring more advanced topics. The course covers a range of mathematical concepts and techniques, including calculus, linear algebra, differential equations, and abstract algebra.', 1400, 1199, 'Calculus: multivariable calculus, vector calculus, and differential equations\r\nLinear algebra: matrix algebra, linear transformations, and eigenvalues and eigenvectors\r\nAbstract algebra: groups, rings, and fields\r\nAnalysis: real analysis, complex analysis, and functional analysis\r\nTopology: point-set topology, algebraic topology, and differential topology', 1, 1, 7),
(23, 5909003, 'Digital Marketing', 'This course provides an introduction to the principles and practices of digital marketing, with a focus on using digital channels to reach and engage with target audiences. Students will learn how to develop and implement effective digital marketing strategies, using a range of tools and techniques to measure and optimize campaign performance.', 2400, 1999, 'Digital marketing basics: key concepts, trends, and tools\r\nSearch engine optimization (SEO): optimizing website content to improve search rankings\r\nPay-per-click advertising (PPC): creating and managing ads on search engines and social media platforms\r\nSocial media marketing: creating and managing social media campaigns, building and engaging with audiences\r\nEmail marketing: creating and sending effective email campaigns, building and managing email lists\r\nAnalytics and optimization: using data to measure and optimize campaign performance, including A/B testing and conversion rate optimization', 0, 2, 6),
(24, 1092, 'Elementary Spanish', 'This course is designed for students with little or no previous experience with Spanish, and provides an introduction to the language and culture of Spanish-speaking countries. Students will learn basic vocabulary, grammar, and conversational skills, and develop an understanding of the cultural context in which the language is used.', 1600, 1400, 'Greetings and introductions: basic phrases for meeting and getting to know people\r\nPronunciation and phonetics: understanding the sounds of the Spanish language\r\nGrammar: basic sentence structure, verb conjugation, and noun-adjective agreement\r\nVocabulary: common words and phrases related to everyday life, such as family, food, and travel\r\nCulture: an introduction to the history, customs, and traditions of Spanish-speaking countries', 1, 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `coursetype`
--

CREATE TABLE `coursetype` (
  `course_type_id` int(11) NOT NULL,
  `course_type` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coursetype`
--

INSERT INTO `coursetype` (`course_type_id`, `course_type`) VALUES
(1, 'online'),
(2, 'physical'),
(3, 'book');

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `discount_id` int(11) NOT NULL,
  `discount_code` text NOT NULL,
  `discount_dead_line` datetime NOT NULL,
  `discount_percent` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `following`
--

CREATE TABLE `following` (
  `follow_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `following`
--

INSERT INTO `following` (`follow_id`, `student_id`, `company_id`) VALUES
(13, 1, 1092),
(14, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `helpcompany`
--

CREATE TABLE `helpcompany` (
  `help_company_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `help_company_content` text NOT NULL,
  `help_company_img` text NOT NULL,
  `help_company_time` datetime NOT NULL,
  `help_company_is_closed` tinyint(1) NOT NULL,
  `help_company_reply` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `helpstudent`
--

CREATE TABLE `helpstudent` (
  `help_student_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `help_student_content` text NOT NULL,
  `help_student_img` text NOT NULL,
  `help_student_time` text NOT NULL,
  `help_student_is_closed` tinyint(1) NOT NULL,
  `help_student_reply` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interest`
--

CREATE TABLE `interest` (
  `interest_id` int(11) NOT NULL,
  `interest_name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `interest`
--

INSERT INTO `interest` (`interest_id`, `interest_name`) VALUES
(1, 'programming'),
(2, 'languages'),
(3, 'school'),
(4, 'cyber security'),
(5, 'Network'),
(6, 'Business'),
(7, 'Math and Logic');

-- --------------------------------------------------------

--
-- Table structure for table `locationcompany`
--

CREATE TABLE `locationcompany` (
  `location_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `location_name` text NOT NULL,
  `GPS` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notificationscompany`
--

CREATE TABLE `notificationscompany` (
  `notification_company_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `notification_content` text NOT NULL,
  `notification_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notificationscompany`
--

INSERT INTO `notificationscompany` (`notification_company_id`, `company_id`, `notification_content`, `notification_time`) VALUES
(1, 1, 'Purchase completed successfully', '2023-05-13 22:29:21');

-- --------------------------------------------------------

--
-- Table structure for table `notificationsstudent`
--

CREATE TABLE `notificationsstudent` (
  `notification_student_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `notification_content` text NOT NULL,
  `notification_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notificationsstudent`
--

INSERT INTO `notificationsstudent` (`notification_student_id`, `student_id`, `notification_content`, `notification_time`) VALUES
(1, 1, 'Purchase completed successfully', '2023-03-10 20:32:24'),
(2, 1, 'Purchase completed successfully', '2023-05-31 20:33:04'),
(3, 1, 'Purchase completed successfully', '2023-07-11 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `post_id` int(11) NOT NULL,
  `post_time` datetime NOT NULL,
  `company_id` int(11) NOT NULL,
  `post_content` text NOT NULL,
  `post_number_of_likes` int(11) NOT NULL,
  `post_is_accepted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`post_id`, `post_time`, `company_id`, `post_content`, `post_number_of_likes`, `post_is_accepted`) VALUES
(8, '2023-05-14 21:54:50', 1, 'most Popular content ', 0, 0),
(9, '2023-05-14 21:55:19', 1, 'عيد اضحى مبارك', 0, 0),
(11, '2023-05-14 22:09:41', 1, 'upload new courses', 0, 0),
(13, '2023-05-14 22:17:12', 1, '', 1, 0),
(14, '2023-05-16 10:35:42', 1, 'اشترك في كورس الـ ++C بالتعاون مع Udemy وتقدر تبدأ فى اى وقت لأن الكورس هيفضل مكمل معاك على طول من بعد الإشتراك.\nدلوقتى ولفترة محدودة بـ 270 جنيه بس 😍\nالحق العرض واشترك دلوقتى', 1, 0),
(15, '2023-05-16 11:02:57', 1092, 'هااااااااااام لطلاب  شهادة الثانوى العامة  👱👩\r\n>> عايز تدخل كلية فنون جميلة او تطبيقية او تربية فنية ونوعية _ او هندسه وخايف التنسيق ميظبطش معاك ..فقلت تلحق فنون تطبيقيه او فنون جميله 😁😁 فنون /عمارة  & فنون تطبيقية قسم ديكور  بتبقى عضو فى نقابة المهندسين 😍', 0, 0),
(20, '2023-06-02 15:34:27', 1092, 'تعلن شركة امبليفاى اكادمى عن ورشة عمل مدتها اربع ايام. ١٦ ساعة  تصوير زيتى هتتعلم فيها اساسيات الثرى دى والرسم والظل والنور والprespective   للتفاصيل انبوكس .\r\n', 2, 1),
(21, '2023-06-02 15:34:27', 1, '3 اسباب يخلوك تبدأ تتعلم البرمجة مع AMIT Learning👇:  \n🔴1- هيكون معاك اقوى مدربين محترفين في المجال هيساعدك تاخد الخطوة وتكون مبرمج  محترف وتختار المجال اللي يناسبك \n🔴2-عندنا اكتر من 7 دبلومات فى مجال البرمجة والـ Software وده هيسهل عليك تاخد القرار\n🔴3-احنا دايما متميزين لأننا بنبدأ معاك من نقطة الصفر وبنوصلك لمرحلة الإتقان والأحتراف عشان تكون مؤهل إنك         تبدأ في مجال العمل  ', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `postcomments`
--

CREATE TABLE `postcomments` (
  `post_comment_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `post_comment` text NOT NULL,
  `post_comment_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `postimg`
--

CREATE TABLE `postimg` (
  `post_img_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `post_img` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `postimg`
--

INSERT INTO `postimg` (`post_img_id`, `post_id`, `post_img`) VALUES
(18, 13, 'image_20230514231709FB_IMG_1683972779526.jpg.jpg'),
(19, 13, 'image_20230514231709IMG-20230513-WA0000.jpg.jpg'),
(20, 13, 'image_20230514231709FB_IMG_1683943443578.jpg.jpg'),
(21, 13, 'image_20230514231709IMG_20230513_220242.jpg.jpg'),
(22, 14, 'image_202305161135414126-1.jpg.jpg'),
(23, 15, 'image_20230516120256طرنيب.png.jpg'),
(24, 15, 'image_2023051612025649dcb199abc4aa4ec90b2244e5fe38853014d27c.jpg.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `postlikes`
--

CREATE TABLE `postlikes` (
  `post_like_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `postlikes`
--

INSERT INTO `postlikes` (`post_like_id`, `post_id`, `student_id`) VALUES
(36, 13, 1),
(46, 14, 1),
(47, 21, 1),
(50, 20, 1);

-- --------------------------------------------------------

--
-- Table structure for table `rate`
--

CREATE TABLE `rate` (
  `rate_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `rate` int(11) NOT NULL,
  `rate_content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rate`
--

INSERT INTO `rate` (`rate_id`, `student_id`, `company_id`, `rate`, `rate_content`) VALUES
(3, 5, 1, 3, 'Focus on your experience and your child’s experience.'),
(4, 570000, 1, 5, '');

-- --------------------------------------------------------

--
-- Table structure for table `studentcourses`
--

CREATE TABLE `studentcourses` (
  `student_course_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `studentcourses`
--

INSERT INTO `studentcourses` (`student_course_id`, `student_id`, `course_id`) VALUES
(1, 1, 3),
(6, 1, 24);

-- --------------------------------------------------------

--
-- Table structure for table `studentinterest`
--

CREATE TABLE `studentinterest` (
  `student_interest_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `interest_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `studentinterest`
--

INSERT INTO `studentinterest` (`student_interest_id`, `student_id`, `interest_id`) VALUES
(1, 570000, 1),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `student_first_name` text NOT NULL,
  `student_last_name` text NOT NULL,
  `student_DOB` datetime NOT NULL,
  `student_country` text NOT NULL,
  `student_city` text NOT NULL,
  `student_time_to_create_account` datetime NOT NULL,
  `student_phone` int(11) NOT NULL,
  `student_email` text NOT NULL,
  `student_password` text NOT NULL,
  `student_img` text NOT NULL,
  `student_gender` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `student_first_name`, `student_last_name`, `student_DOB`, `student_country`, `student_city`, `student_time_to_create_account`, `student_phone`, `student_email`, `student_password`, `student_img`, `student_gender`) VALUES
(0, 'mkh', 'gzy', '2023-07-06 00:00:00', 'Egypt', 'Red Sea', '2023-07-11 00:22:20', 1012345678, 'miss@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', 'image_20230711012220OIG.jpg.jpg', 'male'),
(1, 'moaz', 'hassan', '2003-03-13 21:31:13', 'Egypt', 'Cairo', '2023-03-10 20:31:13', 1017129160, 'moaz.47238@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', 'young.jpg', 'male'),
(5, 'hany', 'ahmed', '2004-05-20 00:00:00', 'Egypt', 'Gharbiya', '2023-05-13 15:12:49', 1014587460, 'hh@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', '', 'male'),
(570000, 'mohammed', 'nasser', '1999-05-20 00:00:00', 'Egypt', 'Gharbiya', '2023-05-12 18:12:09', 1258746921, 'hh@gmail.com', '$2y$10$vDzcAm1l7BT2jgW6PYd8b.fDlJzXdTb0nVz5IKH6IkYL.EWHwkNUS', 'image_20230513155543.jpg', 'male');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `bookstocourse`
--
ALTER TABLE `bookstocourse`
  ADD PRIMARY KEY (`book_to_course_id`),
  ADD KEY `couseId` (`course_id`);

--
-- Indexes for table `commentreport`
--
ALTER TABLE `commentreport`
  ADD PRIMARY KEY (`comment_report_id`),
  ADD KEY `commentId` (`comment_id`),
  ADD KEY `studentId` (`student_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`company_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `companyId` (`company_id`),
  ADD KEY `course_under_category` (`interest_id`),
  ADD KEY `course_type_id` (`course_type_id`);

--
-- Indexes for table `coursetype`
--
ALTER TABLE `coursetype`
  ADD PRIMARY KEY (`course_type_id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`discount_id`);

--
-- Indexes for table `following`
--
ALTER TABLE `following`
  ADD PRIMARY KEY (`follow_id`),
  ADD KEY `studentId` (`student_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `helpcompany`
--
ALTER TABLE `helpcompany`
  ADD PRIMARY KEY (`help_company_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `helpstudent`
--
ALTER TABLE `helpstudent`
  ADD PRIMARY KEY (`help_student_id`),
  ADD KEY `studentId` (`student_id`);

--
-- Indexes for table `interest`
--
ALTER TABLE `interest`
  ADD PRIMARY KEY (`interest_id`);

--
-- Indexes for table `locationcompany`
--
ALTER TABLE `locationcompany`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `notificationscompany`
--
ALTER TABLE `notificationscompany`
  ADD PRIMARY KEY (`notification_company_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `notificationsstudent`
--
ALTER TABLE `notificationsstudent`
  ADD PRIMARY KEY (`notification_student_id`),
  ADD KEY `studentId` (`student_id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `postcomments`
--
ALTER TABLE `postcomments`
  ADD PRIMARY KEY (`post_comment_id`),
  ADD KEY `postId` (`post_id`),
  ADD KEY `studentId` (`student_id`);

--
-- Indexes for table `postimg`
--
ALTER TABLE `postimg`
  ADD PRIMARY KEY (`post_img_id`),
  ADD KEY `postId` (`post_id`);

--
-- Indexes for table `postlikes`
--
ALTER TABLE `postlikes`
  ADD PRIMARY KEY (`post_like_id`),
  ADD KEY `postId` (`post_id`),
  ADD KEY `studentId` (`student_id`);

--
-- Indexes for table `rate`
--
ALTER TABLE `rate`
  ADD PRIMARY KEY (`rate_id`),
  ADD KEY `studentId` (`student_id`),
  ADD KEY `companyId` (`company_id`);

--
-- Indexes for table `studentcourses`
--
ALTER TABLE `studentcourses`
  ADD PRIMARY KEY (`student_course_id`),
  ADD KEY `studentId` (`student_id`),
  ADD KEY `courseId` (`course_id`);

--
-- Indexes for table `studentinterest`
--
ALTER TABLE `studentinterest`
  ADD PRIMARY KEY (`student_interest_id`),
  ADD KEY `studentId` (`student_id`),
  ADD KEY `interestId` (`interest_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bookstocourse`
--
ALTER TABLE `bookstocourse`
  MODIFY `book_to_course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `commentreport`
--
ALTER TABLE `commentreport`
  MODIFY `comment_report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `company_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5909004;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2147483648;

--
-- AUTO_INCREMENT for table `coursetype`
--
ALTER TABLE `coursetype`
  MODIFY `course_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
  MODIFY `discount_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `following`
--
ALTER TABLE `following`
  MODIFY `follow_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `helpcompany`
--
ALTER TABLE `helpcompany`
  MODIFY `help_company_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `helpstudent`
--
ALTER TABLE `helpstudent`
  MODIFY `help_student_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interest`
--
ALTER TABLE `interest`
  MODIFY `interest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `locationcompany`
--
ALTER TABLE `locationcompany`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notificationscompany`
--
ALTER TABLE `notificationscompany`
  MODIFY `notification_company_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notificationsstudent`
--
ALTER TABLE `notificationsstudent`
  MODIFY `notification_student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `postcomments`
--
ALTER TABLE `postcomments`
  MODIFY `post_comment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `postimg`
--
ALTER TABLE `postimg`
  MODIFY `post_img_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `postlikes`
--
ALTER TABLE `postlikes`
  MODIFY `post_like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `rate`
--
ALTER TABLE `rate`
  MODIFY `rate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `studentcourses`
--
ALTER TABLE `studentcourses`
  MODIFY `student_course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `studentinterest`
--
ALTER TABLE `studentinterest`
  MODIFY `student_interest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookstocourse`
--
ALTER TABLE `bookstocourse`
  ADD CONSTRAINT `bookstocourse_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON UPDATE CASCADE;

--
-- Constraints for table `commentreport`
--
ALTER TABLE `commentreport`
  ADD CONSTRAINT `commentreport_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `commentreport_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `commentreport_ibfk_3` FOREIGN KEY (`comment_id`) REFERENCES `postcomments` (`post_comment_id`) ON UPDATE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `courses_ibfk_2` FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`),
  ADD CONSTRAINT `courses_ibfk_3` FOREIGN KEY (`course_type_id`) REFERENCES `coursetype` (`course_type_id`);

--
-- Constraints for table `following`
--
ALTER TABLE `following`
  ADD CONSTRAINT `following_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `following_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `helpcompany`
--
ALTER TABLE `helpcompany`
  ADD CONSTRAINT `helpcompany_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `helpstudent`
--
ALTER TABLE `helpstudent`
  ADD CONSTRAINT `helpstudent_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE;

--
-- Constraints for table `locationcompany`
--
ALTER TABLE `locationcompany`
  ADD CONSTRAINT `locationcompany_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `notificationscompany`
--
ALTER TABLE `notificationscompany`
  ADD CONSTRAINT `notificationscompany_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `notificationsstudent`
--
ALTER TABLE `notificationsstudent`
  ADD CONSTRAINT `notificationsstudent_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `postcomments`
--
ALTER TABLE `postcomments`
  ADD CONSTRAINT `postcomments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `postcomments_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE;

--
-- Constraints for table `postimg`
--
ALTER TABLE `postimg`
  ADD CONSTRAINT `postimg_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON UPDATE CASCADE;

--
-- Constraints for table `postlikes`
--
ALTER TABLE `postlikes`
  ADD CONSTRAINT `postlikes_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `postlikes_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON UPDATE CASCADE;

--
-- Constraints for table `rate`
--
ALTER TABLE `rate`
  ADD CONSTRAINT `rate_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rate_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE CASCADE;

--
-- Constraints for table `studentcourses`
--
ALTER TABLE `studentcourses`
  ADD CONSTRAINT `studentcourses_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `studentcourses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON UPDATE CASCADE;

--
-- Constraints for table `studentinterest`
--
ALTER TABLE `studentinterest`
  ADD CONSTRAINT `studentinterest_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `studentinterest_ibfk_2` FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
