import 'dart:async';

void main() {
  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  numbers
    .map((number) => number * number)
    .where((square) => square % 2 == 0)
    .listen((value) {
      print(value);
    });
}
