import 'package:flutter/material.dart';

class ToastHelper {
  const ToastHelper._();

  static double convertRange(
    double originalStart,
    double originalEnd,
    double newStart,
    double newEnd,
    double value,
  ) {
    double scale = (newEnd - newStart) / (originalEnd - originalStart);
    return (newStart + ((value - originalStart) * scale));
  }
}

class ColorTypes {
  final Color info;
  final Color warning;
  final Color failure;
  final Color succeed;

  const ColorTypes(
      {required this.info,
      required this.warning,
      required this.failure,
      required this.succeed});
}

class ThemeColors {
  ColorTypes? _light;
  ColorTypes? _dark;

  ThemeColors({ColorTypes? light, ColorTypes? dark}) {
    _light = light;
    _dark = dark;
  }

  ColorTypes? get light => _light;

  set light(ColorTypes? value) {
    _light = value;
  }

  ColorTypes? get dark => _dark;

  set dark(ColorTypes? value) {
    _dark = value;
  }
}

extension ThemeColorsExtensions on ThemeColors? {
  ColorTypes? getColor(Brightness brightness) {
    return brightness == Brightness.dark ? this?.dark : this?.light;
  }
}
