import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class FlatToastWidget extends StatelessWidget with BuiltInToastWidget {
  const FlatToastWidget({
    super.key,
    required this.type,
    required this.title,
    this.description,
    this.icon,
    this.brightness,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.onCloseTap,
    this.showCloseButton,
    required this.textDirection,
  });

  @override
  final ToastificationType type;

  final String title;
  final String? description;

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
        return Icons.info_outline;
      case ToastificationType.warning:
        return Icons.warning_amber_rounded;
      case ToastificationType.success:
        return Icons.check_rounded;
      case ToastificationType.failed:
        return Icons.error_outline_rounded;
    }
  }

  @override
  BorderRadiusGeometry buildBorderRadius(BuildContext context) {
    return borderRadius ?? BorderRadius.circular(12);
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = Theme.of(context);

    final foreground = defaultTheme.colorScheme.outline;
    final background = buildColor(context);

    final showCloseButton = this.showCloseButton ?? true;

    final borderRadius = buildBorderRadius(context);

    return IconTheme(
      data: defaultTheme.primaryIconTheme,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: background.withOpacity(0.7), width: 2),
        ),
        color: defaultTheme.colorScheme.surface,
        elevation: elevation ?? 0.0,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: IntrinsicHeight(
            child: Directionality(
              textDirection: textDirection,
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
                  Expanded(child: _buildContent(defaultTheme)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData defaultTheme) {
    final foreground = defaultTheme.colorScheme.onSurface;

    Widget content = Text(
      title,
      style: defaultTheme.textTheme.titleLarge?.copyWith(
        color: foreground,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );

    if (description?.isNotEmpty ?? false) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          content,
          const SizedBox(height: 2),
          Text(
            description!,
            style: defaultTheme.textTheme.displayLarge?.copyWith(
              color: foreground,
              fontSize: 12,
            ),
          )
        ],
      );
    }

    return content;
  }
}
