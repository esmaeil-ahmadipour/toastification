import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// This widget help you to use the default behavior of the built-in
/// toastification Items
class ToastificationBuiltInContainer extends StatelessWidget {
  const ToastificationBuiltInContainer({
    super.key,
    required this.item,
    this.background,
    this.foreground,
    this.margin,
    required this.borderRadius,
    required this.showProgressBar,
    required this.closeOnClick,
    required this.pauseOnHover,
    required this.dragToClose,
    required this.child,
  });

  final ToastificationItem item;

  final Widget child;

  final Color? background;
  final Color? foreground;

  final EdgeInsetsGeometry? margin;

  final BorderRadiusGeometry borderRadius;

  final bool showProgressBar;

  final bool closeOnClick;

  final bool dragToClose;

  final bool pauseOnHover;

  @override
  Widget build(BuildContext context) {
    final hasTimeout = item.hasTimer;

    Widget toast = Padding(
      padding:
          margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            child,
            if (showProgressBar && hasTimeout)
              ToastTimerAnimationBuilder(
                item: item,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: foreground?.withOpacity(.8),
                    color: background,
                    minHeight: 6,
                  );
                },
              ),
          ],
        ),
      ),
    );

    if (pauseOnHover && hasTimeout) {
      toast = MouseRegion(
        onEnter: (event) {
          item.pause();
        },
        onExit: (event) {
          item.start();
        },
        child: toast,
      );
    }

    if (closeOnClick) {
      toast = GestureDetector(
        onTap: closeOnClick
            ? () {
                toastification.dismiss(item);
              }
            : null,
        child: toast,
      );
    }

    if (dragToClose) {
      toast = _FadeDismissible(
        item: item,
        pauseOnHover: pauseOnHover,
        child: toast,
      );
    }

    return toast;
  }
}

class BuiltInWidgetBuilder extends StatelessWidget {
  const BuiltInWidgetBuilder({
    super.key,
    required this.item,
    this.type,
    this.style,
    this.textStyle,
    required this.title,
    this.description,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.brightness,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.onCloseTap,
    this.showProgressBar,
    this.showCloseButton,
    this.closeOnClick,
    this.dragToClose,
    this.pauseOnHover,
  });

  final ToastificationItem item;

  final ToastificationType? type;

  final ToastificationStyle? style;

  final TextStyle? textStyle;

  final String title;
  final String? description;

  final Widget? icon;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final Brightness? brightness;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final BorderRadiusGeometry? borderRadius;

  final double? elevation;

  final VoidCallback? onCloseTap;

  final bool? showProgressBar;

  final bool? showCloseButton;

  final bool? closeOnClick;

  final bool? dragToClose;

  final bool? pauseOnHover;

  @override
  Widget build(BuildContext context) {
    final defaultTheme = Theme.of(context);

    final style = this.style ?? ToastificationStyle.fillColored;

    final showProgressBar = (this.showProgressBar ?? true) &&
        style == ToastificationStyle.fillColored;

    final closeOnClick = this.closeOnClick ?? false;
    final pauseOnHover = this.pauseOnHover ?? true;
    final dragToClose = this.dragToClose ?? true;

    final toastContent = buildToast(context);

    final foreground = defaultTheme.primaryIconTheme.color;
    final background = toastContent.buildColor(context);

    return ToastificationBuiltInContainer(
      item: item,
      background: background,
      foreground: foreground,
      margin: margin,
      borderRadius: borderRadius ?? toastContent.buildBorderRadius(context),
      showProgressBar: showProgressBar,
      closeOnClick: closeOnClick,
      dragToClose: dragToClose,
      pauseOnHover: pauseOnHover,
      child: toastContent,
    );
  }

  BuiltInToastWidget buildToast(BuildContext context) {
    final type = this.type ?? ToastificationType.info;

    final style = this.style ?? ToastificationStyle.fillColored;

    final onCloseTap = buildOnCloseTap();

    switch (style) {
      case ToastificationStyle.fillColored:
        return FilledToastWidget(
          type: type,
          textStyle: textStyle,
          textDirection: item.textDirection,
          title: title,
          icon: icon,
          brightness: brightness,
          padding: padding,
          borderRadius: borderRadius,
          elevation: elevation,
          onCloseTap: onCloseTap,
          showCloseButton: showCloseButton,
        );
      case ToastificationStyle.flatColored:
        return FlatColoredToastWidget(
          textDirection: item.textDirection,
          type: type,
          textStyle: textStyle,
          title: title,
          description: description,
          icon: icon,
          brightness: brightness,
          padding: padding,
          borderRadius: borderRadius,
          elevation: elevation,
          onCloseTap: onCloseTap,
          showCloseButton: showCloseButton,
        );
      case ToastificationStyle.flat:
        return FlatToastWidget(
          textDirection: item.textDirection,
          type: type,
          textStyle: textStyle,
          title: title,
          description: description,
          icon: icon,
          brightness: brightness,
          padding: padding,
          borderRadius: borderRadius,
          elevation: elevation,
          onCloseTap: onCloseTap,
          showCloseButton: showCloseButton,
        );
    }
  }

  VoidCallback buildOnCloseTap() {
    return onCloseTap ??
        () {
          Toastification().dismiss(item);
        };
  }
}

class _FadeDismissible extends StatefulWidget {
  const _FadeDismissible({
    required this.item,
    required this.pauseOnHover,
    required this.child,
  });

  final ToastificationItem item;
  final bool pauseOnHover;
  final Widget child;

  @override
  State<_FadeDismissible> createState() => _FadeDismissibleState();
}

class _FadeDismissibleState extends State<_FadeDismissible> {
  double currentOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _handleDragUpdate(true, event.kind);
      },
      onPointerUp: (event) {
        _handleDragUpdate(false, event.kind);
      },
      child: Dismissible(
        key: ValueKey('dismiss-${widget.item.id}'),
        onUpdate: (details) {
          setState(() {
            currentOpacity = details.progress;
          });
        },
        behavior: HitTestBehavior.deferToChild,
        onDismissed: (direction) {
          toastification.dismiss(widget.item, showRemoveAnimation: false);
        },
        child: Opacity(
          opacity: 1 - currentOpacity,
          child: widget.child,
        ),
      ),
    );
  }

  void _handleDragUpdate(bool startDrag, PointerDeviceKind pointerKind) {
    if (widget.pauseOnHover && pointerKind == PointerDeviceKind.mouse) return;

    if (widget.item.hasTimer && startDrag) {
      widget.item.pause();
    } else {
      widget.item.start();
    }
  }
}
