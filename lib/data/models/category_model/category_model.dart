
import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_data.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();
  const factory CategoryModel({
    required Map<String, dynamic> categories,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  String get name => categories['name'];
  List get children => categories['children'] ?? [];
  String get thumbnail => categories['thumbnail'] ?? categoryImagePath['empty'];
  int get id => categories['category_id'];

}