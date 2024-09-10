
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';


part 'response_model.freezed.dart';
part 'response_model.g.dart';

@freezed
class ResponseModel with _$ResponseModel {
  const ResponseModel._();
  const factory ResponseModel({
    required Map<String, dynamic> response,
  }) = _ResponseModel;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);


  String get shipAddress => response['address'];
  String get created => formatDate(response['created']);
  bool get isDone => response['is_done'];
  String get updated => formatDate(response['updated']);
  String get products => response['products'].length.toString();
  List get productsDetails => response['products'] ?? [];
  String get total => totalPrice(response['products']);
  int get requestID => response['order_request_id'];
  int get responseID => response['order_response_id'];

}

String formatDate(String originalDateString) {
  DateTime dateTime = DateTime.parse(originalDateString);
  DateFormat outputFormat = DateFormat('dd.MM.yyyy HH:mm');
  return outputFormat.format(dateTime);
}


String totalPrice(List products){
  int sum = 0;
  for (var product in products) {
    int productTotal = (product['total'] * 100).round();
    sum += productTotal;
  }
  return (sum / 100).toStringAsFixed(2);
}