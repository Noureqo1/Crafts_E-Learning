import 'package:flutter/material.dart';
import 'package:flutter_ai_chatbot/helper/global.dart';
import 'package:flutter_ai_chatbot/screen/home_screen.dart';
import 'package:flutter_ai_chatbot/widgets/custom_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  });
} 

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      //body
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            //for adding some space
            const Spacer(flex: 2),

            //logo
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(mq.width * .05),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: mq.width * .4,
                ),
              ),
            ),

            //for adding some space
            const Spacer(),

            //lottie loading
            const CustomLoading(),

            //for adding some space
            const Spacer(),
          ],
        ),
       ),
    );
  }
}