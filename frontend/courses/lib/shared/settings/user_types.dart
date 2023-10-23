enum UserType {
  Student,
  Company,
  Admin,
}

UserType userTypeFromString(String userType) {
  switch(userType) {
    case 'student':
      return UserType.Student;
    case 'company':
      return UserType.Company;
    case 'admin':
      return UserType.Admin;
    default:
      throw ArgumentError('Invalid user type: $userType');
  }
}

String userTypeToString(UserType userType) {
  switch(userType) {
    case UserType.Student:
      return 'student';
    case UserType.Company:
      return 'company';
    case UserType.Admin:
      return 'admin';
    default:
      throw ArgumentError('Invalid user type: $userType');
  }
}