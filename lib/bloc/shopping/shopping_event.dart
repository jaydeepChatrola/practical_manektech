import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {}

class FetchProduct extends ProductEvent {
  @override
  List<Object> get props => [];
}

class FetchMore extends ProductEvent {
  @override
  List<Object> get props => [];
}
