import 'package:flutter/material.dart';

class GameRulesDialog extends StatelessWidget {
  const GameRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('游戏规则'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('1. 点击两个相同图案的方块'),
            SizedBox(height: 8),
            Text('2. 方块之间可以通过直线连接(最多2个拐点)'),
            SizedBox(height: 8),
            Text('3. 连接路径上不能有其他方块阻挡'),
            SizedBox(height: 8),
            Text('4. 成功连接一对方块得10分'),
            SizedBox(height: 8),
            Text('5. 消除所有方块配对即可获胜'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
