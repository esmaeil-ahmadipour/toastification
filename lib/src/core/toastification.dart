import 'package:flutter/material.dart';
import 'package:toastification/src/core/toastification_config.dart';
import 'package:toastification/src/core/toastification_item.dart';
import 'package:toastification/src/core/toastification_manager.dart';
import 'package:toastification/src/helper/toast_helper.dart';
import 'package:toastification/src/widget/built_in/built_in.dart';
import 'package:toastification/src/widget/built_in/built_in_builder.dart';

/// This is the main singleton class instance of the package.
/// You can use this instance to show and manage your notifications.
///
/// use [show] method to show a built-in notifications
/// example :
///
/// ```dart
/// toastification.show(
///   context: context,
///   alignment: Alignment.topRight,
///   title: 'Hello World',
///   description: 'This is a notification',
///   type: ToastificationType.info,
///   style: ToastificationStyle.floating,
///   autoCloseDuration: Duration(seconds: 3),
/// );
/// ```
///
/// use [showCustom] method to show a custom notification
/// you should create your own widget and pass it to the [builder] parameter
/// example :
///
/// ```dart
/// toastification.showCustom(
///   context: context,
///   alignment: Alignment.topRight,
///   animationDuration: Duration(milliseconds: 500),
///   autoCloseDuration: Duration(seconds: 3),
///   builder: (context, item) {
///     return CustomToastWidget();
///   },
/// );
/// ```
final toastification = Toastification();

/// This is the main class of the package.
/// You can use this class to show and manage your notifications.
///
/// use [show] method to show a built-in notifications
/// example :
///
/// ```dart
/// Toastification().show(
///   context: context,
///   alignment: Alignment.topRight,
///   title: 'Hello World',
///   description: 'This is a notification',
///   type: ToastificationType.info,
///   style: ToastificationStyle.floating,
///   autoCloseDuration: Duration(seconds: 3),
/// );
/// ```
///
/// use [showCustom] method to show a custom notification
/// you should create your own widget and pass it to the [builder] parameter
/// example :
///
/// ```dart
/// Toastification().showCustom(
///   context: context,
///   alignment: Alignment.topRight,
///   animationDuration: Duration(milliseconds: 500),
///   autoCloseDuration: Duration(seconds: 3),
///   builder: (context, item) {
///     return CustomToastWidget();
///   },
/// );
/// ```
class Toastification {
  static final Toastification _instance = Toastification._internal();

  Toastification._internal();

  factory Toastification() => _instance;

  final Map<Alignment, ToastificationManager> _managers = {};
  ThemeColors? _themeColors = ThemeColors(
    light: const ColorTypes(
        info: Colors.blue,
        warning: Colors.amber,
        succeed: Colors.green,
        failure: Colors.red),
    dark: ColorTypes(
        info: Colors.blue.shade900,
        warning: Colors.amber.shade900,
        succeed: Colors.green.shade900,
        failure: Colors.red.shade900),
  );

  ThemeColors? get themeColors => _themeColors;

  void setThemeColors(ThemeColors value) {
  _themeColors = value;
  }

  /// the default configuration for the toastification
  ///
  /// when you are using [show] or [showCustom] methods,
  /// if some of the parameters are not provided,
  /// [Toastification] will use this class to get the default values.
  ///
  /// update this value to change the default configuration of the toastification package
  ///
  /// example :
  ///
  /// ```dart
  /// toastification.config = ToastificationConfig(
  ///   alignment: Alignment.topRight,
  ///   animationDuration: const Duration(milliseconds: 500),
  ///   animationBuilder: (context, animation,alignment, child) {
  ///     return FadeTransition(
  ///       opacity: animation,
  ///       child: child,
  ///     );
  ///   },
  /// );
  /// ```
  ToastificationConfig config = const ToastificationConfig();

  /// shows a custom notification
  /// you should create your own widget and pass it to the [builder] parameter
  ///
  /// example :
  ///
  /// ```dart
  /// toastification.showCustom(
  ///   context: context,
  ///   alignment: Alignment.topRight,
  ///   animationDuration: Duration(milliseconds: 500),
  ///   autoCloseDuration: Duration(seconds: 3),
  ///   builder: (context, item) {
  ///     return CustomToastWidget();
  ///   },
  /// );
  /// ```
  ToastificationItem showCustom({
    required BuildContext context,
    AlignmentGeometry? alignment,
    required ToastificationBuilder builder,
    required ToastificationAnimationBuilder? animationBuilder,
    required Duration? animationDuration,
    Duration? autoCloseDuration,
    OverlayState? overlayState,
  }) {
    final effectiveAlignment =
        (alignment ?? config.alignment).resolve(Directionality.of(context));

    final manager = _managers.putIfAbsent(
      effectiveAlignment,
      () =>
          ToastificationManager(alignment: effectiveAlignment, config: config),
    );

    return manager.showCustom(
      context: context,
      builder: builder,
      animationBuilder: animationBuilder,
      animationDuration: animationDuration,
      autoCloseDuration: autoCloseDuration,
      overlayState: overlayState,
    );
  }

