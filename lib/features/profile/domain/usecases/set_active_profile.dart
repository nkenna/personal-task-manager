import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class SetActiveProfileParams {
  const SetActiveProfileParams(this.id);

  final int id;
}

class SetActiveProfile implements UseCase<void, SetActiveProfileParams> {
  SetActiveProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<void> call(SetActiveProfileParams params) =>
      _repository.setActiveProfile(params.id);
}
