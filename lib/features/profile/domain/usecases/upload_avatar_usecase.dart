import '../repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<String> call(String uid, String filePath) {
    return repository.uploadAvatar(uid, filePath);
  }
}
