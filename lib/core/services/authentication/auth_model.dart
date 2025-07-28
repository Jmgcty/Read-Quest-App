class AuthModel {
  final String? name;
  final String email;
  final String password;
  final String? confirmPassword;

  AuthModel({
    this.name,
    required this.email,
    required this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toSignupMap() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      };

  Map<String, dynamic> toLoginMap() => {
        'email': email,
        'password': password,
      };
}
