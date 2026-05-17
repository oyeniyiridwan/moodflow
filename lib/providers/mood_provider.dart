import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood.dart';

class MoodNotifier extends Notifier<Mood> {
  @override
  Mood build() => Mood.happy;

  void setMood(Mood mood) {
    state = mood;
  }
}

final moodProvider = NotifierProvider<MoodNotifier, Mood>(() {
  return MoodNotifier();
});
