import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/grid.dart';

import 'providers/sudoku_grid.dart';

class RowItem extends StatelessWidget {
  late List<List<int>> gridRow;
  int r1, r2;

  RowItem({
    Key? key,
    required this.r1,
    required this.r2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gridRow = Provider.of<SudokuGrid>(context).getGrid().sublist(r1, r2);

    return Row(
      children: [
        Grid(r1 : r1, c1 : 0, r2 : r2,c2 : 3),
        Grid(r1 : r1, c1 : 3, r2 : r2,c2 : 6),
        Grid(r1 : r1, c1 : 6, r2 : r2,c2 : 9),
      ],
    );
  }
}
