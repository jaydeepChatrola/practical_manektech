import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_manektech/bloc/cart/cart_bloc.dart';
import 'package:practical_manektech/bloc/cart/cart_event.dart';
import 'package:practical_manektech/bloc/cart/cart_state.dart';

import '../helper/string_constant.dart';
import '../helper/theme_helper.dart';
import '../model/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    AppThemeState appTheme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(StringConstant.myCart),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is LoadedCart) {
            return state.cart.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          itemCount: state.cart.length,
                          itemBuilder: (context, index) {
                            var data = state.cart[index];
                            return orientation == Orientation.portrait
                                ? _getCartItemPortrait(appTheme, data, index)
                                : _getCartItemLandScap(appTheme, data, index);
                          },
                        ),
                      ),
                      Container(
                        color: appTheme.primaryColor.withOpacity(0.5),
                        padding:
                            EdgeInsets.all(appTheme.getResponsiveWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(StringConstant.totalItems),
                                const SizedBox(width: 10),
                                Text(state.cart.length.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(StringConstant.grandTotal),
                                const SizedBox(width: 10),
                                Text("\$${state.grandTotal}"),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : const Center(child: Text(StringConstant.cartIsEmpty));
          }
          return const SizedBox();
        });
      }),
    );
  }

  Widget _getCartItemPortrait(AppThemeState appTheme, Cart? cart, int index) {
    return Padding(
      padding: EdgeInsets.only(
          left: appTheme.getResponsiveWidth(48),
          right: appTheme.getResponsiveWidth(48),
          bottom: appTheme.getResponsiveHeight(20)),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(appTheme.getResponsiveHeight(20)),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: appTheme.getResponsiveWidth(250),
                  height: appTheme.getResponsiveHeight(150),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(appTheme.getResponsiveHeight(20)),
                          bottomLeft: Radius.circular(
                              appTheme.getResponsiveHeight(20))),
                      image: DecorationImage(
                          image: NetworkImage(
                        cart?.product?.featuredImage ?? '',
                      ))),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: appTheme.getResponsiveWidth(45)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          cart?.product?.title ?? '',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(StringConstant.price),
                            const SizedBox(width: 8),
                            Text("\$${cart?.product?.price.toString() ?? ""}"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(StringConstant.quantity),
                            const SizedBox(width: 8),
                            Text(cart?.quantity.toString() ?? ''),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      context
                          .read<CartBloc>()
                          .add(RemoveCart(index, cart!.product!.id!));
                    },
                    icon: const Icon(Icons.delete)))
          ],
        ),
      ),
    );
  }

  Widget _getCartItemLandScap(AppThemeState appTheme, Cart? cart, int index) {
    return Padding(
      padding: EdgeInsets.only(
          left: appTheme.getResponsiveWidth(48),
          right: appTheme.getResponsiveWidth(48),
          bottom: appTheme.getResponsiveHeight(20)),
      child: Material(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(appTheme.getResponsiveHeight(20)),
        child: SizedBox(
          height: 90,
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(cart?.product?.featuredImage ?? ""),
                  /*Container(
                    width: appTheme.getResponsiveWidth(250),
                    height: appTheme.getResponsiveHeight(150),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(appTheme.getResponsiveHeight(20)),
                            bottomLeft: Radius.circular(
                                appTheme.getResponsiveHeight(20))),
                        image: DecorationImage(
                            image: NetworkImage(
                          cart?.product?.featuredImage ?? '',
                        ))),
                  ),*/
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.only(left: appTheme.getResponsiveWidth(45)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          cart?.product?.title ?? '',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(StringConstant.price),
                            const SizedBox(width: 8),
                            Text("\$${cart?.product?.price.toString() ?? ""}"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(StringConstant.quantity),
                            const SizedBox(width: 8),
                            Text(cart?.quantity.toString() ?? ''),
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(RemoveCart(index, cart!.product!.id!));
                      },
                      icon: const Icon(Icons.delete)))
            ],
          ),
        ),
      ),
    );
  }
}
