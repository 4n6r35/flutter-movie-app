import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

ThemeData getTheme(bool darkMode) {
  if (darkMode) {
    final darkTheme = ThemeData.dark();
    final textTheme = darkTheme.textTheme;
    const whiteStyle = TextStyle(color: Colors.white);
    const boldStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    return darkTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark,
        elevation: 0,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme(
        textTheme.copyWith(
          titleSmall: textTheme.titleSmall?.merge(boldStyle),
          titleMedium: textTheme.titleMedium?.merge(boldStyle),
          titleLarge: textTheme.titleLarge?.merge(boldStyle),
          bodySmall: textTheme.bodySmall?.merge(whiteStyle),
        ),
      ),
      scaffoldBackgroundColor: AppColors.darkLight,
      canvasColor: AppColors.dark,
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all(
          Colors.lightBlue.withOpacity(0.5),
        ),
        thumbColor: MaterialStateProperty.all(
          Colors.blue,
        ),
      ),
    );
  }

  final ligthTheme = ThemeData.light();
  final textTheme = ligthTheme.textTheme;
  const boldStyle =
      TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark);
  const darkStyle = TextStyle(color: AppColors.dark);

  return ligthTheme.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark),
      titleTextStyle: TextStyle(color: AppColors.dark),
    ),
    textTheme: GoogleFonts.nunitoSansTextTheme(
      textTheme.copyWith(
        titleSmall: textTheme.titleSmall?..merge(boldStyle),
        titleMedium: textTheme.titleMedium?.merge(boldStyle),
        titleLarge: textTheme.titleLarge?.merge(boldStyle),
        bodySmall: textTheme.bodyMedium?.merge(darkStyle),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.dark,
    ),
  );
}
