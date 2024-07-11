
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UseCaseRepository {

  void unloginProviderRef(AutoDisposeFutureProviderRef ref);

  void unloginWidgetRef(WidgetRef ref);

}