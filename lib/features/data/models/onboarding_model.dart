import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String highlightWord;
  final String description;
  final IconData icon;

  const OnboardingModel({
    required this.title,
    required this.highlightWord,
    required this.description,
    required this.icon,
  });
}