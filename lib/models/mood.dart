enum Mood {
  excited,
  happy,
  neutral,
  sad,
  angry
}

extension MoodExtension on Mood {
  String get name {
    switch (this) {
      case Mood.excited: return 'Excited';
      case Mood.happy: return 'Happy';
      case Mood.neutral: return 'Neutral';
      case Mood.sad: return 'Sad';
      case Mood.angry: return 'Angry';
    }
  }
}