  /// using this method you can show a notification by using the [navigator] overlay
  /// you should create your own widget and pass it to the [builder] parameter
  ///
  /// ```dart
  /// toastification.showWithNavigatorState(
  ///   navigator: navigatorState or Navigator.of(context),
  ///   alignment: Alignment.topRight,
  ///   animationDuration: Duration(milliseconds: 500),
  ///   autoCloseDuration: Duration(seconds: 3),
  ///   builder: (context, item) {
  ///     return CustomToastWidget();
  ///   },
  /// );
  /// ```
  ToastificationItem showWithNavigatorState({
    required NavigatorState navigator,
    required ToastificationBuilder builder,
    AlignmentGeometry? alignment,
    ToastificationAnimationBuilder? animationBuilder,
    Duration? animationDuration,
    Duration? autoCloseDuration,
  }) {
    final context = navigator.context;

    return showCustom(
      context: context,
      alignment: alignment,
      builder: builder,
      animationBuilder: animationBuilder,
      animationDuration: animationDuration,
      autoCloseDuration: autoCloseDuration,
      overlayState: navigator.overlay,
    );
  }

  /// shows a built-in notification with the given parameters
  ///
  /// example :
  ///
  /// ```dart
  /// toastification.show(
  ///   context: context,
  ///   alignment: Alignment.topRight,
  ///   title: 'Hello World',
  ///   description: 'This is a notification',
  ///   type: ToastificationType.info,
  ///   style: ToastificationStyle.floating,
  ///   autoCloseDuration: Duration(seconds: 3),
  /// );
  /// ```
  ///
  ToastificationItem show({
    required BuildContext context,
    AlignmentGeometry? alignment,
    Duration? autoCloseDuration,
    OverlayState? overlayState,
    ToastificationAnimationBuilder? animationBuilder,
    ToastificationType? type,
    ToastificationStyle? style,
    TextStyle? textStyle,
    required String title,
    Duration? animationDuration,
    Widget? icon,
    Brightness? brightness,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    VoidCallback? onCloseTap,
    bool? showProgressBar,
    bool? showCloseButton,
    bool? closeOnClick,
    bool? dragToClose,
    bool? pauseOnHover,
  }) {
    return showCustom(
      context: context,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      overlayState: overlayState,
      builder: (ctx, holder) {
        return BuiltInWidgetBuilder(
          item: holder,
          type: type,
          style: style,
          title: title,
          textStyle: textStyle,
          icon: icon,
          brightness: Theme.of(ctx).brightness,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          elevation: elevation,
          onCloseTap: onCloseTap,
          showProgressBar: showProgressBar,
          showCloseButton: showCloseButton,
          closeOnClick: closeOnClick,
          dragToClose: dragToClose,
          pauseOnHover: pauseOnHover,
        );
      },
      animationBuilder: animationBuilder,
      animationDuration: animationDuration,
    );
  }

  /// finds and returns a [ToastificationItem] by its [id]
  ///
  /// if there is no notification with the given [id] it will return null
  ToastificationItem? findToastificationItem(String id) {
    try {
      for (final manager in _managers.values) {
        final foundValue = manager.findToastificationItem(id);

        if (foundValue != null) {
          return foundValue;
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// dismisses the given [notification]
  ///
  /// if the [notification] is not in the list, nothing will happen
  void dismiss(
    ToastificationItem notification, {
    bool showRemoveAnimation = true,
  }) {
    final manager = _managers[notification.alignment];

    if (manager != null) {
      manager.dismiss(notification, showRemoveAnimation: showRemoveAnimation);
    }
  }

  /// dismisses all notifications that are currently showing in the screen
  ///
  /// The [delayForAnimation] parameter is used to determine
  /// whether to wait for the animation to finish or not.
  void dismissAll({bool delayForAnimation = true}) {
    for (final manager in _managers.values) {
      manager.dismissAll(delayForAnimation: delayForAnimation);
    }
  }

  /// dismisses a notification by its [id]
  ///
  /// if there is no notification with the given [id] nothing will happen
  void dismissById(
    String id, {
    bool showRemoveAnimation = true,
  }) {
    final notification = findToastificationItem(id);

    if (notification != null) {
      dismiss(notification, showRemoveAnimation: true);
    }
  }
}
