import 'package:flutter/material.dart';
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
            children: [
              WeeklyTrendCard(),
              SizedBox(height: 20),
              InsightCard(),
            ],
          );
        }

        /// TABLET
        if (isTablet) {
          return const Column(
            children: [
              WeeklyTrendCard(),
              SizedBox(height: 24),
              InsightCard(),
            ],
          );
        }

        /// DESKTOP
        return const IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: WeeklyTrendCard(),
              ),
              SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: InsightCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WeeklyTrendCard extends StatelessWidget {
  const WeeklyTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return Container(
      padding: EdgeInsets.all(
        isMobile ? 20 : 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          isMobile ? 24 : 32,
        ),
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
          /// HEADER
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Trend',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'View Details >',
                        style: TextStyle(
                          color: AppTheme.primaryAction,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weekly Trend',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View Details >',
                        style: TextStyle(
                          color: AppTheme.primaryAction,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

          SizedBox(height: isMobile ? 24 : 32),

          /// CHART CONTAINER
          Container(
            height: isMobile
                ? 220
                : isTablet
                    ? 240
                    : 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(
                isMobile ? 20 : 24,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 24,
              vertical: isMobile ? 16 : 24,
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomPaint(
                    size: const Size(
                      double.infinity,
                      double.infinity,
                    ),
                    painter: TrendLinePainter(),
                  ),
                ),

                SizedBox(height: isMobile ? 12 : 16),

                /// DAYS ROW
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    ...[
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ].map(
                      (day) => Text(
                        day,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    final points = [
      Offset(0, h * 0.8),
      Offset(w * 1 / 6, h * 0.6),
      Offset(w * 2 / 6, h * 0.9),
      Offset(w * 3 / 6, h * 0.5),
      Offset(w * 4 / 6, h * 0.1),
      Offset(w * 5 / 6, h * 0.9),
      Offset(w, h * 0.2),
    ];

    path.moveTo(
      points[0].dx,
      points[0].dy,
    );

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
        colors: [
          Color(0xFFF7786B),
          Color(0xFF9B63CC),
          Color(0xFFC4A037),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromLTWH(0, 0, w, h),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
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
      padding: EdgeInsets.all(
        isMobile ? 20 : 32,
      ),
      decoration: BoxDecoration(
        color: AppTheme.insightBackground,
        borderRadius: BorderRadius.circular(
          isMobile ? 24 : 32,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontSize:
                          isMobile ? 22 : null,
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
                TextSpan(
                  text: 'You seem to be ',
                ),
                TextSpan(
                  text:
                      '30% more consistent\n',
                  style: TextStyle(
                    color:
                        AppTheme.primaryAction,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'with your positive moods when you log before noon.',
                ),
              ],
            ),
          ),

          SizedBox(height: isMobile ? 20 : 24),

          /// IMAGE
          ClipRRect(
            borderRadius:
                BorderRadius.circular(16),
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