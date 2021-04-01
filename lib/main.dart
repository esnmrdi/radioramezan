// loading required packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:radioramezan/splash.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/side_drawer.dart';
import 'package:radioramezan/nav_bar.dart';
import 'package:radioramezan/advertisements.dart';
import 'package:radioramezan/qibla.dart';
import 'package:radioramezan/conductor.dart';
import 'package:radioramezan/home_page.dart';
import 'package:radioramezan/prayers.dart';
import 'package:radioramezan/app_settings.dart';
import 'package:radioramezan/radio_bar.dart';
import 'package:radioramezan/theme.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );
  await globals.init();
  runApp(
    RadioRamezanApp(),
  );
}

class RadioRamezanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: RadioRamezanColors.ramady,
      ),
    );
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => lightTheme,
      themedWidgetBuilder: (context, theme) {
        // return FutureBuilder(
        //   future: globals.init(),
        //   builder: (context, AsyncSnapshot snapshot) {
        //     return MaterialApp(
        //       title: 'رادیو رمضان',
        //       theme: theme,
        //       home: snapshot.connectionState == ConnectionState.waiting
        //           ? Splash()
        //           : Main(),
        //       localizationsDelegates: [
        //         GlobalCupertinoLocalizations.delegate,
        //         GlobalMaterialLocalizations.delegate,
        //         GlobalWidgetsLocalizations.delegate,
        //       ],
        //       supportedLocales: [
        //         Locale('fa', 'IR'),
        //       ],
        //       locale: Locale('fa', 'IR'),
        //       debugShowCheckedModeBanner: false,
        //     );
        //   },
        // );
        return MaterialApp(
          title: 'رادیو رمضان',
          theme: theme,
          home: Main(),
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('fa', 'IR'),
          ],
          locale: Locale('fa', 'IR'),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    globals.radioPlayer.dispose();
    globals.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: globals.mainScaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: SideDrawer(),
        body: SizedBox.expand(
          child: PreloadPageView(
            preloadPagesCount: 4,
            controller: globals.pageController,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (int index) {
              setState(() => globals.navigatorIndex = index);
            },
            children: <Widget>[
              Qibla(),
              Conductor(),
              HomePage(),
              Prayers(),
              AppSettings(),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioBar(),
            NavBar(),
            Advertisements(),
          ],
        ),
      ),
    );
  }
}
