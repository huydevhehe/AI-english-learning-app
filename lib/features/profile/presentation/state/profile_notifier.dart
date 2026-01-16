import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import 'profile_state.dart';

class ProfileNotifier extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;

  ProfileNotifier({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
  });

  ProfileState _state = ProfileState();
  ProfileState get state => _state;

  Future<void> loadProfile(String uid) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final profile = await getProfileUseCase(uid);
      _state = _state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }

    notifyListeners();
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    await updateProfileUseCase(profile);
    _state = _state.copyWith(profile: profile);
    notifyListeners();
  }

  Future<void> uploadAvatar(String uid, String filePath) async {
  try {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    // Gọi đúng usecase (KHÔNG dùng execute)
    final url = await uploadAvatarUseCase(uid, filePath);

    // Cập nhật state profile
    final updated = _state.profile!.copyWith(avatarUrl: url);
    await updateProfile(updated);

  } catch (e) {
    _state = _state.copyWith(error: e.toString());
  } finally {
    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

}
