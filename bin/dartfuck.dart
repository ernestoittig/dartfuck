import 'dart:convert';
import 'dart:io';

import 'package:dartfuck/dartfuck.dart';

final String usage = """
dartfuck [-e string | script.bf | -]
If - or none are passed, then the program will be read from standard input""";

final List<int> commands = '><+-.,[]'.codeUnits;

int findClosingBracket(List<int> code) {
  var indexes = <int>[];
  for (var i = 0; i < code.length; ++i) {
    if (code[i] == 0x5b) {
      indexes.add(i);
    } else if (code[i] == 0x5d) {
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
  program = program.where(commands.contains).toList();

  var cellArray = CellArray();

  for (var i = 0; i < program.length; ++i) {
    switch (program[i]) {
      case 0x3e: // >
        cellArray.nextCell();
        break;
      case 0x3c: // <
        cellArray.previousCell();
        break;
      case 0x2b: // +
        cellArray.addToCell();
        break;
      case 0x2d: // -
        cellArray.subToCell();
        break;
      case 0x2e: // .
        stdout.writeCharCode(cellArray.readCell());
        break;
      case 0x2c: // ,
        cellArray.writeToCell(stdin.readByteSync());
        break;
      case 0x5b: // [
        if (cellArray.readCell() == 0) {
          i = program.indexOf(0x5d /*]*/, i);
        }
        break;
      case 0x5d: // ]
        if (cellArray.readCell() != 0) {
          i = findClosingBracket(program.sublist(0, i));
        }
    }
  }
}