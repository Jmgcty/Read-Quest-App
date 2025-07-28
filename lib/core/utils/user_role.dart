enum UserRole {
  student(3),
  teacher(2),
  admin(1);

  final int id;
  const UserRole(this.id);

  String get label => name[0].toUpperCase() + name.substring(1);

  static UserRole? identify(String name) {
    switch (name) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'admin':
        return UserRole.admin;
      default:
        return null;
    }
  }
}
