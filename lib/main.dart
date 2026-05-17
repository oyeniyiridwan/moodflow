import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodflow/theme.dart';
import 'package:moodflow/widgets/dashboard.dart';

void main() {
  runApp(const ProviderScope(child: MoodFlowApp()));
}

class MoodFlowApp extends StatelessWidget {
  const MoodFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
    scrollbars: false,
  ),
      title: 'MoodFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const Dashboard(),
    );
  }
}

