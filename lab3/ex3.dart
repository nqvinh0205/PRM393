import 'dart:async';

void main() {
  print('1. Start');

  scheduleMicrotask(() {
    print('2. Microtask');
  });

  Future(() {
    print('3. Future event');
  });

  print('4. End');
}
