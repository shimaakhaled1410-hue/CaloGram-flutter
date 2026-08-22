import 'package:calogram_flutter/features/presentation/food_scanner/food_scanner_view.dart';
import 'package:calogram_flutter/features/presentation/voice_logger/voice_logger_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../manager/dashboard/dashboard_cubit.dart';
import 'widgets/today_tab_view.dart';

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
    VoiceLoggerView(),
    Center(
      child: Text('Profile & Settings', style: TextStyle(color: Colors.white)),
    ),
    FoodScannerView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..getDashboardData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: _tabs[_currentIndex],
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: (index) {
                setState(() => _currentIndex = index);

                if (index == 0) {
                  context.read<DashboardCubit>().getDashboardData();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
