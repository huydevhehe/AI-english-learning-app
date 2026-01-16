import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType {
  manual,   // bật / tắt
  schedule, // theo giờ
}

class ThemeController extends ChangeNotifier {
  ThemeModeType _mode = ThemeModeType.schedule;

  bool _isDarkManual = false;

  int _darkStartHour = 18; // mặc định
  int _darkEndHour = 6;    // mặc định

  // =====================
  // THEME MODE CHO APP
  // =====================
  ThemeMode get themeMode {
    if (_mode == ThemeModeType.manual) {
      return _isDarkManual ? ThemeMode.dark : ThemeMode.light;
    }

    final hour = DateTime.now().hour;

    final isDarkTime = _darkStartHour < _darkEndHour
        ? hour >= _darkStartHour && hour < _darkEndHour
        : hour >= _darkStartHour || hour < _darkEndHour;

    return isDarkTime ? ThemeMode.dark : ThemeMode.light;
  }

  // =====================
  // LOAD LOCAL
  // =====================
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _mode = ThemeModeType.values[
        prefs.getInt('theme_mode') ?? ThemeModeType.schedule.index];

    _isDarkManual = prefs.getBool('dark_manual') ?? false;
    _darkStartHour = prefs.getInt('dark_start') ?? 18;
    _darkEndHour = prefs.getInt('dark_end') ?? 6;

    notifyListeners();
  }

  // =====================
  // MANUAL MODE
  // =====================
  Future<void> setManual(bool isDark) async {
    _mode = ThemeModeType.manual;
    _isDarkManual = isDark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', ThemeModeType.manual.index);
    await prefs.setBool('dark_manual', isDark);

    notifyListeners();
  }

  // =====================
  // AUTO MODE (THEO GIỜ)
  // =====================
  Future<void> setSchedule({
    required int startHour,
    required int endHour,
  }) async {
    _mode = ThemeModeType.schedule;
    _darkStartHour = startHour;
    _darkEndHour = endHour;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', ThemeModeType.schedule.index);
    await prefs.setInt('dark_start', startHour);
    await prefs.setInt('dark_end', endHour);

    notifyListeners();
  }

  // =====================
  // GETTERS CHO UI
  // =====================
  ThemeModeType get mode => _mode;
  bool get isDarkManual => _isDarkManual;
  int get darkStartHour => _darkStartHour;
  int get darkEndHour => _darkEndHour;
}
