class RegistrationFormData {
  String fullName = '';
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';

  Map<String, dynamic> toFirestoreMap() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
  };
}