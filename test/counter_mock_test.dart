import 'package:flutter_mimicon_hyperhire_test/counter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'counter_mock_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([Counter])
void main() {
  late MockCounter counter = MockCounter();
  group('Counter tests', () {
    test('The method is mocked so, calling increment qill return 1000',
        () async {
      when(counter.increment()).thenAnswer((_) {
        return 1000;
      });
      expect(counter.increment(), 1000);
    });

    test('The method is mocked so, calling decrement qill return 1000',
        () async {
      when(counter.decrement()).thenAnswer((_) {
        return -1000;
      });
      expect(counter.decrement(), -1000);
    });
  });
}
