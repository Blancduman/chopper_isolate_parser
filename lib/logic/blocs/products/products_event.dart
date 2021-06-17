part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsGetById extends ProductsEvent {
  final int id;

  const ProductsGetById(this.id);

  @override
  List<Object> get props => [id];
}

class ProductsGetAll extends ProductsEvent {}
class ProductsGetAllIsolate extends ProductsEvent {
  final List<Product> products;

  const ProductsGetAllIsolate(this.products);
  
  @override
  List<Object> get props => [products];
}