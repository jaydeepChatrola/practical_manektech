import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_manektech/bloc/shopping/shopping_event.dart';
import 'package:practical_manektech/bloc/shopping/shopping_state.dart';
import 'package:practical_manektech/model/product_list_model.dart';

import '../../repository/shopping_repository.dart';

class ShoppingBloc extends Bloc<ProductEvent, ProductState> {
  int page = 1;
  bool isLoading = false;
  bool shouldLoadMore = true;
  var products = <Products>[];

  ShoppingBloc({required this.shoppingRepository}) : super(LoadingProduct()) {
    on<FetchProduct>(_onFetch);
    on<FetchMore>(_onFetchMore);
  }

  final ShoppingRepository shoppingRepository;

  Future<void> _onFetch(FetchProduct event, Emitter<ProductState> emit) async {
    emit(LoadingProduct());
    try {
      var param = <String, dynamic>{"page": page, "perPage": 5};
      final items = await shoppingRepository.getProducts(param);
      products.addAll(items.data!);
      if (items.totalRecord == products.length) {
        shouldLoadMore = false;
      }
      emit(LoadedProduct(product: products));
    } catch (_) {
      emit(LoadError());
    }
  }

  Future<void> _onFetchMore(FetchMore event, Emitter<ProductState> emit) async {
    if (!shouldLoadMore) {
      emit(NoProduct());
      return;
    }
    if (isLoading) {
      return;
    } else {
      isLoading = true;
      emit(LoadedProduct(isFetching: true));
      try {
        page = page + 1;
        var param = <String, dynamic>{"page": page, "perPage": 5};
        final items = await shoppingRepository.getProducts(param);
        products.addAll(items.data!);
        if (items.totalRecord == products.length) {
          shouldLoadMore = false;
        }
        isLoading = false;
        emit(LoadedProduct(product: products, isFetching: false));
      } catch (_) {
        isLoading = false;
        emit(LoadError());
      }
    }
  }
}
