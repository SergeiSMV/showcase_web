


import 'package:freezed_annotation/freezed_annotation.dart';


part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();
  const factory ProductModel({
    required Map<String, dynamic> product,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  String get name => product['product_name'];
  String get shortName => product['short_name'];
  int get id => product['product_id'];
  List get pictures => product['pictures'] ?? [];
  String get discription => product['product_description'];
  int get quantity => product['quantity'];
  double get basePrice => product['price']['base_price'] ?? 0;
  double get clientPrice => product['price']['price'];
  int get quantyty => product['quantity'];
  String get futureDate => formatDate(product['future_date']);
  double get futurePrice => product['future_price'] ?? 0;
}

String formatDate(String? originalDateString) {
  if (originalDateString != null){
    DateTime parsedDate = DateTime.parse(originalDateString);
    String day = parsedDate.day.toString().padLeft(2, '0');
    String month = parsedDate.month.toString().padLeft(2, '0');
    String year = parsedDate.year.toString();
    return '$day.$month.$year';
  } else {
    return '';
  }
}