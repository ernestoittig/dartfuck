import 'dart:convert';

/// The reason for a [BrainfuckException]
enum BrainfuckExceptionReason {
  /// Pointer is a negative number
  negativePointer,
  /// Pointer is >= 30000
  pointerTooBig,
}

/// A String representation of a [BrainfuckExceptionReason]
class ExceptionReasonString {
  /// A short precise message stating what went wrong
  final String head;

  /// An easy-to-understand reason of why it went wrong
  final String expanation;

  /// Create a reason string
  ExceptionReasonString(this.head, this.expanation);

  /// Create a reason string that explains [reason]
  ExceptionReasonString.fromReason(BrainfuckExceptionReason reason)
      : head = _getReasonHead(reason),
        expanation = _getReasonExpl(reason);

  static String _getReasonHead(BrainfuckExceptionReason reason) {
    switch (reason) {
      case BrainfuckExceptionReason.negativePointer:
        return 'Pointer is a negative number';
        break;
      case BrainfuckExceptionReason.pointerTooBig:
        return 'Pointer is too big';
    }
    return '';
  }

  static String _getReasonExpl(BrainfuckExceptionReason reason) {
    switch (reason) {
      case BrainfuckExceptionReason.negativePointer:
        return 'It seems somewhere in your program, a \'<\' made the pointer negative, which is not allowed';
        break;
      case BrainfuckExceptionReason.pointerTooBig:
        return 'It seems somewhere in your program, a \'>\' made the pointer >= 30,000, '
        'which is bigger that the cell array';
    }
    return '';
  }
}

/// Types of [BrainfuckException]
enum BrainfuckExceptionType {
  /// An exception that ocurred during the execution of the program
  runtime,

  /// An exception that ocurred during static analysis
  staticAnalysis,
}

/// A runtime exception trown by Dartfuck
class BrainfuckException implements Exception {
  /// The location the exception was thrown in
  final Location location;

  /// If color output is allowed
  final bool color;

  /// The reason the exception was thrown
  final BrainfuckExceptionReason reason;

  /// The type of exception
  final BrainfuckExceptionType type;

  /// Creates a new exception at [location] for [reason]
  BrainfuckException(this.location, this.reason,
      {this.color = false, this.type = BrainfuckExceptionType.runtime});

  // ignore: public_member_api_docs
  String get message => '$_shortMessage: $_longMessage';

  String get _shortMessage => ExceptionReasonString.fromReason(reason).head;

  String get _longMessage =>
      ExceptionReasonString.fromReason(reason).expanation;

  @override
  String toString() {
    var ret = '';
    var typeString = type == BrainfuckExceptionType.runtime
        ? 'Runtime error'
        : 'Analysis error';
    if (color) {
      ret += '\x1b[91m-- $typeString\x1b[m\n\n';
    } else {
      ret += '${typeString.toUpperCase()}\n';
    }

    ret += ExceptionReasonString.fromReason(reason).head;
    ret += color ? '\n\n' : '\n';

    var listStringOfBytes = utf8.decode(location.bytes).split('\n');

    if (color) {
      ret +=
          '\x1b[34m${location.line + 1}|\x1b[m ${listStringOfBytes[location.line]}\n';
      ret += ' ' * (location.col + (location.line.toString().length) + 2);
      ret += '\x1b[91m^\x1b[m\n\n';
    } else {
      ret += 'At ${location.line + 1}:${location.col + 1}\n';
    }

    ret += ExceptionReasonString.fromReason(reason).expanation;
    ret += color ? '\n\n' : '\n';
    return ret;
  }
}

/// A location in a source file
class Location {
  /// The offset of bytes the Location references
  final int offset;

  /// The list of bytes that this references
  final List<int> bytes;

  /// Create a new location at [offset] of [bytes]
  Location(this.offset, this.bytes);

  /// Get the line number of [offset]
  int get line => _findOffset();

  /// Get the column number of [offset]
  int get col => _findOffset(retCol: true);

  int _findOffset({bool retCol = false}) {
    var line = 0, col = 0, _offset = 0;
    while (_offset != offset) {
      if (bytes[_offset] == '\n'.codeUnitAt(0)) {
        ++line;
        col = 0;
      } else {
        ++col;
      }
      ++_offset;
    }
    return retCol ? col : line;
  }
}
