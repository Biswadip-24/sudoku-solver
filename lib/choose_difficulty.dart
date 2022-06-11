import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/providers/sudoku_grid.dart';

class ChooseDifficulty extends StatefulWidget {
  Difficulty difficulty;
  ChooseDifficulty({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<ChooseDifficulty> createState() => _ChooseDifficultyState();
}

class _ChooseDifficultyState extends State<ChooseDifficulty> {
  void _updateDifficulty() {
    Provider.of<SudokuGrid>(context, listen: false)
        .init(reset: true, difficulty: widget.difficulty);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            'Choose Difficulty ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          RadioListTile(
            value: Difficulty.Beginner,
            groupValue: widget.difficulty,
            onChanged: (Difficulty? value) {
              setState(() {
                widget.difficulty = value!;
              });
            },
            title: const Text('Beginner'),
          ),
          RadioListTile(
            value: Difficulty.Easy,
            groupValue: widget.difficulty,
            onChanged: (Difficulty? value) {
              setState(() {
                widget.difficulty = value!;
              });
            },
            title: const Text('Easy'),
          ),
          RadioListTile(
            value: Difficulty.Medium,
            groupValue: widget.difficulty,
            onChanged: (Difficulty? value) {
              setState(() {
                widget.difficulty = value!;
              });
            },
            title: const Text('Medium'),
          ),
          RadioListTile(
            value: Difficulty.Hard,
            groupValue: widget.difficulty,
            onChanged: (Difficulty? value) {
              setState(() {
                widget.difficulty = value!;
              });
            },
            title: const Text('Hard'),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: _updateDifficulty,
              child: const Text('SAVE'),
            ),
          )
        ],
      ),
    );
  }
}
