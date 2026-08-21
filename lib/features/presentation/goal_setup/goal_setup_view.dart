import 'package:flutter/material.dart';
import 'widgets/goal_setup_view_body.dart';

class GoalSetupView extends StatelessWidget {
  const GoalSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoalSetupViewBody(),
    );
  }
}