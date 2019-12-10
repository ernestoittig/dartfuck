export 'src/cellarray.dart';

/// A helper class with byte representations of Brainfuck commands
abstract class NumCodes {
  // ignore: public_member_api_docs
  static const greaterThan = 0x3e,
      // ignore: public_member_api_docs
      lessThan = 0x3c,
      // ignore: public_member_api_docs
      plus = 0x2b,
      // ignore: public_member_api_docs
      hyphen = 0x2d,
      // ignore: public_member_api_docs
      dot = 0x2e,
      // ignore: public_member_api_docs
      comma = 0x2c,
      // ignore: public_member_api_docs
      leftBracket = 0x5b,
      // ignore: public_member_api_docs
      rightBracket = 0x5d;

  /// A [List] with the byte representation of all Brainfuck commands
  static const commands = [0x3e, 0x3c, 0x2b, 0x2d, 0x2e, 0x2c, 0x5b, 0x5d];
}
