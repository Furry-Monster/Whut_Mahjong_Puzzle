import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/info_card.dart';
import '../widgets/action_button.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nah,Id win...'),
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final gameModel = gameProvider.gameModel;

            return Row(
              children: [
                // 左侧数据信息
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border(
                      right: BorderSide(
                        color: Colors.blue[200]!,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '游戏信息',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InfoCard(
                        title: '当前得分',
                        value: '${gameModel.score}',
                        icon: Icons.stars,
                      ),
                      const SizedBox(height: 16),
                      InfoCard(
                        title: '剩余配对',
                        value: '${gameModel.remainingPairs}',
                        icon: Icons.grid_on,
                      ),
                      const SizedBox(height: 16),
                      InfoCard(
                        title: '游戏状态',
                        value: gameModel.remainingPairs == 0 ? '已完成' : '进行中',
                        icon: Icons.info_outline,
                      ),
                    ],
                  ),
                ),
                // 中间游戏区域
                Expanded(
                  child: GameBoard(gameProvider: gameProvider),
                ),
                // 右侧功能按钮
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border(
                      left: BorderSide(
                        color: Colors.blue[200]!,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionButton(
                        label: '重新开始',
                        icon: Icons.refresh,
                        onPressed: () => gameProvider.restartGame(),
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        label: '游戏规则',
                        icon: Icons.help_outline,
                        onPressed: () {
                          // TODO: 显示游戏规则
                        },
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        label: '提示',
                        icon: Icons.question_mark_outlined,
                        onPressed: () {
                          // TODO: 提示下一步操作
                        },
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        label: '设置',
                        icon: Icons.settings,
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting');
                        },
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        label: '返回主菜单',
                        icon: Icons.home,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
