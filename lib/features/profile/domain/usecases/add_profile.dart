import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class AddProfileParams {
  const AddProfileParams(this.profile);

  final Profile profile;
}

class AddProfile implements UseCase<int, AddProfileParams> {
  AddProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<int> call(AddProfileParams params) =>
      _repository.addProfile(params.profile);
}
