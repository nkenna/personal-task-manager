import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';

class ListProfiles implements UseCase<List<Profile>, NoParams> {
  ListProfiles(this._repository);

  final ProfileRepository _repository;

  @override
  Future<List<Profile>> call(NoParams params) => _repository.listProfiles();
}
