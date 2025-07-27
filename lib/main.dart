import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_chatbot/helper/pref.dart';
import 'package:flutter_ai_chatbot/screen/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
    
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),);
  }
}