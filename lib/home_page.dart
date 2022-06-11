import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'choose_difficulty.dart';
import 'providers/sudoku_grid.dart';
import 'input_keys.dart';
import 'row_item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<List<int>> sudokuValues = [];
  late SudokuGrid sudokuData;

  void updateDifficulty(
    BuildContext ctx,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.only(
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: ChooseDifficulty(
                difficulty: sudokuData.difficulty,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sudokuData = Provider.of<SudokuGrid>(context);
    sudokuData.init();
    sudokuValues = sudokuData.getGrid();

    if (sudokuData.isError && sudokuData.errorMessageCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sudoku property doesnot hold!'),
            duration: Duration(seconds: 2),
          ));
          sudokuData.incrementErrorMessageCount();
        },
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              'Sudoku',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => updateDifficulty(context),
                      child: Text(
                        'Choose Difficulty',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        sudokuData.solveSudoku();
                      },
                      child: Text(
                        'Auto Solve',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                children: [
                  RowItem(r1: 0, r2: 3),
                  RowItem(r1: 3, r2: 6),
                  RowItem(r1: 6, r2: 9),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: InputKeys(),
            ),
            if (sudokuData.isComplete())
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'The sudoku has been solved completely!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<SudokuGrid>(context, listen: false)
                              .init(reset: true);
                        },
                        child: Text(
                          'RESET',
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
