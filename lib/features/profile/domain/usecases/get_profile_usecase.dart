import '../repositories/profile_repository.dart';
import '../entities/profile_entity.dart';

class GetProfileUseCase {
  final ProfileRepository repo;

  GetProfileUseCase(this.repo);

  Future<ProfileEntity?> call(String uid) async {
    return await repo.getProfile(uid);
  }
}
