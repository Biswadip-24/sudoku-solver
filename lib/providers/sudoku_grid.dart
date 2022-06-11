import 'package:flutter/material.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

enum Difficulty {
  Beginner,
  Easy,
  Medium,
  Hard,
}

class SudokuGrid with ChangeNotifier {
  List<List<int>> _sudokuValues = [];
  final List<List<int>> _initialGrid = [];
  final List<int> _emptySqaures = [18, 27, 36, 54];
  bool _error = false;
  int _errorMessageCount = 0;
  int _selectedRow = -3, _selectedCol = -3;
  int _errorRow = -1, _errorCol = -1;

  /*
  * Beginner - 0
  * Easy - 1
  * Medium - 2
  * Hard - 3
  */
  Difficulty _difficulty = Difficulty.Beginner;

  void init({
    bool reset = false,
    Difficulty? difficulty,
  }) {
    if (_sudokuValues.isNotEmpty && !reset) return;

    int diff = 0;
    if (difficulty != null) _difficulty = difficulty;

    if (_difficulty == Difficulty.Beginner) diff = 0;
    if (_difficulty == Difficulty.Easy) diff = 1;
    if (_difficulty == Difficulty.Medium) diff = 2;
    if (_difficulty == Difficulty.Hard) diff = 3;

    _sudokuValues =
        SudokuGenerator(emptySquares: _emptySqaures[diff]).newSudoku;

    for (int i = 0; i < 9; i++) {
      _initialGrid.add(List.from(_sudokuValues[i]));
    }

    _selectedRow = -3;
    _selectedCol = -3;
    _errorRow = -1;
    _errorCol = -1;
    _error = false;
    _errorMessageCount = 0;

    if (reset) notifyListeners();
  }

  void updateGrid(int row, int col, int value) {
    if (row < 0 || col < 0) return;

    if (_initialGrid[row][col] != 0) return;

    _sudokuValues[row][col] = value;
    if (!verifyGrid(row, col)) {
      _error = true;
      _errorMessageCount = 0;
      _errorRow = row;
      _errorCol = col;
    } else {
      _error = false;
      _errorCol = -1;
      _errorRow = -1;
    }

    notifyListeners();
  }

  bool verifyGrid(int r, int c) {
    for (int i = 0; i < 9; i++) {
      Set<int> s = {};
      int count = 0;
      for (int j = 0; j < 9; j++) {
        if (_sudokuValues[i][j] != 0) {
          count++;
          s.add(_sudokuValues[i][j]);
        }
        if (count != s.length) {
          return false;
        }
      }
    }

    for (int i = 0; i < 9; i++) {
      Set<int> s = {};
      int count = 0;
      for (int j = 0; j < 9; j++) {
        if (_sudokuValues[j][i] != 0) {
          count++;
          s.add(_sudokuValues[j][i]);
        }
        if (count != s.length) {
          return false;
        }
      }
    }

    int r1 = (r ~/ 3) * 3;
    int c1 = (c ~/ 3) * 3;

    int count = 0;
    Set<int> s = {};

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_sudokuValues[r1 + i][c1 + j] != 0) {
          count++;
          s.add(_sudokuValues[r1 + i][c1 + j]);
        }
      }
    }

    if (count != s.length) return false;

    return true;
  }

  bool isComplete() {
    for (int i = 1; i < 9; i++) {
      Set<int> s = {};
      for (int j = 0; j < 9; j++) {
        s.add(_sudokuValues[i][j]);
      }
      if (s.length != 9) return false;
    }
    return true;
  }

  void solveSudoku() {
    _sudokuSolve(0, 0);
    notifyListeners();
  }

  /*bool _sudokuSolve(int i, int j) {
    if (j == 9) {
      i++;
      j = 0;
    }

    if (i == 9) return true;

    if (_sudokuValues[i][j] != 0) return _sudokuSolve(i, j + 1);

    bool verified = false;
    bool pathPossible = false;
    bool continueChecking = true;

    for (int k = 1; k <= 9 && continueChecking && !pathPossible; k++) {
      _sudokuValues[i][j] = k;

      if (!verifyGrid(i, j)) continue;

      verified = true;

      if (!_sudokuSolve(i, j + 1)) {
        continue;
      } else {
        pathPossible = true;
      }
    }
    if (!verified || !pathPossible) _sudokuValues[i][j] = 0;
    return verified && pathPossible;
  }*/

  Future<bool> _sudokuSolve(int i, int j) async {
    if (j == 9) {
      i++;
      j = 0;
    }

    if (i == 9) return true;

    if (_sudokuValues[i][j] != 0) return _sudokuSolve(i, j + 1);

    bool verified = false;
    bool pathPossible = false;
    bool continueChecking = true;

    for (int k = 1; k <= 9 && continueChecking && !pathPossible; k++) {
      _sudokuValues[i][j] = k;
      _selectedRow = i;
      _selectedCol = j;
      notifyListeners();

      if (!verifyGrid(i, j)) continue;
      verified = true;

      await Future.delayed(const Duration(milliseconds: 300));

      await _sudokuSolve(i, j + 1).then((value) {
        if (value) {
          pathPossible = true;
        }
      });
    }
    if (!verified || !pathPossible) {
      _sudokuValues[i][j] = 0;
      _selectedRow = i;
      _selectedCol = j;
      notifyListeners();
    }
    return verified && pathPossible;
  }

  void incrementErrorMessageCount() {
    _errorMessageCount++;
  }

  bool get isError {
    return _error;
  }

  List<List<int>> getGrid() {
    return [..._sudokuValues];
  }

  void setSelectedCell(int r, int c) {
    _selectedRow = r;
    _selectedCol = c;
    notifyListeners();
  }

  Difficulty get difficulty {
    return _difficulty;
  }

  int get selectedRow {
    return _selectedRow;
  }

  int get selectedColumn {
    return _selectedCol;
  }

  int get errorMessageCount {
    return _errorMessageCount;
  }

  int get errorRow {
    return _errorRow;
  }

  int get errorCol {
    return _errorCol;
  }
}
