import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasource/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile(String uid) async {
    return await remoteDataSource.getProfile(uid);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      uid: profile.uid,
      name: profile.name,
      email: profile.email,
      avatarUrl: profile.avatarUrl,
      username: profile.username,
    );

    await remoteDataSource.updateProfile(model);
  }

  @override
  Future<String> uploadAvatar(String uid, String filePath) {
    return remoteDataSource.uploadAvatar(uid, filePath);
  }
}
