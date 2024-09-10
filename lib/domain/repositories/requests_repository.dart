
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RequestsRepository {

  Future<List> backendGetRequests(AutoDisposeFutureProviderRef ref);

  Future<void> newRequests(int shipID, String comment, WidgetRef ref);

}