import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/providers/sudoku_grid.dart';

import 'home_page.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SudokuGrid(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sudoku',
        home: HomePage(),
      ),
    );
  }
}
