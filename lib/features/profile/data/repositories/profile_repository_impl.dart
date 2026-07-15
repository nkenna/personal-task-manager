import 'package:ptm/features/profile/data/datasources/local/profile_local_data_source.dart';
import 'package:ptm/features/profile/data/models/profile_model.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<int> addProfile(Profile profile) async {
    return _localDataSource.addProfile(ProfileModel.fromEntity(profile));
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    await _localDataSource.updateProfile(ProfileModel.fromEntity(profile));
  }

  @override
  Future<void> deleteProfile(int id) async {
    await _localDataSource.deleteProfile(id);
  }

  @override
  Future<List<Profile>> listProfiles() async {
    final models = await _localDataSource.listProfiles();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Profile?> getActiveProfile() async {
    final model = await _localDataSource.getActiveProfile();
    return model?.toEntity();
  }

  @override
  Future<void> setActiveProfile(int id) async {
    await _localDataSource.setActiveProfile(id);
  }
}
