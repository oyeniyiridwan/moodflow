import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodflow/models/mood.dart';
import 'package:moodflow/providers/mood_provider.dart';
import '../theme.dart';

class DashboardCards extends StatelessWidget {
  const DashboardCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        /// MOBILE
        if (isMobile) {
          return const Column(
            children: [WeeklyTrendCard(), SizedBox(height: 20), InsightCard()],
          );
        }

        /// TABLET
        if (isTablet) {
          return const Column(
            children: [WeeklyTrendCard(), SizedBox(height: 24), InsightCard()],
          );
        }

        /// DESKTOP
        return const IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: WeeklyTrendCard()),
              SizedBox(width: 24),
              Expanded(flex: 1, child: InsightCard()),
            ],
          ),
        );
      },
    );
  }
}

class WeeklyTrendCard extends ConsumerWidget {
  const WeeklyTrendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider).reversed.take(7).toList().reversed.toList();
    //.take(7).toList();

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Trend', style: Theme.of(context).textTheme.titleLarge),

          SizedBox(height: isMobile ? 24 : 32),

          /// 🔥 Animated Chart Wrapper
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Container(
              key: ValueKey(
                moods.map((e) => e.mood).join(),
              ), // triggers animation
              height: isMobile
                  ? 220
                  : isTablet
                  ? 240
                  : 250,
              width: double.infinity,
              color: AppTheme.background,

              child: CustomPaint(painter: TrendLinePainter(moods: moods)),
            ),
          ),

          /// DAYS LABELS (sync with provider)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((m) {
              final d = m.date;
              final label = [
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun',
              ][d.weekday - 1];

              return Text(
                label,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TrendLinePainter extends CustomPainter {
  final List<DailyMood> moods;

  TrendLinePainter({required this.moods});

  double _map(Mood mood) {
    switch (mood) {
      case Mood.angry:
        return 0.2;
      case Mood.sad:
        return 0.4;
      case Mood.neutral:
        return 0.6;
      case Mood.happy:
        return 0.8;
      case Mood.excited:
        return 1.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final values = moods.map((m) => _map(m.mood)).toList();

    /// FIX: smooth animation-friendly interpolation
    final points = List.generate(values.length, (i) {
      return Offset(w * (i / (values.length - 1)), h * (1 - values[i]));
    });

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      path.cubicTo(
        p1.dx + (p2.dx - p1.dx) / 2,
        p1.dy,
        p1.dx + (p2.dx - p1.dx) / 2,
        p2.dy,
        p2.dx,
        p2.dy,
      );
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFF7786B), Color(0xFF9B63CC), Color(0xFFC4A037)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrendLinePainter oldDelegate) {
    /// 🔥 THIS enables animation on state change
    return oldDelegate.moods != moods;
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppTheme.insightBackground,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                color: AppTheme.primaryAction,
                size: isMobile ? 24 : 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Insight',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: isMobile ? 22 : null,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 20 : 24),

          /// INSIGHT TEXT
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: isMobile ? 14 : 16,
                height: 1.6,
                fontFamily: 'Inter',
              ),
              children: const [
                TextSpan(text: 'You seem to be '),
                TextSpan(
                  text: '30% more consistent\n',
                  style: TextStyle(
                    color: AppTheme.primaryAction,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'with your positive moods when you log before noon.',
                ),
              ],
            ),
          ),

          SizedBox(height: isMobile ? 20 : 24),

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=600&auto=format&fit=crop',
              height: isMobile
                  ? 180
                  : isTablet
                  ? 220
                  : 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
