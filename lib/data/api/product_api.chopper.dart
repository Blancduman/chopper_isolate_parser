part of 'product_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$LocationApiService extends LocationApiService {
  _$LocationApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = LocationApiService;

  @override
  Future<Response<List<Location>>> getLocations() {
    final $url = '/locations/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Location>, Location>($request);
  }

  @override
  Future<Response<Location>> getLocation(int? id) {
    final $url = '/locations/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Location, Location>($request);
  }
}

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ProductApiService extends ProductApiService {
  _$ProductApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProductApiService;

  @override
  Future<Response<List<Product>>> getProducts() {
    final $url = '/products/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Product>, Product>($request);
  }

  @override
  Future<Response<Product>> getProduct(int? id) {
    final $url = '/products/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Product, Product>($request);
  }
}

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$AuthApiService extends AuthApiService {
  _$AuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AuthApiService;

  @override
  Future<Response<Auth>> login(String email, String password) {
    final $url = '/auth/login';
    final $body = <String, dynamic>{'email': email, 'password': password};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Auth, Auth>($request);
  }

  @override
  Future<Response<Auth>> register(String email, String password) {
    final $url = '/auth/register';
    final $body = <String, dynamic>{'email': email, 'password': password};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Auth, Auth>($request);
  }
}
