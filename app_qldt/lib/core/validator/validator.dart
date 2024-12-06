class Regex {
  static final email = RegExp(r"^[\w-\.]+@hust\.edu\.vn$");
  static final password = RegExp(r"^.{6,10}$");
}

class Validator {
  static String? Function(String?) email() => (String? str) {
        if (str?.isEmpty ?? true) {
          return "Email không được để trống";
        }
        if (!Regex.email.hasMatch(str!)) {
          return "Định dạng Email không hợp lệ (@hust.edu.vn)";
        }

        return null;
      };

  static String? Function(String?) password() => (String? str) {
        if (str?.isEmpty ?? true) {
          return "Mật khẩu không được để trống";
        }
        if (!Regex.password.hasMatch(str!)) {
          return "Mật khẩu không hợp lệ (Giới hạn 6 - 10 ký tự)";
        }

        return null;
      };
  static String? Function(String?) ho() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Họ người dùng không được để trống";
    }

    return null;
  };
  static String? Function(String?) ten() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Tên người dùng không được để trống";
    }

    return null;
  };
}
