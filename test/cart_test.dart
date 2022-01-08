import 'package:kio/kio.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('succeedNow creation', () {
    Kio<int> program = Kio.succeedNow(1);

    program.run((p0) {
      expect(p0, 1);
    });
  });
  test('delayed success', () {
    Kio<int> program = Kio.succeed(() => 1);

    program.run((p0) {
      expect(p0, 1);
    });
  });
  test('zip two program', () {
    Kio<int> first = Kio.succeed(() => 2);
    Kio<int> second = Kio.succeed(() => 1);

    first.zipWith(second).run((p0) {
      expect(p0, Tuple2(2, 1));
    });
  });

  test('map program', () {
    Kio<int> first = Kio.succeed(() => 2);
    Kio<int> second = Kio.succeed(() => 1);

    first.zipWith(second).map((p0) => p0.item1 + p0.item2).run((p0) {
      expect(p0, 3);
    });
  });
}
