import 'package:cityCloud/expanded/log_recorder/log_recorder.dart';
import 'package:cityCloud/lifecycle/lifecycle.dart';
import 'package:cityCloud/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

import 'styles/color_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsBinding.instance.addObserver(LifeCycle());
  LogRecorder.addLog(logDescription: '打开app', logType: LogType.initApp);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        // showPerformanceOverlay: true,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        navigatorObservers: [CustomNavigatorObserver()],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('zh', 'CN'),
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('zh', 'CN'),
        ],
        title: '',
        routes: {
          RouterManager.root: (ctx) {
            LifeCycle.initApp(ctx);
            return RouterManager.rootPageBuilder(ctx);
          }
        },
        theme: ThemeData(
          // fontFamily: PingFangType.medium,
          // textTheme: TextTheme(
          //   button: TextStyle(fontFamily: PingFangType.medium, color: ColorHelper.Black33, fontSize: 14),
          // ),
          appBarTheme: AppBarTheme(
            elevation: 1,
            color: Colors.white,
            // centerTitle: true,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: ColorHelper.Black51),
            actionsIconTheme: IconThemeData(color: ColorHelper.Black33),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: ColorHelper.Black33,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              button: TextStyle(
                // fontFamily: PingFangType.medium,
                color: ColorHelper.Black33,
                fontSize: 18,
              ),
            ),
          ),
          dividerColor: ColorHelper.DividerColor,
          scaffoldBackgroundColor: ColorHelper.BGColor,
        ),
      ),
    );
  }
}
