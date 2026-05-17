import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodFacePainter extends CustomPainter {
  final Mood mood;
  final bool animate;

  MoodFacePainter({required this.mood, this.animate = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final paint = Paint()
      ..color = getMoodColor(mood)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Draw face features
    final facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final faceFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    switch (mood) {
      case Mood.excited:
        _drawExcitedFace(canvas, size, facePaint);
        break;
      case Mood.happy:
        _drawHappyFace(canvas, size, facePaint, faceFill);
        break;
      case Mood.neutral:
        _drawNeutralFace(canvas, size, facePaint, faceFill);
        break;
      case Mood.sad:
        _drawSadFace(canvas, size, facePaint, faceFill);
        break;
      case Mood.angry:
        _drawAngryFace(canvas, size, facePaint, faceFill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.animate != animate || oldDelegate.mood != mood;
  }

  static Color getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.excited:
        return const Color(0xFFC95B4E);
      case Mood.happy:
        return const Color(0xFFFBC02D);
      case Mood.neutral:
        return const Color(0xFFE0E0E0);
      case Mood.sad:
        return const Color(0xFF8362D6);
      case Mood.angry:
        return const Color(0xFFBD1E1E);
    }
  }

  void _drawExcitedFace(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;

    // Left eye (u shape)
    final leftEyePath = Path()
      ..moveTo(w * 0.25, h * 0.35)
      ..quadraticBezierTo(w * 0.325, h * 0.45, w * 0.4, h * 0.35);
    canvas.drawPath(leftEyePath, paint);

    // Right eye (u shape)
    final rightEyePath = Path()
      ..moveTo(w * 0.6, h * 0.35)
      ..quadraticBezierTo(w * 0.675, h * 0.45, w * 0.75, h * 0.35);
    canvas.drawPath(rightEyePath, paint);

    // Smile
    final smilePath = Path()
      ..moveTo(w * 0.3, h * 0.6)
      ..quadraticBezierTo(w * 0.5, h * 0.8, w * 0.7, h * 0.6);
    canvas.drawPath(smilePath, paint);
  }

  void _drawHappyFace(
    Canvas canvas,
    Size size,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Dot eyes
    canvas.drawCircle(Offset(w * 0.35, h * 0.4), w * 0.06, fillPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.4), w * 0.06, fillPaint);

    // Smile
    final smilePath = Path()
      ..moveTo(w * 0.35, h * 0.6)
      ..quadraticBezierTo(w * 0.5, h * 0.75, w * 0.65, h * 0.6);
    canvas.drawPath(smilePath, strokePaint);
  }

  void _drawNeutralFace(
    Canvas canvas,
    Size size,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Dot eyes
    canvas.drawCircle(Offset(w * 0.35, h * 0.4), w * 0.06, fillPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.4), w * 0.06, fillPaint);

    // Straight mouth
    canvas.drawLine(
      Offset(w * 0.35, h * 0.65),
      Offset(w * 0.65, h * 0.65),
      strokePaint,
    );
  }

  void _drawSadFace(
    Canvas canvas,
    Size size,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Dot eyes
    canvas.drawCircle(Offset(w * 0.35, h * 0.4), w * 0.06, fillPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.4), w * 0.06, fillPaint);

    // Sad mouth
    final mouthPath = Path()
      ..moveTo(w * 0.35, h * 0.7)
      ..quadraticBezierTo(w * 0.5, h * 0.6, w * 0.65, h * 0.7);
    canvas.drawPath(mouthPath, strokePaint);
  }

  void _drawAngryFace(
    Canvas canvas,
    Size size,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Dot eyes
    canvas.drawCircle(Offset(w * 0.35, h * 0.45), w * 0.06, fillPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.45), w * 0.06, fillPaint);

    // Angry eyebrows \ /
    canvas.drawLine(
      Offset(w * 0.25, h * 0.3),
      Offset(w * 0.4, h * 0.4),
      strokePaint,
    );
    canvas.drawLine(
      Offset(w * 0.75, h * 0.3),
      Offset(w * 0.6, h * 0.4),
      strokePaint,
    );

    // Angry mouth
    final mouthPath = Path()
      ..moveTo(w * 0.35, h * 0.75)
      ..quadraticBezierTo(w * 0.5, h * 0.65, w * 0.65, h * 0.75);
    canvas.drawPath(mouthPath, strokePaint);
  }
}
