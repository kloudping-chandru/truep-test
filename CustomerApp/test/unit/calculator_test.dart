// test/unit/calculator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:trupressed_subscription/calculator.dart';

void main() {
  group('Calculator', () {
    final calculator = Calculator();

    test('adds two numbers', () {
      expect(calculator.add(2, 3), 5);
    });

    test('subtracts two numbers', () {
      expect(calculator.subtract(5, 3), 2);
    });
  });
}
