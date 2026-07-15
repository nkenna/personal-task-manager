import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class GetActiveProfile implements UseCase<Profile?, NoParams> {
  GetActiveProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Profile?> call(NoParams params) => _repository.getActiveProfile();
}
