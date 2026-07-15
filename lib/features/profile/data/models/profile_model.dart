import 'package:ptm/features/profile/domain/entities/profile.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  final int id;
  final String name;
  final String email;
  final bool isActive;

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != 0) 'id': id,
      'name': name,
      'email': email,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      isActive: profile.isActive,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      email: email,
      isActive: isActive,
    );
  }
}
