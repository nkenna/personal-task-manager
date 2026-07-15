import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class DeleteProfileParams {
  const DeleteProfileParams(this.id);

  final int id;
}

class DeleteProfile implements UseCase<void, DeleteProfileParams> {
  DeleteProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<void> call(DeleteProfileParams params) =>
      _repository.deleteProfile(params.id);
}
