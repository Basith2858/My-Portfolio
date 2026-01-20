import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_web_plugins/url_strategy.dart'; // Add this if you want to remove hash
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Use PathUrlStrategy to remove the hash (#) from the URL on web
  // usePathUrlStrategy();

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}
