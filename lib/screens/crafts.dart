import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../models/craft_section.dart';
import 'ai_chat_screen.dart';
import 'courses_screen.dart';
import 'marketplace_screen.dart';

class CraftsScreen extends StatelessWidget {
  const CraftsScreen({super.key});

  void _navigateToSection(CraftSection section) {
    switch (section) {
      case CraftSection.aiChatBot:
        Get.to(() => const AiChatScreen());
        break;
      case CraftSection.viewCourses:
        Get.to(() => const CoursesScreen());
        break;
      case CraftSection.marketPlace:
        Get.to(() => const MarketplaceScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crafts & Learning'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: CraftSection.values.map((section) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _navigateToSection(section),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      child: Lottie.asset(
                        'assets/animations/${section.lottie}',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getSectionDescription(section),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getSectionDescription(CraftSection section) {
    switch (section) {
      case CraftSection.aiChatBot:
        return 'Get help from our AI assistant for any questions';
      case CraftSection.viewCourses:
        return 'Browse and enroll in various courses';
      case CraftSection.marketPlace:
        return 'Buy and sell craft items in the marketplace';
    }
  }
}



