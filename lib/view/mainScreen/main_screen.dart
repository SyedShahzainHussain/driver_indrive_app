import 'package:flutter/material.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:uber_clone_app/view/profile_screen/profilescreen.dart';
import 'package:uber_clone_app/view/rate_driver_screen/rate_driver_screen.dart';
import 'package:uber_clone_app/view/tapPages/earning_tab.dart';
import 'package:uber_clone_app/view/tapPages/home_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  onItemPress(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTapPage(),
          EarningTapPage(),
          RateDriverScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ratings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: AppColors.whiteColor,
        backgroundColor: AppColors.blackColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        currentIndex: selectedIndex,
        enableFeedback: true,
        onTap: onItemPress,
      ),
    );
  }
}
