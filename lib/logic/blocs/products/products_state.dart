part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<Product> products;

  const ProductsSuccess(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsFail extends ProductsState {
  final int statusCode;
  final String message;

  const ProductsFail(this.statusCode, this.message);

  @override
  List<Object> get props => [statusCode, message];
}
