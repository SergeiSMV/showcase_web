
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);
final lastIndexProvider = StateProvider<int>((ref) => 0);
final lastPathProvider = StateProvider<String>((ref) => '/');