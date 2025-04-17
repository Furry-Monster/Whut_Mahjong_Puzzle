import 'dart:math';

class PathPoint {
  final int row;
  final int col;

  PathPoint(this.row, this.col);
}

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
    List<int> numbers = [];
    for (int i = 1; i <= maxTileTypes; i++) {
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

    if (isDirectlyConnected(row1, col1, row2, col2)) {
      return true;
    }

    if (isOneCornerConnected(row1, col1, row2, col2)) {
      return true;
    }

    if (isTwoCornersConnected(row1, col1, row2, col2)) {
      return true;
    }

    return false;
  }

  List<PathPoint> getConnectionPath(int row1, int col1, int row2, int col2) {
    List<PathPoint> path = [];

    if (isDirectlyConnected(row1, col1, row2, col2)) {
      return path; // 直接连接不需要中间点
    }

    if (board[row1][col2] == 0 &&
        isDirectlyConnected(row1, col1, row1, col2) &&
        isDirectlyConnected(row1, col2, row2, col2)) {
      path.add(PathPoint(row1, col2));
      return path;
    }

    if (board[row2][col1] == 0 &&
        isDirectlyConnected(row1, col1, row2, col1) &&
        isDirectlyConnected(row2, col1, row2, col2)) {
      path.add(PathPoint(row2, col1));
      return path;
    }

    for (int i = 0; i < rows; i++) {
      if (board[i][col1] == 0 && board[i][col2] == 0) {
        if (isDirectlyConnected(row1, col1, i, col1) &&
            isDirectlyConnected(i, col1, i, col2) &&
            isDirectlyConnected(i, col2, row2, col2)) {
          path.add(PathPoint(i, col1));
          path.add(PathPoint(i, col2));
          return path;
        }
      }
    }

    for (int j = 0; j < columns; j++) {
      if (board[row1][j] == 0 && board[row2][j] == 0) {
        if (isDirectlyConnected(row1, col1, row1, j) &&
            isDirectlyConnected(row1, j, row2, j) &&
            isDirectlyConnected(row2, j, row2, col2)) {
          path.add(PathPoint(row1, j));
          path.add(PathPoint(row2, j));
          return path;
        }
      }
    }

    return path;
  }

  bool isDirectlyConnected(int row1, int col1, int row2, int col2) {
    if (row1 == row2) {
      int start = min(col1, col2);
      int end = max(col1, col2);
      for (int i = start + 1; i < end; i++) {
        if (board[row1][i] != 0) return false;
      }
      return true;
    }

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
    if (board[row1][col2] == 0 &&
        isDirectlyConnected(row1, col1, row1, col2) &&
        isDirectlyConnected(row1, col2, row2, col2)) {
      return true;
    }

    if (board[row2][col1] == 0 &&
        isDirectlyConnected(row1, col1, row2, col1) &&
        isDirectlyConnected(row2, col1, row2, col2)) {
      return true;
    }

    return false;
  }

  bool isTwoCornersConnected(int row1, int col1, int row2, int col2) {
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
