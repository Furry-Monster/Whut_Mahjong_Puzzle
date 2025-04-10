import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  // 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
    _musicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
    _vibrationEnabled = prefs.getBool(_vibrationEnabledKey) ?? true;
    notifyListeners();
  }

  // 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, _soundEnabled);
    await prefs.setBool(_musicEnabledKey, _musicEnabled);
    await prefs.setBool(_vibrationEnabledKey, _vibrationEnabled);
  }

  // 切换声音开关
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _saveSettings();
    notifyListeners();
  }

  // 切换音乐开关
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    _saveSettings();
    notifyListeners();
  }

  // 切换震动开关
  void toggleVibration() {
    _vibrationEnabled = !_vibrationEnabled;
    _saveSettings();
    notifyListeners();
  }
}
