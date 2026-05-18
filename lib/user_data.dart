class UserData {
  static int? studentId;
  static int? teacherId;
  static String name = "";
  static String group = "";
  static String department = "";
  static String role = "student";
  static String position = "";
  static int capacity = 0;

  static void clear() {
    studentId = null;
    teacherId = null;
    name = "";
    group = "";
    department = "";
    role = "student";
    position = "";
    capacity = 0;
  }
}
