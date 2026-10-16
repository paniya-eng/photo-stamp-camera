import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/stamp_settings.dart';

class StampService {
  Future<File> applyStamp({
    required File imageFile,
    required StampSettings settings,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) {
      throw Exception('Cannot decode image');
    }

    // Create a picture recorder to draw with Flutter canvas for better text
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Draw the original image
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    canvas.drawImage(uiImage, Offset.zero, paint);

    // Prepare text
    final now = DateTime.now();
    final formatter = DateFormat(settings.dateFormat);
    final text = formatter.format(now);

    final textStyle = TextStyle(
      color: Color(settings.colorValue).withOpacity(settings.opacity),
      fontSize: settings.fontSize,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.6),
          offset: const Offset(1, 1),
          blurRadius: 2,
        ),
      ],
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final imgWidth = uiImage.width.toDouble();
    final imgHeight = uiImage.height.toDouble();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    double x, y;
    const margin = 20.0;

    switch (settings.position) {
      case 'topLeft':
        x = margin;
        y = margin;
        break;
      case 'topRight':
        x = imgWidth - textWidth - margin;
        y = margin;
        break;
      case 'bottomLeft':
        x = margin;
        y = imgHeight - textHeight - margin;
        break;
      case 'center':
        x = (imgWidth - textWidth) / 2;
        y = (imgHeight - textHeight) / 2;
        break;
      case 'bottomRight':
      default:
        x = imgWidth - textWidth - margin;
        y = imgHeight - textHeight - margin;
        break;
    }

    // Draw background if enabled
    if (settings.showBackground) {
      final bgPaint = Paint()
        ..color = Color(settings.backgroundColorValue);
      final padding = 8.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - padding,
            y - padding,
            textWidth + padding * 2,
            textHeight + padding * 2,
          ),
          const Radius.circular(6),
        ),
        bgPaint,
      );
    }

    textPainter.paint(canvas, Offset(x, y));

    final picture = recorder.endRecording();
    final stampedImage = await picture.toImage(uiImage.width, uiImage.height);
    final byteData = await stampedImage.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // Save to temp file
    final tempDir = await getTemporaryDirectory();
    final fileName = 'stamped_${DateTime.now().millisecondsSinceEpoch}.png';
    final outFile = File(p.join(tempDir.path, fileName));
    await outFile.writeAsBytes(pngBytes);

    return outFile;
  }
}
