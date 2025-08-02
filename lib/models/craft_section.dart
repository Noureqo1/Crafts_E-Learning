import 'package:flutter/material.dart';

enum CraftSection { aiChatBot, viewCourses, marketPlace }

extension MyCraftSection on CraftSection {
  //title
  String get title => switch (this) {
        CraftSection.aiChatBot => 'AI ChatBot',
        CraftSection.viewCourses => 'View Courses',
        CraftSection.marketPlace => 'Market Place',
      };

  //lottie
  String get lottie => switch (this) {
        CraftSection.aiChatBot => 'ai_hand_waving.json',
        CraftSection.viewCourses => "Learn.json",
        CraftSection.marketPlace => 'Sell.json',
      };

  //for alignment
  bool get leftAlign => switch (this) {
        CraftSection.aiChatBot => true,
        CraftSection.viewCourses => false,
        CraftSection.marketPlace => true,
      };

  //for padding
  EdgeInsets get padding => switch (this) {
        CraftSection.aiChatBot => EdgeInsets.zero,
        CraftSection.viewCourses => const EdgeInsets.all(20),
        CraftSection.marketPlace => EdgeInsets.zero,
      };


  //for navigation
  // VoidCallback get onTap => switch (this) {
  //     };
}