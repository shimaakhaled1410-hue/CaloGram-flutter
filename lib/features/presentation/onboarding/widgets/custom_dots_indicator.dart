import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const CustomDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primaryNeonLime
                : AppColors.inputBorderDark,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}