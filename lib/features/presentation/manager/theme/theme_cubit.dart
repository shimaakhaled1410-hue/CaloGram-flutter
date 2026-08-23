import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/theme_local_data_source.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeLocalDataSource localDataSource;

  ThemeCubit({required this.localDataSource})
      : super(localDataSource.getSavedThemeMode());

  Future<void> changeTheme(ThemeMode mode) async {
    emit(mode);
    await localDataSource.saveThemeMode(mode);
  }
}