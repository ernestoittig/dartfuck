import 'package:test/test.dart';

import 'package:dartfuck/dartfuck.dart';

void main() {
  group('CellArray', () {
    test('constructor creates an empty CellArray', () {
      var cellArray = CellArray();
      expect(cellArray.pointer, equals(0));
      expect(cellArray.readCell(), equals(0));
      expect(cellArray.readCellAsString(), equals("\x00"));
    });
    test('next and previousCell() moves the pointer', () {
      var cellArray = CellArray();
      expect(cellArray.nextCell(), equals(1));
      expect(cellArray.pointer, equals(1));
      expect(cellArray.previousCell(), equals(0));
      expect(cellArray.pointer, equals(0));
    });
    test('readCell() and readCellAsString() read from the cell', () {
      var cellArray = CellArray();
      expect(cellArray.readCell(), equals(0));
      expect(cellArray.readCellAsString(), equals("\x00"));
      expect(cellArray.addToCell(), equals(1));
      expect(cellArray.readCell(), equals(1));
      expect(cellArray.readCellAsString(), equals("\x01"));
    });
    test('add and subToCell() increase and decrease the value in th current cell', () {
      var cellArray = CellArray();
      expect(cellArray.addToCell(), equals(1));
      for (var i = 0; i < 32; ++i) {
        cellArray.addToCell();
      }
      expect(cellArray.readCell(), equals(33));
      expect(cellArray.readCellAsString(), equals('!'));
      expect(cellArray.subToCell(), equals(32));
      expect(cellArray.readCellAsString(), equals(' '));
    });
    test('writeToCell() writes a value to the current cell', () {
      var cellArray = CellArray();
      expect(cellArray.writeToCell(32), equals(32));
      expect(cellArray.readCellAsString(), equals(' '));
    });
    test('next and previousCell() throws RangeError if selected cell is out of bounds', () {
      var cellArray = CellArray();
      expect(cellArray.previousCell, throwsRangeError);
      for (var i = 0; i < 29999; ++i) {
        cellArray.nextCell();
      }
      expect(cellArray.nextCell, throwsRangeError);
    });
  });
}