
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../domain/repositories/usecase_repository.dart';
// import '../../riverpod/cart_provider.dart';
// import '../../ui/_old/navigator_provider.dart';
// import '../../riverpod/token_provider.dart';
// import 'hive_implements.dart';

// class UseCaseImplements extends UseCaseRepository{

//   @override
//   void unloginProviderRef(AutoDisposeFutureProviderRef ref) {
//     ref.read(tokenProvider.notifier).state = '';
//     HiveImplements().saveToken('');
//     ref.read(cartBadgesProvider.notifier).state = 0;
//     ref.read(cartProvider.notifier).state = [];
//   }
  
//   @override
//   void unloginWidgetRef(WidgetRef ref) {
//     ref.read(tokenProvider.notifier).state = '';
//     HiveImplements().saveToken('');
//     ref.read(cartBadgesProvider.notifier).state = 0;
//     ref.read(cartProvider.notifier).state = [];
//   }
  
//   @override
//   Future<void> exitApp(WidgetRef ref) async {
//     ref.read(tokenProvider.notifier).state = '';
//     ref.read(cartBadgesProvider.notifier).state = 0;
//     ref.read(cartProvider.notifier).state = [];
//     await HiveImplements().saveToken('');
//   }
  
//   @override
//   void menuElementCases(int element, WidgetRef ref, BuildContext context) {
//     ref.read(lastIndexProvider.notifier).state = ref.read(selectedIndexProvider);
//     ref.read(selectedIndexProvider.notifier).state = element;
//     switch (element) {
//       case 0: // главная страница
//         ref.read(lastPathProvider.notifier).state = '/';
//         GoRouter.of(context).go('/');
//         break;
//       case 1: // товары
//         ref.read(lastPathProvider.notifier).state = '/categories';
//         GoRouter.of(context).go('/categories');
//         break;
//       case 7: // авторизация
//         GoRouter.of(context).go('/auth');
//         break;
//       case 8: // выход
//         exitApp(ref);
//         GoRouter.of(context).go('/');
//         menuElementCases(0, ref, context);
//         break;
//     }
//   }
  
// }