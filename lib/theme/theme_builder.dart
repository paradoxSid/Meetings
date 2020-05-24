import 'package:flutter/material.dart';
import 'package:meetings/theme/colors.dart';

class ThemeBuilder {
  static ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      accentColor: LightColor.kAccentColor,
      primaryColor: LightColor.kPrimaryColor,
      primaryColorLight: LightColor.kPrimaryLight,
      primaryColorDark: LightColor.kPrimaryDark,
      appBarTheme: base.appBarTheme.copyWith(
        color: LightColor.kPrimaryLight.withOpacity(0.95),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: LightColor.kPrimaryColor,
      cardColor: LightColor.kPrimaryDark,
      textSelectionColor: LightColor.kAccentColor,
      textTheme: _buildLightTextTheme(base.textTheme),
      primaryTextTheme: _buildLightTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildLightTextTheme(base.accentTextTheme),
      primaryIconTheme: base.iconTheme.copyWith(color: LightColor.kIconColor),
      canvasColor: LightColor.kPrimaryLight,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: LightColor.kAccentColor),
    );
  }

  static TextTheme _buildLightTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline: base.headline.copyWith(
              fontWeight: FontWeight.normal, color: LightColor.kPrimaryDark),
          title: base.title.copyWith(fontSize: 18.0),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 14.0,
          ),
        )
        .apply(
          displayColor: LightColor.kPrimaryColor,
          bodyColor: LightColor.kSecondaryColor,
        );
  }
}
