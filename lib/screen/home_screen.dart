import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_chatbot/helper/global.dart';
import 'package:flutter_ai_chatbot/helper/pref.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

@override
void initState() {

  Pref.showOnboarding = false;
  super.initState();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
} 

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.sizeOf(context);

    return const Scaffold(
     body: Center(
      child: Text("welcome"),
       ),
    );
  }
}