import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'widgets/food_scanner_empty_view.dart';
import 'widgets/food_scanner_loading_view.dart';
import 'widgets/food_scanner_result_view.dart';

class FoodScannerView extends StatelessWidget {
  const FoodScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FoodScannerCubit>(),
      child: const _FoodScannerContent(),
    );
  }
}

class _FoodScannerContent extends StatelessWidget {
  const _FoodScannerContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Food Scanner',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<FoodScannerCubit, FoodScannerState>(
        listener: (context, state) {
          if (state is FoodScannerSavedSuccessState) {
            CustomSnackBar.showSuccess(
              context,
              message: 'Meal logged successfully!',
            );
          } else if (state is FoodScannerErrorState) {
            CustomSnackBar.showError(context, message: state.errMessage);
          }
        },
        builder: (context, state) {
          if (state is FoodScannerLoadingState ||
              state is FoodScannerSavingState) {
            return const FoodScannerLoadingView();
          }

          if (state is FoodScannerSuccessState) {
            return FoodScannerResultView(food: state.food, image: state.image);
          }

          return const FoodScannerEmptyView();
        },
      ),
    );
  }
}
