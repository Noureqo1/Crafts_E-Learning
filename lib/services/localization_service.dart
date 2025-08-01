import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static final locale = const Locale('en', 'US');
  static final fallbackLocale = const Locale('ar', 'SA');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_name': 'AI Chatbot',
          'craft': 'Craft',
          'learn': 'Learn',
          'clips': 'Clips',
          'settings': 'Settings',
          'dark_mode': 'Dark Mode',
          'language': 'Language',
          'english': 'English',
          'arabic': 'العربية',
        },
        'ar_SA': {
          'app_name': 'روبوت الدردشة',
          'craft': 'الحرف',
          'learn': 'تعلم',
          'clips': 'مقاطع',
          'settings': 'الإعدادات',
          'dark_mode': 'الوضع المظلم',
          'language': 'اللغة',
          'english': 'English',
          'arabic': 'العربية',
        },
      };

  void changeLocale(String langCode) {
    final locale = _getLocale(langCode);
    Get.updateLocale(locale);
  }

  Locale _getLocale(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return const Locale('ar', 'SA');
      case 'en':
      default:
        return const Locale('en', 'US');
    }
  }
}
