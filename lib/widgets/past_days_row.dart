import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodflow/providers/mood_provider.dart';
import '../models/mood.dart';
import 'mood_face_painter.dart';
import '../theme.dart';

class PastDaysRow extends ConsumerWidget {
  const PastDaysRow({super.key});

  String _getWeekdayString(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  String _getMonthString(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return months[month - 1];
  }

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider); // 👈 SOURCE OF TRUTH

    final today = DateTime.now();

    final last7Days = List.generate(7, (i) {
      return DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i + 1));
    }).reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past 7 Days',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.12;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final date = last7Days[index];

                    final mood = moods.firstWhere(
                      (m) =>
                          m.date.year == date.year &&
                          m.date.month == date.month &&
                          m.date.day == date.day,
                      orElse: () => DailyMood(
                        date: date,
                        mood: Mood.neutral,
                      ),
                    );

                    final dayStr = _getWeekdayString(date.weekday);

                    final dateStr =
                        '${_getMonthString(date.month)} ${date.day}';

                    return _DayCard(
                      day: dayStr,
                      date: dateStr,
                      mood: mood.mood,
                      isToday: false,
                      width: cardWidth,
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
class _DayCard extends StatefulWidget {
  final String day;
  final String date;
  final Mood mood;
  final bool isToday;
  final double width;

  const _DayCard({
    required this.day,
    required this.date,
    required this.mood,
    required this.width,
    this.isToday = false,
  });

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;

  late final AnimationController controller =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onHover(bool value) {
    setState(() => isHovered = value);

    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = max(80, (widget.width * 1.1)).toDouble();
    final faceSize = widget.width * 0.35;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final scale = 1 + (controller.value * 0.06);
          final elevation = 6 + (controller.value * 10);

          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: height,
              decoration: BoxDecoration(
                color: widget.isToday
                    ? const Color(0xFFF7E6E0)
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(widget.width * 0.25),
                border: widget.isToday
                    ? Border.all(
                        color: AppTheme.primaryAction.withAlpha(51),
                        width: 1.5,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.cardShadow.withOpacity(
                      isHovered ? 0.35 : 0.15,
                    ),
                    blurRadius: elevation,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.day,
                    style: TextStyle(
                      fontSize:
                          (widget.width * 0.14).clamp(9.0, 14.0),
                      fontWeight: FontWeight.bold,
                      color: widget.isToday
                          ? AppTheme.primaryAction
                          : AppTheme.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: height * 0.1),

                  /// 🔥 ANIMATED FACE
                  AnimatedScale(
                    scale: isHovered ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    child: SizedBox(
                      width: faceSize,
                      height: faceSize,
                      child: CustomPaint(
                        painter: MoodFacePainter(
                          mood: widget.mood,
                          // 👇 optional enhancement if you extend painter later
                          animate: isHovered,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.1),

                  Text(
                    widget.date,
                    style: TextStyle(
                      fontSize:
                          (widget.width * 0.14).clamp(9.0, 14.0),
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}