class StampSettings {
  final String position; // topLeft, topRight, bottomLeft, bottomRight, center
  final double fontSize;
  final int colorValue; // ARGB
  final double opacity; // 0.0 - 1.0
  final String dateFormat; // e.g. yyyy-MM-dd HH:mm:ss
  final bool showBackground;
  final int backgroundColorValue;

  const StampSettings({
    this.position = 'bottomRight',
    this.fontSize = 28.0,
    this.colorValue = 0xFFFFFFFF,
    this.opacity = 0.9,
    this.dateFormat = 'yyyy-MM-dd HH:mm:ss',
    this.showBackground = true,
    this.backgroundColorValue = 0x80000000,
  });

  StampSettings copyWith({
    String? position,
    double? fontSize,
    int? colorValue,
    double? opacity,
    String? dateFormat,
    bool? showBackground,
    int? backgroundColorValue,
  }) {
    return StampSettings(
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      colorValue: colorValue ?? this.colorValue,
      opacity: opacity ?? this.opacity,
      dateFormat: dateFormat ?? this.dateFormat,
      showBackground: showBackground ?? this.showBackground,
      backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'fontSize': fontSize,
      'colorValue': colorValue,
      'opacity': opacity,
      'dateFormat': dateFormat,
      'showBackground': showBackground,
      'backgroundColorValue': backgroundColorValue,
    };
  }

  factory StampSettings.fromMap(Map<String, dynamic> map) {
    return StampSettings(
      position: map['position'] ?? 'bottomRight',
      fontSize: (map['fontSize'] ?? 28.0).toDouble(),
      colorValue: map['colorValue'] ?? 0xFFFFFFFF,
      opacity: (map['opacity'] ?? 0.9).toDouble(),
      dateFormat: map['dateFormat'] ?? 'yyyy-MM-dd HH:mm:ss',
      showBackground: map['showBackground'] ?? true,
      backgroundColorValue: map['backgroundColorValue'] ?? 0x80000000,
    );
  }
}
