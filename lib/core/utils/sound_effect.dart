import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundEffect {
  static AudioPlayer? _player;
  static final Random _random = Random();

  static const List<String> _successSounds = [
    'sounds/successs1.wav',
    'sounds/successs2.wav',
  ];

  static const List<String> _errorSounds = [
    'sounds/erro.wav',
    'sounds/erro2.wav',
    'sounds/erro3.wav',
    'sounds/erro4.wav',
  ];

  static AudioPlayer _getPlayer() {
    _player ??= AudioPlayer();
    return _player!;
  }

  /// ✅ CHECK SETTINGS
  static Future<bool> _isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('soundEnabled') ?? true;
  }

  /// ✅ ĐÚNG
  static Future<void> playCorrect() async {
    if (!await _isSoundEnabled()) return;

    final player = _getPlayer();
    final sound =
        _successSounds[_random.nextInt(_successSounds.length)];

    await player.stop();
    await player.play(AssetSource(sound));
  }

  /// ❌ SAI
  static Future<void> playWrong() async {
    if (!await _isSoundEnabled()) return;

    final player = _getPlayer();
    final sound =
        _errorSounds[_random.nextInt(_errorSounds.length)];

    await player.stop();
    await player.play(AssetSource(sound));
  }
}
