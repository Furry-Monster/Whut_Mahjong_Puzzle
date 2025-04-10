import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import 'tile_widget.dart';
import 'package:pyramid_of_mahjong/widgets/connection_line.dart';

class GameBoard extends StatefulWidget {
  final GameProvider gameProvider;

  const GameBoard({
    super.key,
    required this.gameProvider,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int? _selectedRow;
  int? _selectedCol;
  List<Offset> _connectionPath = [];
  bool _showConnection = false;
  Offset? _startPoint;
  Offset? _endPoint;
  Map<String, bool> _matchedTiles = {};

  @override
  Widget build(BuildContext context) {
    final gameModel = widget.gameProvider.gameModel;
    final size = MediaQuery.of(context).size;

    // 计算棋盘大小，确保能显示所有格子
    // 使用屏幕宽度的60%作为基准，但确保高度不超过屏幕高度的70%
    final maxBoardSize = size.width * 0.6;
    final maxHeight = size.height * 0.7;

    // 根据行列数计算合适的棋盘大小
    final aspectRatio = gameModel.columns / gameModel.rows;
    double boardSize;

    if (maxBoardSize / aspectRatio <= maxHeight) {
      // 宽度限制
      boardSize = maxBoardSize;
    } else {
      // 高度限制
      boardSize = maxHeight * aspectRatio;
    }

    final tileSize = boardSize / gameModel.columns;

    return Center(
      child: Stack(
        children: [
          // 游戏网格
          SizedBox(
            width: boardSize,
            height: boardSize,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
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
                final value = gameModel.board[row][col];
                final isSelected = row == _selectedRow && col == _selectedCol;
                final tileKey = '$row,$col';
                final isMatched = _matchedTiles[tileKey] ?? false;

                return TileWidget(
                  value: value,
                  isSelected: isSelected,
                  isMatched: isMatched,
                  onTap: () => _onTileTap(row, col, tileSize),
                );
              },
            ),
          ),

          // 连接线
          if (_showConnection && _startPoint != null && _endPoint != null)
            Positioned(
              left: 0,
              top: 0,
              width: boardSize,
              height: boardSize,
              child: ConnectionLine(
                startPoint: _startPoint!,
                endPoint: _endPoint!,
                pathPoints: _connectionPath,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  void _onTileTap(int row, int col, double tileSize) {
    final gameModel = widget.gameProvider.gameModel;
    final value = gameModel.board[row][col];

    if (value == 0) return; // 空白方块不响应点击

    setState(() {
      if (_selectedRow == null || _selectedCol == null) {
        // 第一次选择
        _selectedRow = row;
        _selectedCol = col;
        _showConnection = false;
      } else if (_selectedRow == row && _selectedCol == col) {
        // 点击同一个方块，取消选择
        _selectedRow = null;
        _selectedCol = null;
        _showConnection = false;
      } else {
        // 第二次选择，尝试连接
        final firstValue = gameModel.board[_selectedRow!][_selectedCol!];
        final secondValue = value;

        if (firstValue == secondValue) {
          // 计算连接路径
          _calculateConnectionPath(row, col, tileSize);

          // 检查是否可以连接
          if (widget.gameProvider
              .canConnect(_selectedRow!, _selectedCol!, row, col)) {
            // 可以连接，显示连接线并消除方块
            _showConnection = true;

            // 标记要消除的方块
            final firstTileKey = '$_selectedRow,$_selectedCol';
            final secondTileKey = '$row,$col';
            _matchedTiles[firstTileKey] = true;
            _matchedTiles[secondTileKey] = true;

            // 触发重建以显示消除动画
            setState(() {});

            // 延迟消除方块，让用户看到连接线和消除动画
            Future.delayed(const Duration(milliseconds: 800), () {
              widget.gameProvider.selectTile(_selectedRow!, _selectedCol!);
              widget.gameProvider.selectTile(row, col);

              setState(() {
                _selectedRow = null;
                _selectedCol = null;
                _showConnection = false;
                // 清除匹配标记
                _matchedTiles.remove(firstTileKey);
                _matchedTiles.remove(secondTileKey);
              });
            });
          } else {
            // 不能连接，只更新选择
            _selectedRow = row;
            _selectedCol = col;
            _showConnection = false;
          }
        } else {
          // 不同方块，更新选择
          _selectedRow = row;
          _selectedCol = col;
          _showConnection = false;
        }
      }
    });
  }

  void _calculateConnectionPath(int row, int col, double tileSize) {
    // 计算方块中心点
    final startX = (_selectedCol! + 0.5) * tileSize;
    final startY = (_selectedRow! + 0.5) * tileSize;
    final endX = (col + 0.5) * tileSize;
    final endY = (row + 0.5) * tileSize;

    _startPoint = Offset(startX, startY);
    _endPoint = Offset(endX, endY);

    // 获取连接路径点
    final pathPoints = widget.gameProvider
        .getConnectionPath(_selectedRow!, _selectedCol!, row, col);

    if (pathPoints.isNotEmpty) {
      _connectionPath = pathPoints.map((point) {
        return Offset(
          (point.col + 0.5) * tileSize,
          (point.row + 0.5) * tileSize,
        );
      }).toList();
    } else {
      _connectionPath = [];
    }
  }
}
