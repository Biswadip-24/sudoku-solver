import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/providers/sudoku_grid.dart';

class InputKeys extends StatelessWidget {
  static const List<int> input = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  const InputKeys({Key? key}) : super(key: key);

  Widget getInputButton(int num, BuildContext context) {
    return Expanded(
      child: Container(
        //padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(8.0)),
        child: TextButton(
          onPressed: () {
            var gridData = Provider.of<SudokuGrid>(context, listen: false);
            if (gridData.isError && (gridData.selectedRow != gridData.errorRow && gridData.selectedColumn != gridData.errorCol)) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Rectify the invalid cell to continue!'),
                duration: Duration(seconds: 2),
              ));
              gridData.incrementErrorMessageCount();
              return;
            }
            gridData.updateGrid(
                gridData.selectedRow, gridData.selectedColumn, num);
          },
          child: Text(
            num.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              //fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [...input.map((e) => getInputButton(e, context))],
    );
  }
}
