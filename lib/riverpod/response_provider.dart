
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/response_implements.dart';

// провайдер отгрузок
final responsesProvider = StateProvider<List>((ref) => []);

final baseResponsesProvider = FutureProvider.autoDispose((ref) async {
  final result = await ResposeImplements().backendGetResponses(ref);
  ref.read(responsesProvider.notifier).state = result;
  return result;
});