import 'package:flutter/material.dart';
import '../screens/menu_screen.dart';
import '../screens/game_screen.dart';
import '../screens/setting_screen.dart';

class AppRoutes {
  static const String menu = '/';
  static const String game = '/game';
  static const String setting = '/setting';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      menu: (context) => const MenuScreen(),
      game: (context) => const GameScreen(),
      setting: (context) => const SettingScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case menu:
        return MaterialPageRoute(builder: (context) => const MenuScreen());
      case game:
        return MaterialPageRoute(builder: (context) => const GameScreen());
      case setting:
        return MaterialPageRoute(builder: (context) => const SettingScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('未找到路由: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
