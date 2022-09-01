import 'package:equatable/equatable.dart';
import 'package:practical_manektech/model/product_list_model.dart';

abstract class ProductState extends Equatable {}

class LoadingProduct extends ProductState {
  @override
  List<Object> get props => [];
}

class LoadedProduct extends ProductState {
  final bool isFetching;
  final List<Products> product;
  LoadedProduct({this.product = const [], this.isFetching = false});
  @override
  List<Object> get props => [product];
}

class NoProduct extends ProductState {
  @override
  List<Object> get props => [];
}

class LoadError extends ProductState {
  @override
  List<Object> get props => [];
}
