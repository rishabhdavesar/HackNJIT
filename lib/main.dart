import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/bloc/repo.dart';

import 'package:gong/screens/gongCollection.dart';
import 'package:gong/screens/home.dart';
import 'package:gong/screens/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'screens/presets.dart';
import 'screens/statistics.dart';
import 'widgets/bottomNavBar.dart';
import 'widgets/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'gong',
      home: BlocProvider(
        create: (BuildContext context) => MainBloc(Repo()),
        child: SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);
    return new Scaffold(
        body:
    
            BlocProvider<MainBloc>(
                create: (context) => MainBloc(Repo()),
                child: PersistentTabView(
                  controller: _controller,

                  screens: _buildScreens(),
                  items: _navBarsItems(),
                  confineInSafeArea: true,
                  backgroundColor: Colors.white,

                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset:
                      true, // This needs to be true if you want to move up the screen when keyboard appears.
                  stateManagement: false,
                  hideNavigationBarWhenKeyboardShows:
                      true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    colorBehindNavBar: Colors.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: false,
                  itemAnimationProperties: ItemAnimationProperties(
                    // Navigation Bar's items animation properties.
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: ScreenTransitionAnimation(
                    // Screen transition animation on change of selected tab.
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle
                      .style10, // Choose the nav bar style with this property.
                )
                
                
                ));
  }

  List<Widget> _buildScreens() {
    return [
      new Home(),
      new PresetsScreen(),
      new GongCollectionScreen(),
      new StatisticsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.ios_home),
        title: ("Home"),
        activeColor: lightYellow,
        activeContentColor: yellow,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: RotatedBox(
            quarterTurns: 1,
            child: Icon(
              FontAwesome.sliders,
            )),
        title: ("Presets"),
        activeColor: lightYellow,
        activeContentColor: yellow,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage("assets/images/gong.png"),
          // color: Color(0xFF3A5A98),
        ),
        title: ("Gongs"),
        activeColor: lightYellow,
        activeContentColor: yellow,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage("assets/images/stat.png"),
          // color: Color(0xFF3A5A98),
        ),
        title: ("Statistics"),
        activeColor: lightYellow,
        activeContentColor: yellow,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }
      
}
