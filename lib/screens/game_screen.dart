import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

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
                      _buildInfoCard(
                        '当前得分',
                        '${gameModel.score}',
                        Icons.stars,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        '剩余配对',
                        '${gameModel.remainingPairs}',
                        Icons.grid_on,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        '游戏状态',
                        gameModel.remainingPairs == 0 ? '已完成' : '进行中',
                        Icons.info_outline,
                      ),
                    ],
                  ),
                ),
                // 中间游戏区域
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gameModel.columns,
                          childAspectRatio: 1,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: gameModel.rows * gameModel.columns,
                        itemBuilder: (context, index) {
                          final row = index ~/ gameModel.columns;
                          final col = index % gameModel.columns;
                          return buildTile(context, gameProvider, row, col);
                        },
                      ),
                    ),
                  ),
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
                      _buildActionButton(
                        '重新开始',
                        Icons.refresh,
                        () => gameProvider.restartGame(),
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        '游戏规则',
                        Icons.help_outline,
                        () {
                          // TODO: 显示游戏规则
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        '提示',
                        Icons.question_mark_outlined,
                        () {
                          // TODO: 提示下一步操作
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        '设置',
                        Icons.settings,
                        () {
                          Navigator.pushNamed(context, '/setting');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        '返回主菜单',
                        Icons.home,
                        () {
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget buildTile(
      BuildContext context, GameProvider gameProvider, int row, int col) {
    final gameModel = gameProvider.gameModel;
    final value = gameModel.board[row][col];

    if (value == 0) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        gameProvider.selectTile(row, col);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tile_$value.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
