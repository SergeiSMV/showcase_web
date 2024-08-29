// ignore_for_file: unused_result, avoid_web_libraries_in_flutter
// подключение с другого устройства
// flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0


import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'data/repositories/hive_implements.dart';
import 'riverpod/cart_provider.dart';
import 'riverpod/categories_provider.dart';
import 'riverpod/requests_provider.dart';
import 'riverpod/response_provider.dart';
import 'riverpod/token_provider.dart';
import 'widgets/go_router.dart';
import 'widgets/scaffold_messenger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('mainStorage');
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: App()));
}


class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  Timer? connectMonitoring;

  @override
  void initState(){
    super.initState();
    isAutgorized();
    scheduleUpdater();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(baseCategoriesProvider);
    });
  }

  @override
  void dispose() {
    connectMonitoring?.cancel();
    super.dispose();
  }

  Future<void> isAutgorized() async {
    HiveImplements hive = HiveImplements();
    String token = await hive.getToken();
    if (token.isNotEmpty) {
      ref.read(tokenProvider.notifier).state = token;
      return ref.refresh(baseCartsProvider);
    }
    
  }

  void scheduleUpdater() {
    if (connectMonitoring != null) {
      connectMonitoring!.cancel();
    }
    connectMonitoring = Timer.periodic(const Duration(seconds: 10), (timer) {
      final String token = ref.read(tokenProvider);
      if (token.isNotEmpty){
        ref.refresh(baseRequestsProvider);
        ref.refresh(baseCartsProvider);
        ref.refresh(baseResponsesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prod62',
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      scaffoldMessengerKey: GlobalScaffoldMessenger.scaffoldMessengerKey,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}









// _old
/*
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/repositories/hive_implements.dart';
import 'widgets/go_router.dart';
import 'widgets/scaffold_messenger.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'riverpod/cart_provider.dart';
import 'riverpod/requests_provider.dart';
import 'riverpod/response_provider.dart';
import 'riverpod/token_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Hive.initFlutter();
  await Hive.openBox('mainStorage');
  runApp(const ProviderScope(child: App()));
}


class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  Timer? connectMonitoring;

  @override
  void initState(){
    super.initState();
    isAutgorized();
    scheduleUpdater();
  }

  @override
  void dispose() {
    connectMonitoring?.cancel();
    super.dispose();
  }

  Future<void> isAutgorized() async {
    HiveImplements hive = HiveImplements();
    String token = await hive.getToken();
    if (token.isNotEmpty) {
      ref.read(tokenProvider.notifier).state = token;
      return ref.refresh(baseCartsProvider);
    }
    
  }

  void scheduleUpdater() {
    if (connectMonitoring != null) {
      connectMonitoring!.cancel();
    }
    connectMonitoring = Timer.periodic(const Duration(seconds: 10), (timer) {
      final String token = ref.read(tokenProvider);
      if (token.isNotEmpty){
        ref.refresh(baseRequestsProvider);
        ref.refresh(baseCartsProvider);
        ref.refresh(baseResponsesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      scaffoldMessengerKey: GlobalScaffoldMessenger.scaffoldMessengerKey,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}
*/