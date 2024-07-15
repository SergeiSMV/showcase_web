
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UseCaseRepository {

  void unloginProviderRef(AutoDisposeFutureProviderRef ref);

  void unloginWidgetRef(WidgetRef ref);

  Future<void> exitApp(WidgetRef ref);

  void menuElementCases(int element, WidgetRef ref, BuildContext context);

}