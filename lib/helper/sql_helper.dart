import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:practical_manektech/helper/sql_constant.dart';
import 'package:sqflite/sqflite.dart';

import '../model/cart.dart';
import '../model/product_list_model.dart';

class SqlHelper {
  late Database database;

  init() async {
    openDatabase(
      join(await getDatabasesPath(), 'manektech.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS ${SqlConstants.cartTable} '
          '(${SqlConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${SqlConstants.productId} INTEGER, '
          '${SqlConstants.productQuantity} INTEGER, '
          '${SqlConstants.cartDetail} VARCHAR)',
        );
      },
      version: 1,
    ).then((value) => database = value);
  }

  Future<int> removeCartItems(String id) async {
    return await database.rawDelete(
        'DELETE FROM ${SqlConstants.cartTable} WHERE ${SqlConstants.productId} = ?',
        [id]);
  }

  Future<int> insertToCart(Products cartDetail) async {
    var data = <String, String>{};
    data[SqlConstants.cartDetail] = jsonEncode(cartDetail);
    data[SqlConstants.productId] = cartDetail.id.toString();
    data[SqlConstants.productQuantity] = "1";

    var cartItem = await database.query(SqlConstants.cartTable,
        where: '${SqlConstants.productId} = ?',
        whereArgs: [cartDetail.id.toString()]);
    if (cartItem.isEmpty) {
      return await database.insert(
        SqlConstants.cartTable,
        data,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      updateCart(cartDetail);
      return 0;
    }
  }

  Future<List<Cart>> getCartItems() async {
    var data = await database.query(SqlConstants.cartTable);
    final list = <Cart>[];
    for (int i = 0; i < data.length; i++) {
      String product = data[i].values.toList()[3].toString();
      final values = json.decode(product);
      Cart cart = Cart(
          Products.fromJson(values), data[i].values.toList()[2].toString());
      list.add(cart);
    }
    debugPrint("List = ${list.length}");
    return list;
  }

  updateCart(Products cartDetail) async {
    var data = await database.query(SqlConstants.cartTable,
        columns: [SqlConstants.productQuantity],
        where: '${SqlConstants.productId} = ?',
        whereArgs: [cartDetail.id.toString()]);
    debugPrint('data = $data');
    String productQuantity = data[0].values.toList()[0].toString();
    return await database.rawUpdate(
        'UPDATE ${SqlConstants.cartTable} SET ${SqlConstants.productQuantity} = ? WHERE ${SqlConstants.productId} = ?',
        [int.parse(productQuantity) + 1, cartDetail.id]);
  }
}
