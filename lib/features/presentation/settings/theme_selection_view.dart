import 'package:calogram_flutter/features/presentation/settings/widgets/theme_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../manager/theme/theme_cubit.dart';

class ThemeSelectionView extends StatelessWidget {
  const ThemeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Theme',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, currentMode) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              ThemeOptionCard(
                title: 'System Default',
                subtitle: 'Match your device light/dark appearance',
                icon: Icons.phone_android_rounded,
                isSelected: currentMode == ThemeMode.system,
                onTap: () =>
                    context.read<ThemeCubit>().changeTheme(ThemeMode.system),
              ),
              const SizedBox(height: 12),
              ThemeOptionCard(
                title: 'Dark Theme',
                subtitle: 'Deep slate background with neon accents',
                icon: Icons.dark_mode_rounded,
                isSelected: currentMode == ThemeMode.dark,
                onTap: () =>
                    context.read<ThemeCubit>().changeTheme(ThemeMode.dark),
              ),
              const SizedBox(height: 12),
              ThemeOptionCard(
                title: 'Light Theme',
                subtitle: 'Clean light aesthetics and soft contrast',
                icon: Icons.light_mode_rounded,
                isSelected: currentMode == ThemeMode.light,
                onTap: () =>
                    context.read<ThemeCubit>().changeTheme(ThemeMode.light),
              ),
            ],
          );
        },
      ),
    );
  }
}
