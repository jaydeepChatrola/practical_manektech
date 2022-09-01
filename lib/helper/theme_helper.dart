import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme extends StatefulWidget {
  final Widget? child;

  const AppTheme({Key? key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppThemeState();
  }

  static AppThemeState of(BuildContext context) {
    final _InheritedStateContainer? inheritedStateContainer =
        context.dependOnInheritedWidgetOfExactType();
    if (inheritedStateContainer == null) {
      return AppThemeState();
    } else {
      return inheritedStateContainer.data!;
    }
  }
}

class AppThemeState extends State<AppTheme> {
  double getResponsiveWidth(double value) => ScreenUtil().setWidth(value);

  double getResponsiveHeight(double value) => ScreenUtil().setHeight(value);

  Color get primaryColor => const Color(0xFF2196F3);

  Color get redColor => const Color(0xffD22F31);

  double get expectedDeviceWidth => 1080;

  double get expectedDeviceHeight => 1920;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppThemeState? data;

  _InheritedStateContainer({
    Key? key,
    @required this.data,
    @required Widget? child,
  })  : assert(child != null),
        super(key: key, child: child!);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
