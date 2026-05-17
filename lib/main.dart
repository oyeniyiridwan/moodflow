import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/mood_provider.dart';
import 'theme.dart';
import 'widgets/dashboard_cards.dart';
import 'widgets/mood_selector.dart';
import 'widgets/past_days_row.dart';

void main() {
  runApp(const ProviderScope(child: MoodFlowApp()));
}

class MoodFlowApp extends StatelessWidget {
  const MoodFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainDashboard(),
    );
  }
}

/// RESPONSIVE HELPER
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(moodProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
            ? 40.0
            : screenWidth * 0.12;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: isMobile,
        onPressed: () {},
        backgroundColor: AppTheme.primaryAction,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 2000),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isMobile ? 24 : 48,
            ),
            children: [
              /// HEADER
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TOP SECTION
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.bubble_chart,
                                      color: AppTheme.primaryAction,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'MoodFlow',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color:
                                                      AppTheme.primaryAction,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Track how you feel, one day at a time.',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  AppTheme.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                /// BOTTOM SECTION
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .primaryActionLight,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons
                                                  .local_fire_department,
                                              color:
                                                  AppTheme.primaryAction,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                '7 Day Streak',
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppTheme
                                                      .primaryAction,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.notifications_none,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            )

                          /// TABLET + DESKTOP
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bubble_chart,
                                      color: AppTheme.primaryAction,
                                      size: isTablet ? 30 : 34,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MoodFlow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: AppTheme
                                                    .primaryAction,
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: isTablet
                                                    ? 24
                                                    : 28,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Track how you feel, one day at a time.',
                                          style: TextStyle(
                                            color: AppTheme
                                                .textSecondary,
                                            fontSize:
                                                isTablet ? 12 : 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                        horizontal:
                                            isTablet ? 14 : 18,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .primaryActionLight,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .local_fire_department,
                                            color: AppTheme
                                                .primaryAction,
                                            size:
                                                isTablet ? 16 : 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '7 Day Streak',
                                            style: TextStyle(
                                              color: AppTheme
                                                  .primaryAction,
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: isTablet
                                                  ? 12
                                                  : 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          isTablet ? 14 : 18,
                                    ),
                                    const Icon(
                                      Icons.notifications_none,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                      SizedBox(
                        height: isMobile ? 40 : 64,
                      ),
                    ],
                  );
                },
              ),

              /// HERO SECTION
              Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Text(
                        'How are you feeling today?',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              fontSize: isMobile
                                  ? 34
                                  : isTablet
                                      ? 48
                                      : 64,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: isMobile ? 12 : 16,
                      ),
                      Text(
                        'Take a moment to check in with yourself. Your emotional journey matters.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? 14 : 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 32 : 48),

              /// MOOD SELECTOR
              MoodSelector(
                selectedMood: selectedMood,
                onMoodSelected: (mood) {
                  ref
                      .read(moodProvider.notifier)
                      .setMood(mood);
                },
              ),

              SizedBox(height: isMobile ? 40 : 48),

              /// LOG ENTRY
              Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 700),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 18 : 24,
                      vertical: isMobile ? 18 : 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.logBackground,
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(12),
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      AppTheme.logIconBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Logged at 10:45 AM',
                                style: TextStyle(
                                  color: AppTheme
                                      .logIconBackground,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 8),
                              const Text(
                                '"Feeling great after morning yoga and a fresh coffee."',
                                style: TextStyle(
                                  color:
                                      AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontStyle:
                                      FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(12),
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      AppTheme.logIconBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 24),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      'Logged at 10:45 AM',
                                      style: TextStyle(
                                        color: AppTheme
                                            .logIconBackground,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '"Feeling great after morning yoga and a fresh coffee."',
                                      style: TextStyle(
                                        color: AppTheme
                                            .textPrimary,
                                        fontSize: 16,
                                        fontStyle:
                                            FontStyle
                                                .italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 40 : 64),

              /// DASHBOARD
              const DashboardCards(),

              SizedBox(height: isMobile ? 40 : 64),

              /// PAST DAYS
              const PastDaysRow(),

              SizedBox(height: isMobile ? 80 : 100),
            ],
          ),
        ),
      ),
    );
  }
}