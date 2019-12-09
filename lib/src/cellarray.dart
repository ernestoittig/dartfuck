import 'dart:convert';
import 'dart:typed_data';

/// An array of byte-sized cells
class CellArray {
  final _list = ByteData.view(Uint8List(30000).buffer);
  /// A pointer to the current cell to read and write to
  int pointer = 0;

  /// Create an array of 30.000 cells with 0 in them
  CellArray();

  /// Move the pointer forward one cell
  int nextCell() {
    // We read the value at the next position so if it is out of bounds
    // it will throw a RangeError
    _list.getUint8(pointer+1);
    return ++pointer;
  }
  
  /// Move the pointer backwards one cell
  int previousCell() {
    _list.getUint8(pointer-1);
    return --pointer;
  }

  /// Add 1 to the current cell
  int addToCell() {
    _list.setUint8(pointer, _list.getUint8(pointer) + 1);
    return _list.getUint8(pointer);
  }

  /// Subtract 1 to the current cell
  int subToCell() {
    _list.setUint8(pointer, _list.getUint8(pointer) - 1);
    return _list.getUint8(pointer);
  }

  /// Read the value in the current cell
  int readCell() => _list.getUint8(pointer);

  /// Read the value of the current cell transformed to a string
  /// 
  /// Keep in mind that this reads cell-by-cell using [Utf8Codec.decode]
  /// so it is not recommended and it should only be used with single-byte characters
  String readCellAsString() => utf8.decode([_list.getUint8(pointer)]);

  /// Write [value] to the current cell
  int writeToCell(int value)  {
    _list.setUint8(pointer, value);
    return _list.getUint8(pointer);
  }
}