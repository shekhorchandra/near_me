import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerGenerator {
  static Future<BitmapDescriptor> svgToBitmapDescriptor({
    required String svgString,
    required Size size,
    required LinearGradient gradient,
    required IconData icon,
    required String badgeLabel,
    required LinearGradient badgeGradient,
    Color iconColor = Colors.white,
  }) async {
    // 1. INCREASE PADDING: More room for the badge to overflow top/left
    const double badgeOverflow = 60.0; // Increased padding
    final Size canvasSize = Size(size.width + badgeOverflow, size.height + badgeOverflow);

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Main marker offset (shifts the pin right and down to make room for badge)
    final double markerOffsetX = badgeOverflow * 0.7;
    final double markerOffsetY = badgeOverflow * 0.7;
    final Rect markerRect = Rect.fromLTWH(markerOffsetX, markerOffsetY, size.width, size.height);

    // ── 2. Load & Draw SVG Pin ──────────────────────────────────────────────
    final SvgLoader loader = SvgStringLoader(svgString);
    final PictureInfo pictureInfo = await vg.loadPicture(loader, null);

    final double scaleX = size.width / pictureInfo.size.width;
    final double scaleY = size.height / pictureInfo.size.height;

    // Draw Pin shape with Gradient
    canvas.saveLayer(markerRect, Paint());
    canvas.save();
    canvas.translate(markerOffsetX, markerOffsetY);
    canvas.scale(scaleX, scaleY);
    canvas.drawPicture(pictureInfo.picture);
    canvas.restore();

    final gradientPaint = Paint()
      ..shader = gradient.createShader(markerRect)
      ..blendMode = ui.BlendMode.srcIn;
    canvas.drawRect(markerRect, gradientPaint);
    canvas.restore();

    // ── 3. Draw Belly Icon (Center of Pin) ──────────────────────────────────
    final double bellyIconSize = size.width * 0.6; // Increased size
    final bellyPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: bellyIconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: iconColor,
        ),
      )
      ..layout();

    // Adjusted Y-offset to sit in the "head" of the pin
    bellyPainter.paint(
      canvas,
      Offset(
        markerOffsetX + (size.width - bellyPainter.width) / 2,
        markerOffsetY + (size.height * 0.45 - bellyPainter.height / 2),
      ),
    );

    // ── 4. Draw Badge Pill (Top-Left) ───────────────────────────────────────
    if (badgeLabel != "Other") {
      const double badgeFontSize = 32.0; // Increased font size
      const double badgeIconSize = 32.0; // Increased icon size
      const double badgeHeight = 60.0; // Taller pill
      const double pillHorizontalPadding = 15.0; // Wider pill ends

      final labelPainter = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
          text: badgeLabel,
          style: const TextStyle(
            fontSize: badgeFontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        )
        ..layout();

      // Calculate total width based on content
      final double pillWidth =
          (badgeHeight * 0.8) + labelPainter.width + (pillHorizontalPadding * 2);

      // Position: Move it HIGHER (y) and FURTHER LEFT (x)
      final double pillLeft = markerOffsetX - 35;
      final double pillTop = markerOffsetY - 25;

      final Rect pillRect = Rect.fromLTWH(pillLeft, pillTop, pillWidth, badgeHeight);
      final RRect pillRRect = RRect.fromRectAndRadius(
        pillRect,
        const Radius.circular(badgeHeight / 2),
      );

      // Draw Pill Background with Shadow for better visibility
      canvas.drawRRect(
        pillRRect.shift(const Offset(0, 3)),
        Paint()
          ..color = Colors.black26
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      final badgePaint = Paint()..shader = badgeGradient.createShader(pillRect);
      canvas.drawRRect(pillRRect, badgePaint);

      // Draw Badge Icon
      final badgeIconPainter = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: badgeIconSize,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: Colors.white,
          ),
        )
        ..layout();

      badgeIconPainter.paint(
        canvas,
        Offset(
          pillLeft + (badgeHeight - badgeIconPainter.width) / 2 + 5,
          pillTop + (badgeHeight - badgeIconPainter.height) / 2,
        ),
      );

      // Draw Badge Label
      labelPainter.paint(
        canvas,
        Offset(pillLeft + badgeHeight + 2, pillTop + (badgeHeight - labelPainter.height) / 2),
      );
    }

    // ── 5. Finalize ──────────────────────────────────────────────────────────
    final ui.Image image = await pictureRecorder.endRecording().toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );

    final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
