import 'package:calogram_flutter/core/services/notification_helper.dart';
import 'package:calogram_flutter/core/services/notification_service.dart';
import 'package:calogram_flutter/features/presentation/food_scanner/food_scanner_view.dart';
import 'package:calogram_flutter/features/presentation/profile/profile_view.dart';
import 'package:calogram_flutter/features/presentation/smart_fridge/smart_fridge_view.dart';
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

class _DashboardViewState extends State<DashboardView>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    TodayTabView(),
    SmartFridgeView(),
    VoiceLoggerView(),
    ProfileView(),
    FoodScannerView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupForegroundNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationHelper.cancelForegroundTimers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setupForegroundNotifications();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _setupBackgroundNotifications();
    }
  }

  void _setupForegroundNotifications() {
    NotificationService.instance.cancelAllNotifications();
    NotificationHelper.syncForegroundTimers();
  }

  void _setupBackgroundNotifications() {
    NotificationHelper.cancelForegroundTimers();
    NotificationHelper.syncAllScheduledNotifications();
  }

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
