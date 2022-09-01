import 'package:equatable/equatable.dart';

import '../../model/cart.dart';

abstract class CartState extends Equatable {}

class LoadingCart extends CartState {
  @override
  List<Object> get props => [];
}

class LoadedCart extends CartState {
  final List<Cart> cart;
  final String grandTotal;
  LoadedCart({this.cart = const <Cart>[], this.grandTotal = ""});
  @override
  List<Object> get props => [cart, grandTotal];
}

class LoadError extends CartState {
  @override
  List<Object> get props => [];
}
