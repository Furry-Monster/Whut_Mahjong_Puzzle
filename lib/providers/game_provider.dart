import 'package:flutter/foundation.dart';
import '../models/game_model.dart';

class GameProvider with ChangeNotifier {
  late GameModel _gameModel;
  bool _isGameOver = false;

  GameProvider() {
    _gameModel = GameModel();
  }

  GameModel get gameModel => _gameModel;
  bool get isGameOver => _isGameOver;

  void selectTile(int row, int col) {
    _gameModel.selectTile(row, col);
    _isGameOver = _gameModel.isGameOver();
    notifyListeners();
  }

  void restartGame() {
    _gameModel = GameModel();
    _isGameOver = false;
    notifyListeners();
  }

  bool canConnect(int row1, int col1, int row2, int col2) {
    return _gameModel.canConnect(row1, col1, row2, col2);
  }

  List<PathPoint> getConnectionPath(int row1, int col1, int row2, int col2) {
    return _gameModel.getConnectionPath(row1, col1, row2, col2);
  }
}
