import 'dart:math';

class GameModel {
  final int rows;
  final int columns;
  late List<List<int>> board;
  int score = 0;
  int? selectedTile;
  int remainingPairs = 0;
  static const int maxTileTypes = 8; // 最大图片类型数量

  GameModel({this.rows = 8, this.columns = 8}) {
    initializeBoard();
  }

  void initializeBoard() {
    // 创建配对的数字，只使用1-8
    List<int> numbers = [];
    for (int i = 1; i <= maxTileTypes; i++) {
      // 计算每种图片需要多少对
      int pairsNeeded = (rows * columns) ~/ (2 * maxTileTypes);
      for (int j = 0; j < pairsNeeded * 2; j++) {
        numbers.add(i);
      }
    }

    numbers.shuffle(Random());

    board = List.generate(
        rows,
        (i) => List.generate(columns, (j) {
              return numbers[i * columns + j];
            }));

    remainingPairs = (rows * columns) ~/ 2;
  }

  bool canConnect(int row1, int col1, int row2, int col2) {
    if (board[row1][col1] != board[row2][col2]) return false;
    if (row1 == row2 && col1 == col2) return false;

    // 检查直接连接（一条直线）
    if (isDirectlyConnected(row1, col1, row2, col2)) {
      return true;
    }

    // 检查一个拐点连接（两条直线）
    if (isOneCornerConnected(row1, col1, row2, col2)) {
      return true;
    }

    // 检查两个拐点连接（三条直线）
    if (isTwoCornersConnected(row1, col1, row2, col2)) {
      return true;
    }

    return false;
  }

  bool isDirectlyConnected(int row1, int col1, int row2, int col2) {
    // horizontal
    if (row1 == row2) {
      int start = min(col1, col2);
      int end = max(col1, col2);
      for (int i = start + 1; i < end; i++) {
        if (board[row1][i] != 0) return false;
      }
      return true;
    }

    // Vertical
    if (col1 == col2) {
      int start = min(row1, row2);
      int end = max(row1, row2);
      for (int i = start + 1; i < end; i++) {
        if (board[i][col1] != 0) return false;
      }
      return true;
    }

    return false;
  }

  bool isOneCornerConnected(int row1, int col1, int row2, int col2) {
    // 检查通过中间点(row1, col2)的连接
    if (board[row1][col2] == 0 &&
        isDirectlyConnected(row1, col1, row1, col2) &&
        isDirectlyConnected(row1, col2, row2, col2)) {
      return true;
    }

    // 检查通过中间点(row2, col1)的连接
    if (board[row2][col1] == 0 &&
        isDirectlyConnected(row1, col1, row2, col1) &&
        isDirectlyConnected(row2, col1, row2, col2)) {
      return true;
    }

    return false;
  }

  bool isTwoCornersConnected(int row1, int col1, int row2, int col2) {
    // 检查所有可能的两个拐点连接
    for (int i = 0; i < rows; i++) {
      if (board[i][col1] == 0 && board[i][col2] == 0) {
        if (isDirectlyConnected(row1, col1, i, col1) &&
            isDirectlyConnected(i, col1, i, col2) &&
            isDirectlyConnected(i, col2, row2, col2)) {
          return true;
        }
      }
    }

    for (int j = 0; j < columns; j++) {
      if (board[row1][j] == 0 && board[row2][j] == 0) {
        if (isDirectlyConnected(row1, col1, row1, j) &&
            isDirectlyConnected(row1, j, row2, j) &&
            isDirectlyConnected(row2, j, row2, col2)) {
          return true;
        }
      }
    }

    return false;
  }

  void selectTile(int row, int col) {
    if (board[row][col] == 0) return;

    if (selectedTile == null) {
      selectedTile = row * columns + col;
    } else {
      int firstRow = selectedTile! ~/ columns;
      int firstCol = selectedTile! % columns;

      if (canConnect(firstRow, firstCol, row, col)) {
        board[firstRow][firstCol] = 0;
        board[row][col] = 0;
        score += 10;
        remainingPairs--;
      }

      selectedTile = null;
    }
  }

  bool isGameOver() {
    return remainingPairs == 0;
  }
}
