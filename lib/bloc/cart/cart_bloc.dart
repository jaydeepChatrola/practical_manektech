import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_manektech/bloc/cart/cart_event.dart';
import 'package:practical_manektech/bloc/cart/cart_state.dart';
import 'package:practical_manektech/helper/app_manager.dart';

import '../../model/cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  var carts = <Cart>[];

  CartBloc() : super(LoadingCart()) {
    on<FetchCart>(_onFetch);
    on<RemoveCart>(_onRemoveCart);
  }

  Future<void> _onFetch(FetchCart event, Emitter<CartState> emit) async {
    carts.clear();
    emit(LoadingCart());
    try {
      final items =
          await AppManager.getInstance()?.getSqlHelper().getCartItems();
      carts.addAll(items!);
      String total = getGrandTotal().toString();
      emit(LoadedCart(cart: items, grandTotal: total));
    } catch (_) {
      emit(LoadError());
    }
  }

  int getGrandTotal() {
    var price = 0;
    for (int i = 0; i < carts.length; i++) {
      price += (carts[i].product!.price!) * int.parse(carts[i].quantity!);
    }
    return price;
  }

  Future<void> _onRemoveCart(RemoveCart event, Emitter<CartState> emit) async {
    try {
      await AppManager.getInstance()
          ?.getSqlHelper()
          .removeCartItems(event.id.toString());
      carts.removeAt(event.index);
      String total = getGrandTotal().toString();
      emit(LoadedCart(cart: carts, grandTotal: total));
    } catch (_) {
      emit(LoadError());
    }
  }
}
