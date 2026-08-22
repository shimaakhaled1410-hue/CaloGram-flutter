import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ===== Headings =====
  static TextStyle font28BoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textMainDark,
  );

  static TextStyle font24BoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textMainDark,
  );

  static TextStyle font20BoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textMainDark,
  );

  static TextStyle font20SemiBoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textMainDark,
  );

  static TextStyle font18SemiBoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textMainDark,
  );

  // ===== Body & Subtitles =====
  static TextStyle font16MediumSecondary = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryDark,
  );

  static TextStyle font16SemiBoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textMainDark,
  );

  static TextStyle font14RegularMuted = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMutedDark,
  );

  static TextStyle font14MediumWhite = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMainDark,
  );

  static TextStyle font14SemiBoldWhite = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMainDark,
  );

  static TextStyle font12MediumMuted = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedDark,
  );

  // ===== Buttons & Highlights =====
  static TextStyle font16BoldDark = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundDark,
  );

  static TextStyle font16BoldLime = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryNeonLime,
  );

  static TextStyle font14SemiBoldLime = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryNeonLime,
  );
}
