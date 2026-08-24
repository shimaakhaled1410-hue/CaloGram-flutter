import 'package:calogram_flutter/core/widgets/custom_confirm_dialog.dart';
import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_state.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'widgets/link_account_dialog.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_summary_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (context) => sl<AuthCubit>()),
      ],
      child: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is LogoutSuccessState) {
          context.go(AppRoutes.loginScreen);
        } else if (authState is LinkAccountSuccessState) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Account linked successfully!',
          );
          context.read<ProfileCubit>().loadProfile();
        }
      },
      builder: (context, authState) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final bool isGuest =
            (currentUser?.isAnonymous ?? false) &&
            authState is! LinkAccountSuccessState;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'My Profile',
              style: AppTextStyles.font20BoldWhite.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              if (profileState is ProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(color: primaryAccent),
                );
              }

              if (profileState is ProfileLoaded ||
                  profileState is ProfileUpdatedSuccess) {
                final profile = profileState is ProfileLoaded
                    ? profileState.profile
                    : (profileState as ProfileUpdatedSuccess).profile;

                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surface,
                              border: Border.all(
                                color: primaryAccent.withValues(alpha: 0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryAccent.withValues(alpha: 0.2),
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
                                color: primaryAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            profile.name,
                            style: AppTextStyles.font20BoldWhite.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: primaryAccent.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  profile.bmiCategory,
                                  style: AppTextStyles.font14SemiBoldLime
                                      .copyWith(color: primaryAccent),
                                ),
                              ),
                              if (isGuest) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Guest Mode',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ProfileSummaryCard(profile: profile),
                    const SizedBox(height: 24),
                    if (isGuest) ...[
                      ProfileMenuItem(
                        icon: Icons.cloud_upload_outlined,
                        title: 'Link Your Guest Account',
                        subtitle: 'Save and backup your meals permanently',
                        iconColor: Colors.amber,
                        onTap: () => LinkAccountDialog.show(context),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ProfileMenuItem(
                      icon: Icons.edit_note_rounded,
                      title: 'Edit Personal Data & Goals',
                      subtitle: 'Update weight, macros, and targets',
                      iconColor: primaryAccent,
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
                      iconColor: isDark ? Colors.white70 : Colors.black54,
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
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    CustomConfirmDialog.show(
      context,
      title: 'Logout',
      content: 'Are you sure you want to sign out of your session?',
      confirmText: 'Logout',
      confirmButtonColor: const Color(0xFFEF4444),
      onConfirm: () => context.read<AuthCubit>().logout(),
    );
  }
}
