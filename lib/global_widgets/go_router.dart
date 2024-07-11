
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/home.dart';
import 'shell_route_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {        
        return ShellRouteScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        /*
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Auth(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Auth()),
        ),
        GoRoute(
          path: '/registration',
          builder: (context, state) => const Registration(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Registration()),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CategoriesScreen()),
          routes: [
            GoRoute(
              path: ':categoryId',
              pageBuilder: (context, state) {
                int.parse(state.pathParameters['categoryId']!);
                final extra = state.extra as Map<String, dynamic>;
                final mainCategory = extra['mainCategory'] as String;
                final subCategories = extra['subCategories'] as List<dynamic>;
                final mainCategoryID = extra['mainCategoryID'] as int;
                return NoTransitionPage<void>(child: SubCategoriesScreen(subCategories: subCategories, mainCategory: mainCategory, mainCategoryID: mainCategoryID,));
              },
              routes: [
                GoRoute(
                  path: 'products',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    final mainCategory = extra['mainCategory'] as String;
                    final categoryID = extra['categoryID'] as int;
                    return NoTransitionPage<void>(child: ProductsScreen(categoryID: categoryID, mainCategory: mainCategory,));
                  },
                ),
              ]
            ),
          ]
        ),
        
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CartScreen()),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AccountScreen()),
        ),
        GoRoute(
          path: '/request_detail',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final request = extra['request'] as RequestModel;
            return NoTransitionPage<void>(child: RequestDetail(request: request));
          }
        ),
        GoRoute(
          path: '/response_detail',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final response = extra['response'] as ResponseModel;
            return NoTransitionPage<void>(child: ResponseDetail(response: response,));
          }
        ),
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
        GoRoute(
          path: '/addresses',
          builder: (context, state) => const ShipsView(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: ShipsView()),
        ),
        GoRoute(
          path: '/additinal_info',
          builder: (context, state) => const AdditionalInfo(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AdditionalInfo()),
        ),
        */
      ],
    ),
  ], 
);
