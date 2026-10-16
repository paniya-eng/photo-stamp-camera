import 'package:flutter/material.dart';
import '../models/stamp_settings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final StampSettings currentSettings;
  final Function(StampSettings) onSave;

  const SettingsScreen({
    super.key,
    required this.currentSettings,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late StampSettings _settings;
  final _settingsService = SettingsService();

  final List<String> positions = [
    'topLeft',
    'topRight',
    'bottomLeft',
    'bottomRight',
    'center',
  ];

  final List<String> dateFormats = [
    'yyyy-MM-dd HH:mm:ss',
    'dd/MM/yyyy HH:mm',
    'MM/dd/yyyy hh:mm a',
    'yyyy/MM/dd HH:mm',
    'dd MMM yyyy HH:mm',
  ];

  @override
  void initState() {
    super.initState();
    _settings = widget.currentSettings;
  }

  Future<void> _save() async {
    await _settingsService.save(_settings);
    widget.onSave(_settings);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات مهر'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('ذخیره', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('موقعیت مهر', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _settings.position,
            items: positions
                .map((p) => DropdownMenuItem(value: p, child: Text(_positionLabel(p))))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _settings = _settings.copyWith(position: v));
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          const Text('اندازه فونت', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _settings.fontSize,
            min: 16,
            max: 60,
            divisions: 22,
            label: _settings.fontSize.round().toString(),
            onChanged: (v) => setState(() => _settings = _settings.copyWith(fontSize: v)),
          ),
          const SizedBox(height: 16),
          const Text('شفافیت متن', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _settings.opacity,
            min: 0.3,
            max: 1.0,
            divisions: 7,
            label: (_settings.opacity * 100).round().toString() + '%',
            onChanged: (v) => setState(() => _settings = _settings.copyWith(opacity: v)),
          ),
          const SizedBox(height: 16),
          const Text('فرمت تاریخ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _settings.dateFormat,
            items: dateFormats
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _settings = _settings.copyWith(dateFormat: v));
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('نمایش پس‌زمینه برای متن'),
            value: _settings.showBackground,
            onChanged: (v) => setState(() => _settings = _settings.copyWith(showBackground: v)),
          ),
          const SizedBox(height: 16),
          const Text('رنگ متن', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              _colorButton(0xFFFFFFFF, 'سفید'),
              _colorButton(0xFFFFFF00, 'زرد'),
              _colorButton(0xFF00FF00, 'سبز'),
              _colorButton(0xFFFF0000, 'قرمز'),
              _colorButton(0xFF00BFFF, 'آبی'),
              _colorButton(0xFF000000, 'سیاه'),
            ],
          ),
        ],
      ),
    );
  }

  String _positionLabel(String pos) {
    switch (pos) {
      case 'topLeft':
        return 'بالا چپ';
      case 'topRight':
        return 'بالا راست';
      case 'bottomLeft':
        return 'پایین چپ';
      case 'bottomRight':
        return 'پایین راست';
      case 'center':
        return 'وسط';
      default:
        return pos;
    }
  }

  Widget _colorButton(int colorValue, String label) {
    final isSelected = _settings.colorValue == colorValue;
    return GestureDetector(
      onTap: () => setState(() => _settings = _settings.copyWith(colorValue: colorValue)),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(colorValue),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
      ),
    );
  }
}
