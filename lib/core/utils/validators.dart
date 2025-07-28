bool validateEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

bool validateName(String name) => RegExp(r"^[a-zA-Z ]+$").hasMatch(name);

bool validatePasswordLength(String password) => password.length >= 6;

bool validatePasswordMatch(String password, String confirmPassword) =>
    password == confirmPassword;
