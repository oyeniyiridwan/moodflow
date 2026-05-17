# MoodFlow Dashboard

MoodFlow is a beautifully designed, highly responsive Flutter Web application for tracking and visualizing daily moods. It features a soft, premium UI aesthetic, smooth animations, and custom canvas-drawn graphics to provide a highly interactive journaling experience.

## ✨ Features

- **Dynamic State Management:** Utilizes `flutter_riverpod` (v3+) for seamless, robust state management, tracking your mood selections across the dashboard.
- **Custom Canvas Graphics:** Employs Flutter's `CustomPainter` to procedurally draw vector-based mood expressions (Excited, Happy, Neutral, Sad, Angry). This eliminates dependency on external image assets and ensures perfect scaling on any device.
- **Animated Trend Line Chart:** A completely custom-built Weekly Trend Chart (`CustomPainter`) featuring smooth `cubicTo` bezier curves and beautiful linear gradients to visualize mood history over the past 7 days. Animations trigger gracefully upon state changes.
- **Fluid Responsiveness:** Built from the ground up for Mobile, Tablet, and Desktop. The layout uses flexible grids, `LayoutBuilder`, and a centralized `Responsive` utility to fluidly resize cards, typography, and spacing relative to the screen width. 
- **Interactive UI Elements:** Beautiful hover interactions, dynamic drop shadows (`AnimatedScale`, `AnimatedContainer`), and subtle scale effects provide a polished, tactile feel.
- **Aesthetic Theming:** Uses a soft, cream-based color palette with tailored shadows and curated colors to match modern, premium web application designs.
- **Real-time Data Syncing:** Features like the `PastDaysRow` automatically map against the central Riverpod data store to update "Today's" logged mood in real-time.

## 🛠 Tech Stack

- **Framework:** Flutter SDK (Web optimized)
- **Language:** Dart
- **State Management:** Riverpod (`flutter_riverpod` 3.x)
- **UI Components:** Material Design, `CustomPainter`, `AnimatedContainer`, `LayoutBuilder`

## 🚀 Getting Started

### Prerequisites
Make sure you have Flutter installed on your machine. You can verify your installation by running:
```bash
flutter doctor
```

### Installation

1. Clone the repository:
```bash
git clone <repository_url>
cd moodflow
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run -d chrome
```

## 📂 Project Structure

- `lib/main.dart`: App entry point and primary responsive dashboard layout.
- `lib/theme.dart`: Centralized theme tokens, colors, and shadow definitions.
- `lib/models/mood.dart`: Data structures representing daily logs and mood enums.
- `lib/providers/mood_provider.dart`: Riverpod `NotifierProvider` managing the application state (mood history).
- `lib/widgets/`:
  - `mood_selector.dart`: Interactive top row for logging today's mood.
  - `dashboard_cards.dart`: Holds the Weekly Trend Chart (with `TrendLinePainter`) and Insight cards.
  - `past_days_row.dart`: Scrollable/Responsive horizontal row showing the past 7 days history with hover animations.
  - `mood_face_painter.dart`: The core `CustomPainter` drawing the various face expressions procedurally.
