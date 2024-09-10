

// провайдер адресов клиента
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_web/data/repositories/address_implements.dart';

final addressProvider = StateProvider<List>((ref) => []);

// провайдер запроса адресов клиента
final getAddressProvider = FutureProvider.autoDispose((ref) async {
  final result = await AddressImplements().getClientAddress(ref);
  ref.read(addressProvider.notifier).state = result;
  return result;
});
