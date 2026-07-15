import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams {
  const UpdateProfileParams(this.profile);

  final Profile profile;
}

class UpdateProfile implements UseCase<void, UpdateProfileParams> {
  UpdateProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<void> call(UpdateProfileParams params) =>
      _repository.updateProfile(params.profile);
}
