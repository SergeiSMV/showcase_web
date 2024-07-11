

// провайдер заказов
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/requests_implements.dart';

final requestsProvider = StateProvider<List>((ref) => []);

final baseRequestsProvider = FutureProvider.autoDispose((ref) async {
  final result = await RequestsImplements().backendGetRequests(ref);
  ref.read(requestsProvider.notifier).state = result;
  return result;
});