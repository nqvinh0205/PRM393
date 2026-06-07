import 'dart:async';

class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}

class ProductRepository {
  final List<Product> _products = [];
  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    return _products;
  }

  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product);
  }

  void dispose() {
    _controller.close();
  }
}

Future<void> main() async {
  final repo = ProductRepository();

  repo.liveAdded().listen((product) {
    print('New product added: $product');
  });

  repo.addProduct(Product(1, 'Laptop', 1200.0));
  repo.addProduct(Product(2, 'Mouse', 25.5));

  final products = await repo.getAll();

  print('All products:');
  for (var product in products) {
    print(product);
  }

  repo.dispose();
}
