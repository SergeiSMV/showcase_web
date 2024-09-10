


import 'package:freezed_annotation/freezed_annotation.dart';


part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
class CartModel with _$CartModel {
  const CartModel._();
  const factory CartModel({
    required Map<String, dynamic> cart,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);

  double get basePrice => cart['price']['base_price'] ?? 0;
  double get price => cart['price']['price'];
  double get totalPrice => cart['total'];
  List get pictures => cart['pictures'] ?? [];
  int get quantity => cart['quantity'];
  int get id => cart['product_id'];
  String get name => cart['product_name'];

}