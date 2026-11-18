import 'package:flutter_test/flutter_test.dart';
import 'package:onlinezah/models.dart';

void main() {
  test('Зарын төрлийн нэрс зөв', () {
    expect(Kind.sell.label, 'Зарна');
    expect(Kind.swap.label, 'Солилцоно');
    expect(Kind.free.label, 'Үнэгүй');
  });
}
