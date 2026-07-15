import 'package:ptm/core/database/database_helper.dart';
import 'package:ptm/features/profile/data/models/profile_model.dart';

class ProfileLocalDataSource {
  ProfileLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String table = 'profiles';

  Future<int> addProfile(ProfileModel profile) async {
    return _databaseHelper.insert(table, profile.toMap());
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _databaseHelper.update(
      table,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> deleteProfile(int id) async {
    await _databaseHelper.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ProfileModel>> listProfiles() async {
    final rows = await _databaseHelper.query(
      table,
      orderBy: 'id DESC',
    );
    return rows.map(ProfileModel.fromMap).toList();
  }

  Future<ProfileModel?> getActiveProfile() async {
    final rows = await _databaseHelper.query(
      table,
      where: 'is_active = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProfileModel.fromMap(rows.first);
  }

  Future<void> setActiveProfile(int id) async {
    await _databaseHelper.update(table, {'is_active': 0});
    await _databaseHelper.update(
      table,
      {'is_active': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
