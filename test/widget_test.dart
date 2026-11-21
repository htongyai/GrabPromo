import 'package:flutter_test/flutter_test.dart';
import 'package:grabpromogame/util.dart';

void main() {
  test('formatDuration renders seconds and hundredths', () {
    expect(formatDuration(0), '—');
    expect(formatDuration(7), '00.00 s');
    expect(formatDuration(12345), '12.34 s');
    expect(formatDuration(9050), '09.05 s');
  });
}
