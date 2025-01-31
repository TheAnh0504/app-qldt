class Regex {
  static final email = RegExp(r"^[\w-\.]+@hust\.edu\.vn$");
  static final password = RegExp(r"^.{6,10}$");
  static final maxStudentAmount = RegExp(r"^[1-9]\d*$");

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
  static String? Function(String?) classId() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Mã lớp không được để trống";
    }
    if (str?.length != 6 ) {
      return "Mã lớp phải có 6 ký tự";
    }

    return null;
  };

  static String? Function(String?) className() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Tên lớp không được để trống";
    }

    return null;
  };

  static String? Function(String?) reason() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Lý do xin nghỉ học không được để trống";
    }

    return null;
  };

  static String? Function(String?) maxStudentAmount() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Số lượng sinh viên tối đa không được để trống";
    }

    if (!Regex.maxStudentAmount.hasMatch(str!)) {
      return "Số lượng sinh viên tối đa phải là số nguyên dương";
    }

    if (int.parse(str) > 50) {
      return "Số lượng sinh viên tối đa không được lớn hơn 50";
    }

    return null;
  };

  static String? Function(String?) attachedCode() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Mã lớp kèm không được để trống";
    }
    if (str?.length != 6 ) {
      return "Mã lớp kèm phải có 6 ký tự";
    }

    return null;
  };

  static String? Function(String?) materialName() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Tên tài liệu không được để trống";
    }

    return null;
  };

  static String? Function(String?) description() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Mô tả tài liệu không được để trống";
    }

    return null;
  };

  static String? Function(String?) materialType() => (String? str) {
    if (str?.isEmpty ?? true) {
      return "Loại tài liệu không được để trống";
    }

    return null;
  };
}
