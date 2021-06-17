import 'package:chopper_test/data/model/auth.dart';
import 'package:chopper_test/data/model/location.dart';
import 'package:chopper_test/data/model/product.dart';

typedef T JsonFactory<T>(Map<String, dynamic> json);

class JsonFactories {
  static Map<Type, JsonFactory> factories = {
    Product: Product.fromJsonFactory,
    Location: Location.fromJsonFactory,
    Auth: Auth.fromJsonFactory,
  };
}
