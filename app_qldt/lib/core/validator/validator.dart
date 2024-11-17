class Regex {
  static final email = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  static final password =
      RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
}

class Validator {
  static String? Function(String?) username() => (String? str) {
        if (str?.isEmpty ?? true) {
          return "Không được để trống tài khoản.";
        }
        if (!Regex.email.hasMatch(str!)) {
          return "Tài khoản không đúng định dạng.";
        }

        return null;
      };

  static String? Function(String?) password() => (String? str) {
        if (str?.isEmpty ?? true) {
          return "Không được để trống mật khẩu.";
        }
        // if (!Regex.password.hasMatch(str!)) {
        //   callback?.call(true);
        //   return "Mật khẩu không đúng định dạng.";
        // }

        return null;
      };
}
