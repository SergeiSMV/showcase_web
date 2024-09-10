


import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AddressRepository {

  Future<List> getClientAddress(AutoDisposeFutureProviderRef ref);

  Future<List> patchClientAddress(int shipID, bool isDelete, bool isDefault, WidgetRef ref);

  Future<List> addClientAddress(String address, WidgetRef ref);

}