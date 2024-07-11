
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ResponseRepository {

  Future<List> backendGetResponses(AutoDisposeFutureProviderRef ref);

}