import 'package:flutter/material.dart';

enum ToastificationStyle {
  fillColored,
  flatColored,
  flat,
}

enum ToastificationType {
  info,
  warning,
  success,
  failed,
}

mixin BuiltInToastWidget on Widget {
  ToastificationType get type;

  Color buildColor(BuildContext context);

  IconData buildIcon(BuildContext context);

  BorderRadiusGeometry buildBorderRadius(BuildContext context);
}
