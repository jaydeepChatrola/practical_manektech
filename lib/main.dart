import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practical_manektech/helper/app_manager.dart';
import 'package:practical_manektech/helper/string_constant.dart';
import 'package:practical_manektech/helper/theme_helper.dart';

import 'helper/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String initialRoute = RouteName.root;
  runApp(MyApp(initialRoute));
}

class MyApp extends StatefulWidget {
  const MyApp(this.initialRoute, {Key? key}) : super(key: key);
  final String initialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AppManager.getInstance()?.initialiseNetworkHelper();
    AppManager.getInstance()?.initialiseDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return AppTheme(
      child: ScreenUtilInit(
          designSize:
              Size(appTheme.expectedDeviceWidth, appTheme.expectedDeviceWidth),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: Routes.baseRoutes,
              initialRoute: widget.initialRoute,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              builder: (context, child) {
                return Stack(
                  children: [
                    child!,
                    StreamBuilder<bool?>(
                      initialData: true,
                      stream: AppManager.getInstance()
                          ?.getNetworkHelper()
                          .internetConnectionStream,
                      builder: (context, snapshot) {
                        return SafeArea(
                          child: AnimatedContainer(
                            height: snapshot.data as bool ? 0 : 50,
                            duration: const Duration(seconds: 2),
                            color: appTheme.redColor,
                            child: const Material(
                              type: MaterialType.transparency,
                              child: Center(
                                child:
                                    Text(StringConstant.noInternetConnection),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
