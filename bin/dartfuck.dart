import 'dart:convert';
import 'dart:io';

import 'package:dartfuck/dartfuck.dart';

final String usage = """
dartfuck [-e string | script.bf | -]
If - or none are passed, then the program will be read from standard input""";

int findClosingBracket(List<int> code) {
  var indexes = <int>[];
  for (var i = 0; i < code.length; ++i) {
    if (code[i] == NumCodes.leftBracket) {
      indexes.add(i);
    } else if (code[i] == NumCodes.rightBracket) {
      indexes.removeLast();
    }
  }
  return indexes.last;
}

void main(List<String> args) async {
  if (args.contains('-h') || args.contains('--help')) {
    print(usage);
    exit(0);
  }
  var program = <int>[];
  if (args.isEmpty || args[0] == '-') {
    await for (var line in stdin) {
      program.addAll(line);
    }
  } else if (args.length == 2 && args[0] == '-e') {
    program.addAll(utf8.encode(args[1]));
  } else if (args.length == 1 && !args[0].startsWith('-')) {
    if (File(args[0]).existsSync()) {
      try {
        program.addAll(File(args[0]).readAsBytesSync().toList());
      } on FileSystemException {
        print('File ${args[0]} is not readable');
        exit(66);
      }
    } else {
      print('File ${args[0]} doesn\'t exist');
      exit(66);
    }
  } else {
    print('Invalid arguments\n$usage');
    exit(64);
  }
  program = program.where(NumCodes.commands.contains).toList();

  var cellArray = CellArray();

  for (var i = 0; i < program.length; ++i) {
    switch (program[i]) {
      case NumCodes.greaterThan:
        cellArray.nextCell();
        break;
      case NumCodes.lessThan:
        cellArray.previousCell();
        break;
      case NumCodes.plus:
        cellArray.addToCell();
        break;
      case NumCodes.hyphen:
        cellArray.subToCell();
        break;
      case NumCodes.dot:
        stdout.writeCharCode(cellArray.readCell());
        break;
      case NumCodes.comma:
        cellArray.writeToCell(stdin.readByteSync());
        break;
      case NumCodes.leftBracket:
        if (cellArray.readCell() == 0) {
          i = program.indexOf(NumCodes.rightBracket, i);
        }
        break;
      case NumCodes.rightBracket:
        if (cellArray.readCell() != 0) {
          i = findClosingBracket(program.sublist(0, i));
        }
    }
  }
}
