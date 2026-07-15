import 'package:ptm/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<int> addProfile(Profile profile);

  Future<void> updateProfile(Profile profile);

  Future<void> deleteProfile(int id);

  Future<List<Profile>> listProfiles();

  Future<Profile?> getActiveProfile();

  Future<void> setActiveProfile(int id);
}
