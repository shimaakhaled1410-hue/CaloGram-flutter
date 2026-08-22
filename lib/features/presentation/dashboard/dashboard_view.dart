import 'package:calogram_flutter/core/services/service_locator.dart';
import 'package:calogram_flutter/core/widgets/custom_bottom_nav_bar.dart';
import 'package:calogram_flutter/features/presentation/dashboard/widgets/today_tab_view.dart';
import 'package:calogram_flutter/features/presentation/manager/dashboard/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    TodayTabView(),
    Center(
      child: Text('Fridge & AI Chef', style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text('Voice Logger', style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text('Profile & Settings', style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text(
        'Food Scanner & Camera',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..getDashboardData(),
      child: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _currentIndex,
          onItemTapped: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
