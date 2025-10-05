import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/presentation/pages/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  final box = GetStorage();

  final List<Map<String, String>> onboardingData = [
  {
    "image": "assets/images/task_management.svg",
    "title": "Organize your day easily",
    "desc": "Add your tasks and prioritize them in simple and clear steps.",
  },
  {
    "image": "assets/images/reminder.svg",
    "title": "Don't forget your reminders",
    "desc": "Receive notifications at the right time to complete your tasks effectively.",
  },
  {
    "image": "assets/images/time_management.svg",
    "title": "Take control of your time",
    "desc": "Track your progress daily and see your achievements grow.",
  },
];


  void _nextPage() {
    if (currentPage == onboardingData.length - 1) {
      box.write('isFirstTime', false);
      Get.off(() => const HomePage());
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // هنا استخدمنا SvgPicture.asset
          SvgPicture.asset(
            data["image"]!,
            height: 220,
          ),
          const SizedBox(height: 40),
          Text(
            data["title"]!,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data["desc"]!,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemCount: onboardingData.length,
              itemBuilder: (_, i) => _buildPage(onboardingData[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.deepPurple
                        : Colors.deepPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _nextPage,
              child: Text(
                currentPage == onboardingData.length - 1
                    ? "Start"
                    : "Next",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
