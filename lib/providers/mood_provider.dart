import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood.dart';

class MoodNotifier extends Notifier<List<DailyMood>> {
  @override
  List<DailyMood> build() {
    final today = DateTime.now();

    final mockMoods = [
      Mood.happy,
      Mood.excited,
      Mood.sad,
      Mood.neutral,
      Mood.excited,
      Mood.happy,
      Mood.neutral,
    ];

    return List.generate(7, (index) {
      final date = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: index + 1)); // past 7 days

      return DailyMood(
        date: date,
        mood: mockMoods[index],
      );
    }).reversed.toList();
  }

  void setMood(Mood mood) {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);

    final updated = [...state];

    final index = updated.indexWhere((m) =>
        m.date.year == normalized.year &&
        m.date.month == normalized.month &&
        m.date.day == normalized.day);

    if (index >= 0) {
      updated[index] = DailyMood(date: normalized, mood: mood);
    } else {
      updated.add(DailyMood(date: normalized, mood: mood));
    }

    state = updated;
  }

  List<DailyMood> last7Days() {
    return state.take(7).toList();
  }
}

final moodProvider = NotifierProvider<MoodNotifier, List<DailyMood>>(
  MoodNotifier.new,
);