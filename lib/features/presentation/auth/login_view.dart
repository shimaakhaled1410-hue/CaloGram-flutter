import 'package:calogram_flutter/core/services/service_locator.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const Scaffold(body: LoginViewBody()),
    );
  }
}
