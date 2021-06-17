import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/api/product_api.dart';
import 'package:chopper_test/data/converters/test_converter.dart';
import 'package:chopper_test/data/model/product.dart';
import 'package:chopper_test/logic/blocs/auth/auth_bloc.dart';
import 'package:chopper_test/utils/two_way_isolate.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  late ProductApiService productApiService;
  late StreamSubscription<AuthState> subs;
  late TwoWayIsolate _twoWayIsolate;
  ProductsBloc({required AuthBloc authBloc}) : super(ProductsLoading()) {
    initServices(authBloc);
  }

  Future<void> initServices(authBloc) async {
    productApiService = (await ApiService.create(token: authBloc.state.token))
        .getService<ProductApiService>();
    add(ProductsGetAll());
    subs = authBloc.stream.listen((event) async {
      productApiService = (await ApiService.create(token: event.token))
          .getService<ProductApiService>();
      add(ProductsGetAll());
    });
  }

  static dynamic onIsolate(message) async {
    if (message['action'] == 'FETCH_PRODUCTS') {
      final Response<List<Product>> response =
          await (await ApiService.create(token: message['token']))
              .getService<ProductApiService>()
              .getProducts();
      if (response.isSuccessful) {
        return {
          'action': 'FETCH_PRODUCTS_SUCCESS',
          'payload': response.body ?? []
        };
      } else {
        return {
          'action': 'FETCH_RPODUCTS_FAILED',
        };
      }
    }
  }

  @override
  Future<void> close() {
    subs.cancel();
    _twoWayIsolate.close();
    return super.close();
  }

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is ProductsGetAll) {
      yield* _mapGetProductsToState(event);
    } else if (event is ProductsGetAllIsolate) {
      yield* _mapGetProductsIsolateToState(event);
    }
  }

  Stream<ProductsState> _mapGetProductsIsolateToState(
      ProductsGetAllIsolate event) async* {
    yield ProductsSuccess(event.products);
  }

  Stream<ProductsState> _mapGetProductsToState(ProductsGetAll event) async* {
    yield ProductsLoading();

    try {
      final Response<List<Product>> response =
          await productApiService.getProducts();
      if (response.isSuccessful) {
        final List<Product> products = response.body ?? [];
        yield ProductsSuccess(products);
      } else {
        yield ProductsFail(
            response.statusCode, (response.error as RequestError).message);
      }
    } catch (e) {
      if (e is SocketException) {
        yield ProductsFail(e.osError!.errorCode, e.osError!.message);
      } else {
        yield ProductsFail(0, 'Error');
      }
    }
  }
}
