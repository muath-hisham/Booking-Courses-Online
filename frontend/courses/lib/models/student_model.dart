class Student {
  String id = "";
  String fName = "";
  String lName = "";
  DateTime DOB = DateTime(0);
  String country = "";
  String city = "";
  DateTime timeToCreateAccount = DateTime(0);
  String email = "";
  String password = "";
  String img = "";
  String gender = "";
  String phone = "";

  Student.empty();

  Student(Map<String, dynamic> user) {
    id = user['student_id'];
    fName = user['student_first_name'];
    lName = user['student_last_name'];
    DOB = DateTime.parse(user['student_DOB']);
    country = user['student_country'];
    city = user['student_city'];
    timeToCreateAccount =
        DateTime.parse(user['student_time_to_create_account']);
    email = user['student_email'];
    password = user['student_password'];
    img = user['student_img'];
    gender = user['student_gender'];
    phone = user['student_phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': id,
      'student_first_name': fName,
      'student_last_name': lName,
      'student_DOB': DOB,
      'student_country': country,
      'student_city': city,
      'student_time_to_create_account': timeToCreateAccount,
      'student_email': email,
      'student_password': password,
      'student_img': img,
      'student_gender': gender,
      'student_phone': phone
    };
  }
}
