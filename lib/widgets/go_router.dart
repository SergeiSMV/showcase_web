
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/request_model/request_model.dart';
import '../data/models/response_model/response_model.dart';
import '../ui/account/account.dart';
import '../ui/account/cabinet/addresses.dart';
import '../ui/account/cabinet/request_detail.dart';
import '../ui/account/cabinet/response_detail.dart';
import '../ui/auth/auth.dart';
import '../ui/cart/additional_info.dart';
import '../ui/cart/cart.dart';
import '../ui/catalog.dart';
import '../ui/products/product_card.dart';
import '../ui/products/products_global_search.dart';
import '../ui/home.dart';
import '../ui/registration/registration.dart';
import 'shell_route_scaffold.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {        
        return ShellRouteScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Auth(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Auth()),
          routes: [
            GoRoute(
              path: 'registration',
              builder: (context, state) => const Registration(),
              pageBuilder: (context, state) => const NoTransitionPage<void>(child: Registration()),
            ),
          ]
        ),
        GoRoute(
          path: '/products/:categoryId',
          pageBuilder: (context, state) {
            final categoryID = int.parse(state.pathParameters['categoryId']!);
            // return NoTransitionPage<void>(child: ProductsScreen(key: ValueKey(categoryID), categoryID: categoryID,));
            return NoTransitionPage<void>(child: Catalog(categoryID: categoryID,));
          },
        ),
        GoRoute(
          path: '/product/:productId',
          pageBuilder: (context, state) {
            final productID = int.parse(state.pathParameters['productId']!);
            return NoTransitionPage<void>(child: ProductCard(key: ValueKey(productID), productID: productID));
          },
        ),
        GoRoute(
          path: '/global',
          builder: (context, state) => const ProductGlobalSearch(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const Cart(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Cart()),
        ),
        GoRoute(
          path: '/additinal_info',
          builder: (context, state) => const AdditionalInfo(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AdditionalInfo()),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const Account(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Account()),
        ),
        GoRoute(
          path: '/addresses',
          builder: (context, state) => const Addresses(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Addresses()),
        ),
        GoRoute(
          path: '/response_detail',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final response = extra['response'] as ResponseModel;
            return NoTransitionPage<void>(child: ResponseDetail(response: response,));
          }
        ),
        GoRoute(
          path: '/request_detail',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final request = extra['request'] as RequestModel;
            return NoTransitionPage<void>(child: RequestDetail(request: request));
          }
        ),
        /*
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: SearchScreen()),
        ),
        GoRoute(
          path: '/search_by_id',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final mainCategory = extra['mainCategory'] as String;
            final categoryID = extra['categoryID'] as int;
            return NoTransitionPage<void>(child: SearchByCategoryScreen(mainCategory: mainCategory, mainCategoryID: categoryID,));
          }
        ),
        
        */
      ],
    ),
  ], 
);
