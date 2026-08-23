import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_state.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_summary_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          context.go(AppRoutes.loginScreen);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('My Profile', style: AppTextStyles.font20BoldWhite),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryNeonLime,
                ),
              );
            }

            if (state is ProfileLoaded || state is ProfileUpdatedSuccess) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : (state as ProfileUpdatedSuccess).profile;

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: [
                  // --- Avatar & User Info ---
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cardDark,
                            border: Border.all(
                              color: AppColors.primaryNeonLime.withValues(
                                alpha: 0.6,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryNeonLime.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            profile.name.isNotEmpty
                                ? profile.name[0].toUpperCase()
                                : 'U',
                            style: AppTextStyles.font28BoldWhite.copyWith(
                              color: AppColors.primaryNeonLime,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          profile.name,
                          style: AppTextStyles.font20BoldWhite,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryNeonLime.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            profile.bmiCategory,
                            style: AppTextStyles.font14SemiBoldLime,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Profile Metrics Summary Card ---
                  ProfileSummaryCard(profile: profile),
                  const SizedBox(height: 24),

                  // --- Options List ---
                  ProfileMenuItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Edit Personal Data & Goals',
                    subtitle: 'Update weight, macros, and targets',
                    iconColor: AppColors.primaryNeonLime,
                    onTap: () async {
                      await context.push(AppRoutes.editProfileScreen);

                      if (context.mounted) {
                        context.read<ProfileCubit>().loadProfile();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'Theme and preferences',
                    iconColor: Colors.white70,
                    onTap: () {
                      context.push(AppRoutes.settingsScreen);
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out of your session',
                    iconColor: const Color(0xFFEF4444),
                    isDestructive: true,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              );
            }

            return Center(
              child: Text(
                'Failed to load profile',
                style: AppTextStyles.font14RegularMuted,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Logout', style: AppTextStyles.font18SemiBoldWhite),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.font14RegularMuted,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.font14RegularMuted),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
