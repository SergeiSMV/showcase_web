
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/token_provider.dart';
import '../auth/auth_required.dart';
import 'cabinet/cabinet.dart';



class Account extends ConsumerStatefulWidget {
  const Account({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<Account> {

  @override
  Widget build(BuildContext context) {

    final String token = ref.watch(tokenProvider);

    return SafeArea(
      child: token.isEmpty ? authRequired(context) : 
      const Cabinet()
    );
  }
}