
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';


part 'request_model.freezed.dart';
part 'request_model.g.dart';

@freezed
class RequestModel with _$RequestModel {
  const RequestModel._();
  const factory RequestModel({
    required Map<String, dynamic> request,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, dynamic> json) => _$RequestModelFromJson(json);


  String get created => formatDate(request['created']);
  String get products => request['products'].length.toString();
  List get productsDetails => request['products'];
  String get total => totalPrice(request['products']);
  String get shipAddress => request['ship_to_address'];
  int get id => request['order_request_id'];

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