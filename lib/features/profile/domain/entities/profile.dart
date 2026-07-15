class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  final int id;
  final String name;
  final String email;
  final bool isActive;
}
