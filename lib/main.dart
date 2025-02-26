import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/dependency_injection.dart';
import 'src/feature/app/presentation/app_root.dart';

late bool isChicken;
late bool isCreate;
late bool isDetailed;
late bool isHome;
late bool isTask;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencyInjection();

  final prefs = await SharedPreferences.getInstance();
  isChicken = prefs.getBool('isChicken') ?? false;
  isCreate = prefs.getBool('isCreate') ?? false;
  isDetailed = prefs.getBool('isDetailed') ?? false;
  isTask = prefs.getBool('isTask') ?? false;
  isHome = prefs.getBool('isHome') ?? false;
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const AppRoot(),
  );
}
