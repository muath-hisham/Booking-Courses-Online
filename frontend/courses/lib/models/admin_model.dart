// class Admin {
//   String id = '';
//   String email = "";
//   String password = '';
//   String ipAdd = '';

//     Admin.empty();

//     Admin(Map<String, dynamic> user) {
//     id = user['company_id'];
//     name = user['company_name'];
//     description = user['company_description'];
//     country = user['company_country'];
//     timeToCreateAccount =
//         DateTime.parse(user['company_time_to_create_account']);
//     email = user['company_email'];
//     password = user['company_password'];
//     img = user['company_img'];
//     website = user['company_website'];
//     isAproved = user['company_is_aproved'];
//     phone1 = user['company_first_phone'];
//     phone2 = user['company_second_phone'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'company_id': id,
//       'company_name': name,
//       'company_description': description,
//       'company_country': country,
//       'company_time_to_create_account': timeToCreateAccount,
//       'company_email': email,
//       'company_password': password,
//       'company_img': img,
//       'company_website': website,
//       'company_is_aproved': isAproved,
//       'company_first_phone': phone1,
//       'company_second_phone': phone2
//     };
//   }

// }
