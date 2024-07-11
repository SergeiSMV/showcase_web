
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/usecase_repository.dart';
import '../../riverpod/cart_provider.dart';
import '../../riverpod/token_provider.dart';
import 'hive_implements.dart';

class UseCaseImplements extends UseCaseRepository{

  @override
  void unloginProviderRef(AutoDisposeFutureProviderRef ref) {
    ref.read(tokenProvider.notifier).state = '';
    HiveImplements().saveToken('');
    ref.read(cartBadgesProvider.notifier).state = 0;
    ref.read(cartProvider.notifier).state = [];
  }
  
  @override
  void unloginWidgetRef(WidgetRef ref) {
    ref.read(tokenProvider.notifier).state = '';
    HiveImplements().saveToken('');
    ref.read(cartBadgesProvider.notifier).state = 0;
    ref.read(cartProvider.notifier).state = [];
  }
  
}