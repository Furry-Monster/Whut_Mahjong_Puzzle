import 'package:flutter/material.dart';
import '../providers/game_provider.dart';

class GameBoard extends StatelessWidget {
  final GameProvider gameProvider;

  const GameBoard({
    super.key,
    required this.gameProvider,
  });

  @override
  Widget build(BuildContext context) {
    final gameModel = gameProvider.gameModel;

    return Center(
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
            return _buildTile(context, row, col);
          },
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, int row, int col) {
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
