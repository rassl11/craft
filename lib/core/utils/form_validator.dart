class FormValidator {
  bool isUsernameValid(String username) {
    const emailRegex = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    return RegExp(emailRegex).hasMatch(username);
  }

  bool isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool isFormValid(String username, String password) =>
      isUsernameValid(username) && isPasswordValid(password);
}
