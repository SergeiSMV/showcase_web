import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_product_model.freezed.dart';
part 'response_product_model.g.dart';

@freezed
class ResponseProductModel with _$ResponseProductModel {
  const ResponseProductModel._();
  const factory ResponseProductModel({
    required Map<String, dynamic> product,
  }) = _ResponseProductModel;

  factory ResponseProductModel.fromJson(Map<String, dynamic> json) => _$ResponseProductModelFromJson(json);

  
  
  double get price => product['price'];
  double get total => product['total'];
  String? get comment => product['comment'];
  List get pictures => product['pictures'] ?? [];
  int get quantity => product['quantity'];
  int? get replaceQuantity => product['replace_quantity'];
  int get id => product['product_id'];
  int get replaceID => product['product_id'];
  String get name => product['product_name'];
  String? get replaceName => product['replace_product_name'];

}