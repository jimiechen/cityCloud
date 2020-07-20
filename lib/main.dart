import 'package:cityCloud/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

import 'styles/color_helper.dart';
import 'styles/pingfang_textstyle.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
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
        routes: {Router.root: Router.rootPageBuilder},
        theme: ThemeData(
            fontFamily: PingFangType.medium,
            textTheme: TextTheme(
              button: TextStyle(fontFamily: PingFangType.medium, color: ColorHelper.Black33, fontSize: 14),
            ),
            appBarTheme: AppBarTheme(
              elevation: 1,
              color: Colors.white,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: ColorHelper.Black51),
              actionsIconTheme: IconThemeData(color: ColorHelper.Black33),
              textTheme: TextTheme(
                button: TextStyle(fontFamily: PingFangType.medium, color: ColorHelper.Black33, fontSize: 18),
              ),
            ),
            dividerColor: ColorHelper.DividerColor,
            scaffoldBackgroundColor: ColorHelper.BGColor),
      ),
    );
  }
}
