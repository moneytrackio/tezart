abstract class BaseValidator {
  bool get isValid;
  // a function that throws the adequate error if the input is invalid
  void validate();
}
