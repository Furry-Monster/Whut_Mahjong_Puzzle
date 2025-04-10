import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 50),
              // 开始游戏按钮
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.game);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                ),
                child: const Text(
                  'New Game!!!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              // 设置按钮
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.setting);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
