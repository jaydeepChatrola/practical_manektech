import 'package:flutter/material.dart';
import 'package:practical_manektech/bloc/cart/cart_bloc.dart';
import 'package:practical_manektech/bloc/cart/cart_event.dart';
import 'package:practical_manektech/ui/cart_page.dart';
import 'package:practical_manektech/ui/shopping_mall_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/shopping/shopping_bloc.dart';
import '../bloc/shopping/shopping_event.dart';
import '../repository/shopping_repository.dart';

class RouteName {
  static const String root = "/";
  static const String cartPage = "/cart_page";
}

class Routes {
  static final baseRoutes = <String, WidgetBuilder>{
    RouteName.root: (context) => BlocProvider(
        create: (context) =>
            ShoppingBloc(shoppingRepository: ShoppingRepository())
              ..add(FetchProduct()),
        child: const ShoppingMall()),
    RouteName.cartPage: (context) => BlocProvider(
        create: (_) => CartBloc()..add(FetchCart()), child: const CartPage()),
  };
}
