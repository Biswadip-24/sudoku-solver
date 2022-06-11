import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/providers/sudoku_grid.dart';

class Grid extends StatelessWidget {
  late List<List<int>> gridValues;
  List<List<Widget>> gridWidget = [];
  late SudokuGrid gridData;
  int r1, c1, r2, c2;

  Grid({
    Key? key,
    required this.r1,
    required this.c1,
    required this.r2,
    required this.c2,
  }) : super(key: key);

  Widget getCell(int i, int j) {
    bool isHighlighted =
        gridData.selectedRow == (r1 + i) || gridData.selectedColumn == (c1 + j);
    bool isSelected =
        gridData.selectedRow == (r1 + i) && gridData.selectedColumn == (c1 + j);

    bool isSameGrid = ((gridData.selectedRow ~/ 3) == ((r1 + i) ~/ 3)) &&
        ((gridData.selectedColumn ~/ 3) == ((c1 + j) ~/ 3));

    bool isErrorCell =
        (gridData.errorRow == (r1 + i)) && (gridData.errorCol == (c1 + j));

    Color cellColor;
    if (isHighlighted && !isSelected) {
      cellColor = Colors.black.withOpacity(0.1);
    } else if (isSameGrid && !isSelected) {
      cellColor = Colors.black.withOpacity(0.1);
    } else if (isErrorCell) {
      cellColor = Colors.red.withOpacity(0.5);
    } else if (isSelected) {
      cellColor = Colors.amber.shade100;
    } else {
      cellColor = Colors.white;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 0.25),
          color: cellColor,
        ),
        child: GestureDetector(
          onTap: (() {
            gridData.setSelectedCell(r1 + i, c1 + j);
          }),
          child: Text(
            gridValues[i][j] == 0 ? '' : gridValues[i][j].toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget getRow(List<Widget> values) {
    return Row(
      children: values.map((e) => e).toList(),
    );
  }

  List<List<int>> getGrid(int start, int end, List<List<int>> gridRow) {
    List<List<int>> grid = [];
    for (var item in gridRow) {
      grid.add(item.sublist(start, end));
    }
    return grid;
  }

  void extractGrid(int r1, int c1, int r2, int c2, BuildContext context) {
    gridData = Provider.of<SudokuGrid>(context);
    var grid = gridData.getGrid().sublist(r1, r2);
    gridValues = getGrid(c1, c2, grid);
  }

  void constructGridWidget() {
    for (int i = 0; i < gridValues.length; i++) {
      List<Widget> row = [];
      for (int j = 0; j < gridValues[i].length; j++) {
        row.add(getCell(i, j));
      }
      gridWidget.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    extractGrid(r1, c1, r2, c2, context);
    constructGridWidget();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 1)),
        child: Column(
          children: gridWidget.map((e) => getRow(e)).toList(),
          //children: gridValues.asMap().forEach((key, value) ),
        ),
      ),
    );
  }
}
