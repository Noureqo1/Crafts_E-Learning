import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/onboard.dart';
import '/widgets/custom_btn.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PageController();
    final mq = MediaQuery.sizeOf(context);
    final list = [
      //onboarding 1
      Onboard(
          title: 'Learn A New Craft Or Skill',
          subtitle:
              'This could your chance to share your craft or learn a new one ',
          lottie: 'Learn'),

      //onboarding 2
       Onboard(
        title: 'Imagination to Reality',
        lottie: 'Craft',
        subtitle:
            'Create your own work & let your creativity shine, Create something for you & others to enjoy!',
      ),
        //onboarding 3
       Onboard(
        title: 'Show & Reality Your Work',
        lottie: 'Sell',
        subtitle:
            'Show your work & let others enjoy it, List your work to sell it on our platform!',
      ),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: c,
        itemCount: list.length,
        itemBuilder: (ctx, ind) {
          final isLast = ind == list.length - 1;

          return Column(
            children: [
              //lottie
              Lottie.asset('assets/animations/${list[ind].lottie}.json',
                  height: mq.height * .6, width: isLast ? mq.width * .7 : null),

              //title
              Text(
                list[ind].title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5),
              ),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //subtitle
              SizedBox(
                width: mq.width * .7,
                child: Text(
                  list[ind].subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.5,
                      letterSpacing: .5,
                      color: Colors.grey,
                ),
              ),
              ),

              const Spacer(),

              //dots

              Wrap(
                spacing: 10,
                children: List.generate(
                    list.length,
                    (i) => Container(
                          width: i == ind ? 15 : 10,
                          height: 8,
                          decoration: BoxDecoration(
                              color: i == ind ? Colors.blue : Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                        )),
              ),

              const Spacer(),

              //button
              CustomBtn(
                  onTap: () {
                    if (isLast) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()));
                    } else {
                      c.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.ease);
                    }
                  },
                  text: isLast ? 'Finish' : 'Next'),

              const Spacer(flex: 2),
            ],
          );
        },
      ),
    );
  }
}