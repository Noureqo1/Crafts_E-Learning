import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ai_chatbot/helper/global.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_chatbot/helper/pref.dart';
import 'package:flutter_ai_chatbot/screens/splash_screen.dart';
import 'package:flutter_ai_chatbot/services/course_service.dart';
import 'package:flutter_ai_chatbot/services/localization_service.dart';
import 'package:flutter_ai_chatbot/services/marketplace_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
  );
  
  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blue[800],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  await Pref.initialize();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarketplaceService()),
        ChangeNotifierProvider(create: (_) => CourseService()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        translations: LocalizationService(),
        locale: Pref.isEnglish ? const Locale('en', 'US') : const Locale('ar', 'SA'),
        fallbackLocale: const Locale('en', 'US'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        home: const SplashScreen(),
      ),
    );
  }
}