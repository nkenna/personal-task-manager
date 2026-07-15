import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/core/providers/database_provider.dart';
import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/data/datasources/local/profile_local_data_source.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';
import 'package:ptm/features/profile/domain/usecases/add_profile.dart';
import 'package:ptm/features/profile/domain/usecases/delete_profile.dart';
import 'package:ptm/features/profile/domain/usecases/get_active_profile.dart';
import 'package:ptm/features/profile/domain/usecases/list_profiles.dart';
import 'package:ptm/features/profile/domain/usecases/set_active_profile.dart';
import 'package:ptm/features/profile/domain/usecases/update_profile.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource(ref.watch(databaseHelperProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileLocalDataSourceProvider));
});

final addProfileProvider = Provider<AddProfile>((ref) {
  return AddProfile(ref.watch(profileRepositoryProvider));
});

final updateProfileProvider = Provider<UpdateProfile>((ref) {
  return UpdateProfile(ref.watch(profileRepositoryProvider));
});

final deleteProfileProvider = Provider<DeleteProfile>((ref) {
  return DeleteProfile(ref.watch(profileRepositoryProvider));
});

final listProfilesProvider = Provider<ListProfiles>((ref) {
  return ListProfiles(ref.watch(profileRepositoryProvider));
});

final getActiveProfileProvider = Provider<GetActiveProfile>((ref) {
  return GetActiveProfile(ref.watch(profileRepositoryProvider));
});

final setActiveProfileProvider = Provider<SetActiveProfile>((ref) {
  return SetActiveProfile(ref.watch(profileRepositoryProvider));
});

final activeProfileProvider = FutureProvider<Profile?>((ref) async {
  final active = await ref.read(getActiveProfileProvider).call(const NoParams());
  if (active != null) return active;

  final profiles = await ref.read(listProfilesProvider).call(const NoParams());
  if (profiles.isEmpty) return null;

  final first = profiles.first;
  await ref
      .read(setActiveProfileProvider)
      .call(SetActiveProfileParams(first.id));
  return first;
});

final profilesProvider = FutureProvider<List<Profile>>((ref) async {
  final listProfiles = ref.watch(listProfilesProvider);
  return listProfiles.call(const NoParams());
});
