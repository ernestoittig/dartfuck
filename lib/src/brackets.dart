import 'package:dartfuck/dartfuck.dart';

/// Find the closing bracket to the open bracket at [opening]
///
/// [type] is the type of closing bracket. It's ] by default
int findClosingBracket(List<int> code, int opening,
    [int type = NumCodes.rightBracket]) {
  var closing = opening;
  var cont = 1;
  while (cont > 0) {
    var c = code[++closing];
    if (c == code[opening]) {
      ++cont;
    } else if (c == type) {
      --cont;
    }
  }
  return closing;
}

/// Find the opening bracket to the closing bracket at [closing]
///
/// [type] is the type of opening bracket. It's [ by default
int findOpeningBracket(List<int> code, int closing,
    [int type = NumCodes.leftBracket]) {
  var opening = closing;
  var cont = 1;
  while (cont > 0) {
    var c = code[--opening];
    if (c == type) {
      --cont;
    } else if (c == code[closing]) {
      ++cont;
    }
  }
  return opening;
}
