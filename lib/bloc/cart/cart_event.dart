import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {}

class FetchCart extends CartEvent {
  @override
  List<Object> get props => [];
}

class RemoveCart extends CartEvent {
  final int index;
  final int id;
  RemoveCart(this.index, this.id);
  @override
  List<Object> get props => [id, index];
}
