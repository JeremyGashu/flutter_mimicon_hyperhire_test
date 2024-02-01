import 'package:flutter_mimicon_hyperhire_test/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Counter counter;
  group("Test the counter increment and decrement", () {
    test("Counter value should be incremented", () {
      counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    test("Counter value should be decremented", () {
      counter = Counter();
      counter.decrement();
      counter.decrement();
      expect(counter.value, -2);
    });
  });
}
