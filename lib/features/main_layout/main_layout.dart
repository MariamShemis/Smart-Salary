import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/main_layout/home/presentation/view/home_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  List<Widget> get _pages => [
    HomeScreen(),
    const Center(child: Text('Reports Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return MainGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          extendBody: true,
          body: _pages[selectedIndex],
          bottomNavigationBar: _buildBottomAppBar1(),
        ),
      ),
    );
  }

  Widget _buildBottomAppBar1() {
    final List<Map<String, dynamic>> itemsData = [
      {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home},
      {
        'label': 'Daily Reports',
        'icon': Icons.insert_chart_outlined_rounded,
        'activeIcon': Icons.insert_chart_rounded,
      },
      {
        'label': 'Profile',
        'icon': Icons.person_outline_rounded,
        'activeIcon': Icons.person,
      },
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(40.r),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onTap,
        items: List.generate(itemsData.length, (index) {
          final isSelected = selectedIndex == index;
          return BottomNavigationBarItem(
            label: itemsData[index]['label'],
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: REdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorManager.primaryColor
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected
                    ? itemsData[index]['activeIcon']
                    : itemsData[index]['icon'],
                size: 22.sp,
                color: isSelected
                    ? ColorManager.secondary
                    : ColorManager.greyDark,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }
}
