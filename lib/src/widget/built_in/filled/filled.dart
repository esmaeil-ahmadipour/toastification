import 'package:flutter/material.dart';
import 'package:toastification/src/core/toastification.dart';
import 'package:toastification/src/helper/toast_helper.dart';
import 'package:toastification/src/widget/built_in/built_in.dart';

class FilledToastWidget extends StatelessWidget with BuiltInToastWidget {
  const FilledToastWidget({
    super.key,
    required this.type,
    this.textStyle,
    required this.title,
    this.icon,
    this.brightness,
    this.padding,
    this.borderRadius,
    this.elevation,
    required this.textDirection,
    this.onCloseTap,
    this.showCloseButton,
  });

  @override
  final ToastificationType type;

  @override
  final TextStyle? textStyle;

  final String title;

  final Widget? icon;

  final TextDirection textDirection;

  final Brightness? brightness;

  final EdgeInsetsGeometry? padding;

  final BorderRadiusGeometry? borderRadius;

  final double? elevation;

  final VoidCallback? onCloseTap;

  final bool? showCloseButton;

  @override
  Color buildColor(BuildContext context) {
    switch (type) {
      case ToastificationType.info:
        return Toastification().themeColors!.getColor(brightness!)!.info;
      case ToastificationType.warning:
        return Toastification().themeColors!.getColor(brightness!)!.warning;
      case ToastificationType.success:
        return Toastification().themeColors!.getColor(brightness!)!.succeed;
      case ToastificationType.failed:
        return Toastification().themeColors!.getColor(brightness!)!.failure;
    }
  }

  @override
  IconData buildIcon(BuildContext context) {
    switch (type) {
      case ToastificationType.info:
        return Icons.info;
      case ToastificationType.warning:
        return Icons.warning_rounded;
      case ToastificationType.success:
        return Icons.check_rounded;

      case ToastificationType.failed:
        return Icons.error;
    }
  }

  @override
  BorderRadiusGeometry buildBorderRadius(BuildContext context) {
    return borderRadius ?? BorderRadius.circular(8);
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = Theme.of(context);

    final background = buildColor(context);

    final showCloseButton = this.showCloseButton ?? true;

    return Directionality(
      textDirection: context.revertDirectionality(),
      child: IconTheme(
        data: defaultTheme.primaryIconTheme,
        child: Material(
          borderRadius: buildBorderRadius(context),
          color: background,
          elevation: elevation ?? 4.0,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Offstage(
                    offstage: !showCloseButton,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent, // Button color
                          child: InkWell(
                            onTap: onCloseTap,
                            child: const SizedBox(
                              width: 28,
                              height: 28,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(Icons.close,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !showCloseButton,
                    child: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 16.0),
                      child: VerticalDivider(
                          color: Colors.white70, width: 2.0, thickness: 2.0),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          textAlign: context.isDirectionRTL()
                              ? TextAlign.right
                              : TextAlign.left,
                          style: textStyle ??
                              defaultTheme.textTheme.titleLarge
                                  ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
