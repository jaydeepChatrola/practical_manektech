import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_manektech/bloc/shopping/shopping_bloc.dart';
import 'package:practical_manektech/bloc/shopping/shopping_event.dart';
import 'package:practical_manektech/bloc/shopping/shopping_state.dart';
import 'package:practical_manektech/helper/app_manager.dart';
import 'package:practical_manektech/helper/string_constant.dart';
import 'package:practical_manektech/model/product_list_model.dart';

import '../helper/routes.dart';
import '../helper/theme_helper.dart';

class ShoppingMall extends StatefulWidget {
  const ShoppingMall({Key? key}) : super(key: key);

  @override
  State<ShoppingMall> createState() => _ShoppingMallState();
}

class _ShoppingMallState extends State<ShoppingMall> {
  late AppThemeState _appThemeState;
  late ShoppingBloc shoppingBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shoppingBloc = BlocProvider.of<ShoppingBloc>(context);
    shoppingBloc.stream.listen((event) {
      if (event is NoProduct) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(StringConstant.noMoreData)));
      }
    });
    _scrollController.addListener(() {
      var value = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (value < 80) {
        shoppingBloc.add(FetchMore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _appThemeState = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(StringConstant.shoppingMall),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteName.cartPage);
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return BlocBuilder<ShoppingBloc, ProductState>(
            builder: (context, productState) {
          if (productState is LoadingProduct) {
            return const Center(child: CircularProgressIndicator());
          } else if (productState is LoadedProduct || productState is NoProduct) {
            return ListView(
              controller: _scrollController,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: shoppingBloc.products.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var data = shoppingBloc.products[index];
                    return buildItem(data, _appThemeState);
                  },
                ),
                (productState is LoadedProduct)
                    ? productState.isFetching
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const Offstage()
                    : const Offstage(),
              ],
            );
          } else if (ProductState is LoadError) {
            return const Text(StringConstant.errorProduct);
          }
          return const SizedBox();
        });
      }),
    );
  }

  Widget buildItem(Products data, AppThemeState appTheme) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(13)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 3),
          Expanded(
              child: Center(
                  child: Image.network(
            data.featuredImage ?? "",
            fit: BoxFit.fill,
          ))),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: appTheme.getResponsiveWidth(32)),
                  child: Text(
                    data.title ?? '',
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    AppManager.getInstance()
                        ?.getSqlHelper()
                        .insertToCart(data)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(StringConstant.itemAddedToCart)));
                    });
                  },
                  icon: const Icon(Icons.add_shopping_cart)),
              const SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }
}
