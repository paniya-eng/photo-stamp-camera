import 'package:shared_preferences/shared_preferences.dart';
import '../models/stamp_settings.dart';

class SettingsService {
  static const _key = 'stamp_settings';

  Future<StampSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final position = prefs.getString('position') ?? 'bottomRight';
    final fontSize = prefs.getDouble('fontSize') ?? 28.0;
    final colorValue = prefs.getInt('colorValue') ?? 0xFFFFFFFF;
    final opacity = prefs.getDouble('opacity') ?? 0.9;
    final dateFormat = prefs.getString('dateFormat') ?? 'yyyy-MM-dd HH:mm:ss';
    final showBackground = prefs.getBool('showBackground') ?? true;
    final backgroundColorValue = prefs.getInt('backgroundColorValue') ?? 0x80000000;

    return StampSettings(
      position: position,
      fontSize: fontSize,
      colorValue: colorValue,
      opacity: opacity,
      dateFormat: dateFormat,
      showBackground: showBackground,
      backgroundColorValue: backgroundColorValue,
    );
  }

  Future<void> save(StampSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('position', settings.position);
    await prefs.setDouble('fontSize', settings.fontSize);
    await prefs.setInt('colorValue', settings.colorValue);
    await prefs.setDouble('opacity', settings.opacity);
    await prefs.setString('dateFormat', settings.dateFormat);
    await prefs.setBool('showBackground', settings.showBackground);
    await prefs.setInt('backgroundColorValue', settings.backgroundColorValue);
  }
}
