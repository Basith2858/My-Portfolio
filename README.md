# Flutter Pricing/Portfolio App

A premium, animated portfolio application built with Flutter, Riverpod, and GoRouter.

## Features
- **Responsive Design**: Works on Mobile, Tablet, and Desktop.
- **Animations**: Smooth entrance and interaction animations using `flutter_animate`.
- **Theming**: Light and Dark mode with persistence.
- **Project Showcase**: Detailed project view with links.
- **Contact Form**: Integrated mailto functionality.

## Getting Started

### Prerequisites
- Flutter SDK (3.10+)
- Dart SDK

### Installation

1. **Get Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run on Mobile***
   ```bash
   flutter run
   ```

3. **Run on Web**
   ```bash
   flutter run -d chrome
   ```

### Building

- **Android APK**: `flutter build apk --release`
- **Web**: `flutter build web --release`

## Project Structure
- `lib/data/portfolio_data.dart`: **Edit this file** to update your content (Bio, Projects, Skills).
- `lib/theme/app_theme.dart`: Customize colors and fonts here.
- `lib/widgets/sections/`: Contains the UI for each section of the home page.

## SEO (Web)
To improve SEO, update the `<title>` and `<meta>` tags in `web/index.html`.
