import 'package:calogram_flutter/core/widgets/custom_gradient_button.dart';
import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/smart_fridge/smart_fridge_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/smart_fridge/smart_fridge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'widgets/ingredients_wrap_list.dart';
import 'widgets/recipe_card.dart';
import 'widgets/smart_fridge_input_field.dart';

class SmartFridgeView extends StatelessWidget {
  const SmartFridgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SmartFridgeCubit>(),
      child: const _SmartFridgeContent(),
    );
  }
}

class _SmartFridgeContent extends StatefulWidget {
  const _SmartFridgeContent();

  @override
  State<_SmartFridgeContent> createState() => _SmartFridgeContentState();
}

class _SmartFridgeContentState extends State<_SmartFridgeContent> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submitIngredient() {
    if (_inputController.text.trim().isNotEmpty) {
      context.read<SmartFridgeCubit>().addIngredient(_inputController.text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Smart Fridge',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SmartFridgeCubit, SmartFridgeState>(
        listener: (context, state) {
          if (state is SmartFridgeMealLoggedSuccess) {
            CustomSnackBar.showSuccess(
              context,
              message: '${state.mealTitle} added to Today\'s Log!',
            );
          } else if (state is SmartFridgeError) {
            CustomSnackBar.showError(context, message: state.errMessage);
          }
        },
        builder: (context, state) {
          final cubit = context.read<SmartFridgeCubit>();
          final ingredients = cubit.currentIngredients;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              SmartFridgeInputField(
                controller: _inputController,
                onSubmit: _submitIngredient,
              ),
              const SizedBox(height: 16),
              if (ingredients.isNotEmpty) ...[
                IngredientsWrapList(
                  ingredients: ingredients,
                  onDelete: (item) => cubit.removeIngredient(item),
                ),
                const SizedBox(height: 20),
              ],
              CustomGradientButton(
                text: 'Generate AI Recipes',
                loadingText: 'Generating Recipes...',
                showAiIcon: true,
                isLoading: state is SmartFridgeLoading,
                onPressed: () => cubit.generateRecipes(),
              ),
              const SizedBox(height: 24),
              if (state is SmartFridgeSuccess) ...[
                Text(
                  'Suggested Recipes',
                  style: AppTextStyles.font18SemiBoldWhite.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.recipes.map((recipe) => RecipeCard(recipe: recipe)),
              ],
            ],
          );
        },
      ),
    );
  }
}
