class UserModel {
  final String userStatus;
  final int userTCode;
  final String firstName;
  final String lastName;
  final String email;
  final String lastLogin;
  final String photo;

  UserModel({
    required this.userStatus,
    required this.userTCode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.lastLogin,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userStatus: json['Status'],
      userTCode: json['tCode'],
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      email: json['Email'] ?? '',
      lastLogin: json['LastLogin'] ?? '',
      photo: json['Photo'] ?? '',
    );
  }

  /// 🔹 Model → JSON (REQUIRED for storage)
  Map<String, dynamic> toJson2() {
    return {
      'Status': userStatus,
      'tCode': userTCode,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'LastLogin': lastLogin,
      'Photo': photo,
    };
  }
}
