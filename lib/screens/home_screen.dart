import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/pref.dart';
import '../services/localization_service.dart';
import 'crafts.dart';
import 'learn.dart';
import 'clips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxBool _isDarkMode = Pref.isDarkMode.obs;
  
  // Current selected index for bottom navigation
  int _currentIndex = 0;
  
  // List of screens to navigate between
  final List<Widget> _screens = [
    const CraftsScreen(),
    const LearnScreen(),
    const ClipsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
  }

  // Toggle language
  void _changeLanguage() {
    final newLocale = Pref.isEnglish ? 'ar' : 'en';
    Pref.isEnglish = !Pref.isEnglish;
    LocalizationService().changeLocale(newLocale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //initializing device size
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          // Language switcher
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _changeLanguage,
            tooltip: 'language'.tr,
          ),
          // Theme switcher
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              _isDarkMode.value = !_isDarkMode.value;
              Pref.isDarkMode = _isDarkMode.value;
              Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
              Get.forceAppUpdate();
            },
            icon: Obx(
              () => Icon(
                _isDarkMode.value
                    ? Icons.brightness_2_rounded
                    : Icons.brightness_5_rounded,
                size: 26,
              ),
            ),
            tooltip: 'dark_mode'.tr,
          ),
        ],
      ),
      
      // Main content
      body: _screens[_currentIndex],
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.handyman),
            label: 'craft'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: 'learn'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.video_library),
            label: 'clips'.tr,
          ),
        ],
      ),
    );
  }
}