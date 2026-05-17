import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodflow/providers/mood_provider.dart';
import '../models/mood.dart';
import 'mood_face_painter.dart';
import '../theme.dart';
class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final today = DateTime.now();

    final todayMood = moods.firstWhere(
      (m) =>
          m.date.year == today.year &&
          m.date.month == today.month &&
          m.date.day == today.day,
      orElse: () => DailyMood(
        date: today,
        mood: Mood.neutral,
      ),
    ).mood;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.14;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Mood.values.map((mood) {
            final isSelected = mood == todayMood;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  ref.read(moodProvider.notifier).setMood(mood);
                },
                child: _MoodCard(
                  mood: mood,
                  isSelected: isSelected,
                  width: cardWidth,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
class _MoodCard extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final double width;

  const _MoodCard({
    required this.mood,
    required this.isSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final height = max(75,(width * 0.8)).toDouble(); // Flatter aspect ratio
    final faceSize = width * 0.25; // Adjusted face size

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withAlpha(153),
            borderRadius: BorderRadius.circular(width * 0.25),
            border: Border.all(
              color: isSelected ? const Color(0xFFC06C5D) : Colors.transparent,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cardShadow,
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: faceSize,
                height: faceSize,
                child: CustomPaint(
                  painter: MoodFacePainter(mood: mood),
                ),
              ),
              SizedBox(height: height * 0.1),
              Text(
                mood.name,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryAction : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: (width * 0.12).clamp(10.0, 16.0),
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.primaryAction,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.background, width: 3),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: (width * 0.12).clamp(10.0, 18.0),
              ),
            ),
          ),
      ],
    );
  }
}
