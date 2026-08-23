import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/domain/entities/recipe_entity.dart';
import 'package:calogram_flutter/features/presentation/manager/smart_fridge/smart_fridge_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/smart_fridge/smart_fridge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Smart Fridge', style: AppTextStyles.font20BoldWhite),
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
              // 1. Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: AppTextStyles.font14MediumWhite,
                      decoration: InputDecoration(
                        hintText: 'e.g. Eggs, Tomatoes, Spinach...',
                        hintStyle: AppTextStyles.font14RegularMuted,
                        filled: true,
                        fillColor: AppColors.cardDark,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.inputBorderDark,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.inputBorderDark,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.primaryNeonLime,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _submitIngredient(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNeonLime,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _submitIngredient,
                    child: const Icon(Icons.add, color: Colors.black, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Ingredients Chips Wrap
              if (ingredients.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ingredients.map((item) {
                    return Chip(
                      backgroundColor: AppColors.cardDark,
                      side: BorderSide(
                        color: AppColors.primaryNeonLime.withValues(alpha: 0.5),
                      ),
                      label: Text(item, style: AppTextStyles.font14MediumWhite),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white70,
                      ),
                      onDeleted: () => cubit.removeIngredient(item),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // 3. Generate Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNeonLime,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: state is SmartFridgeLoading
                    ? null
                    : () => cubit.generateRecipes(),
                child: state is SmartFridgeLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Generate AI Recipes',
                            style: AppTextStyles.font16BoldDark,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              // 4. Recipes List Output
              if (state is SmartFridgeSuccess) ...[
                Text(
                  'Suggested Recipes',
                  style: AppTextStyles.font18SemiBoldWhite,
                ),
                const SizedBox(height: 12),
                ...state.recipes.map((recipe) => _RecipeCard(recipe: recipe)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.title,
                  style: AppTextStyles.font18SemiBoldWhite,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.cookingTimeMinutes}m',
                    style: AppTextStyles.font12MediumMuted,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(recipe.description, style: AppTextStyles.font14RegularMuted),
          const SizedBox(height: 14),

          // Macros Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroStat(label: 'Calories', value: '${recipe.calories} kcal'),
                _MacroStat(label: 'Protein', value: '${recipe.protein}g'),
                _MacroStat(label: 'Carbs', value: '${recipe.carbs}g'),
                _MacroStat(label: 'Fats', value: '${recipe.fats}g'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Log Recipe Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryNeonLime),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () =>
                  context.read<SmartFridgeCubit>().logRecipeMeal(recipe),
              icon: Icon(
                Icons.bookmark_add_outlined,
                color: AppColors.primaryNeonLime,
                size: 18,
              ),
              label: Text(
                'Log as Meal',
                style: AppTextStyles.font14SemiBoldLime,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  final String label;
  final String value;
  const _MacroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.font12MediumMuted),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.font14SemiBoldWhite),
      ],
    );
  }
}
