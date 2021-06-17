import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/converters/json_converter.dart';
import 'package:chopper_test/data/converters/test_converter.dart';
import 'package:chopper_test/data/model/auth.dart';
import 'package:chopper_test/data/model/location.dart';
import 'package:chopper_test/data/model/product.dart';

part 'product_api.chopper.dart';

@ChopperApi(baseUrl: '/locations')
abstract class LocationApiService extends ChopperService {
  @Get(path: '/')
  Future<Response<List<Location>>> getLocations();

  @Get(path: '{id}')
  Future<Response<Location>> getLocation(@Path('id') int? id);
}

@ChopperApi(baseUrl: '/products')
abstract class ProductApiService extends ChopperService {
  @Get(path: '/')
  Future<Response<List<Product>>> getProducts();

  @Get(path: '/{id}')
  Future<Response<Product>> getProduct(@Path('id') int? id);
}

@ChopperApi(baseUrl: '/auth')
abstract class AuthApiService extends ChopperService {
  @Post(path: '/login')
  Future<Response<Auth>> login(@Field() String email, @Field() String password);

  @Post(path: '/register')
  Future<Response<Auth>> register(@Field() String email, @Field() String password);
}

class ApiService {
  static JSONConvertor converter = JSONConvertor();
  static Future<ChopperClient> create({String? token}) async {
    if (!converter.loading) {
      await converter.initIsolate();
    }
    
    final converter2 = JsonSerializableConverter({
      Product: Product.fromJsonFactory,
      Location: Location.fromJsonFactory,
      Auth: Auth.fromJsonFactory,
    });

    Future<Request> authHeader(Request request) async => token != null ? applyHeader(
      request,
      "Authorization",
      "Bearer $token",
    ) : request;
    return ChopperClient(
      baseUrl: 'http://10.0.2.2:8000',
      services: [_$ProductApiService(), _$LocationApiService(), _$AuthApiService()],
      converter: converter,
      errorConverter: converter2,
      interceptors: [HttpLoggingInterceptor(), authHeader],
    );
  }
}