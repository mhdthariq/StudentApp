class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Student ID cannot be empty";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return "Student ID must be numeric";
    }
    return null;
  }
}
